local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MutationConfig = require(ReplicatedStorage.Shared.Config.MutationConfig)
local MatchConfig = require(ReplicatedStorage.Shared.Config.MatchConfig)
local Net = require(ReplicatedStorage.Shared.Net.Net)

local MutationService = {}

function MutationService:Init()
	print("[MutationService] Init")
end

function MutationService:Start()
	print("[MutationService] Start")

	Net:OnServerEvent("MutationChoice", function(player, mutationId)
		self:ApplyMutation(player, mutationId)
	end)
end

function MutationService:OfferMutations(player)
	local MatchService = require(script.Parent.MatchService)
	local state = MatchService:GetPlayerState(player)

	if not state or not state.IsAlive then
		return
	end

	local choices = self:RollChoices(state, MatchConfig.MutationChoices or 3)

	if #choices <= 0 then
		return
	end

	Net:FireClient(player, "MutationOffer", {
		Choices = choices,
	})
end

function MutationService:RollChoices(state, amount)
	local pool = {}

	for id, mutation in pairs(MutationConfig) do
		if mutation.Core == state.Core then
			local currentStacks = state.Mutations[id] or 0

			if currentStacks < mutation.MaxStacks then
				table.insert(pool, mutation)
			end
		end
	end

	local choices = {}

	while #choices < amount and #pool > 0 do
		local selectedIndex = self:WeightedPickIndex(pool)
		local selected = pool[selectedIndex]

		table.insert(choices, {
			Id = selected.Id,
			DisplayName = selected.DisplayName,
			Description = selected.Description,
			Rarity = selected.Rarity,
			MaxStacks = selected.MaxStacks,
			CurrentStacks = state.Mutations[selected.Id] or 0,
		})

		table.remove(pool, selectedIndex)
	end

	return choices
end

function MutationService:WeightedPickIndex(pool)
	local totalWeight = 0

	for _, item in ipairs(pool) do
		totalWeight += item.Weight or 1
	end

	local roll = math.random() * totalWeight
	local running = 0

	for index, item in ipairs(pool) do
		running += item.Weight or 1

		if roll <= running then
			return index
		end
	end

	return #pool
end

function MutationService:ApplyMutation(player, mutationId)
	local MatchService = require(script.Parent.MatchService)
	local state = MatchService:GetPlayerState(player)

	if not state or not state.IsAlive then
		return
	end

	local mutation = MutationConfig[mutationId]

	if not mutation then
		warn("[MutationService] Invalid mutation:", mutationId)
		return
	end

	if mutation.Core ~= state.Core then
		warn("[MutationService] Mutation core mismatch:", mutationId)
		return
	end

	local currentStacks = state.Mutations[mutationId] or 0

	if currentStacks >= mutation.MaxStacks then
		warn("[MutationService] Max stacks reached:", mutationId)
		return
	end

	state.Mutations[mutationId] = currentStacks + 1

	self:RecalculateState(state)

	print("[MutationService]", player.Name, "picked", mutationId, "stack", state.Mutations[mutationId])

	Net:FireClient(player, "HUDUpdate", {
		Type = "MutationApplied",
		MutationId = mutationId,
		DisplayName = mutation.DisplayName,
		Stacks = state.Mutations[mutationId],
		Modifiers = state.Modifiers,
		Effects = state.Effects,
	})

	Net:FireAllClients("ClientVFX", {
		Type = "MutationApplied",
		UserId = player.UserId,
		MutationId = mutationId,
	})
end

function MutationService:RecalculateState(state)
	state.Modifiers = {}
	state.Effects = {}

	for mutationId, stacks in pairs(state.Mutations) do
		local mutation = MutationConfig[mutationId]

		if mutation then
			if mutation.Modifiers then
				for modifierName, value in pairs(mutation.Modifiers) do
					state.Modifiers[modifierName] = (state.Modifiers[modifierName] or 0) + (value * stacks)
				end
			end

			if mutation.Effects then
				for effectName, enabled in pairs(mutation.Effects) do
					if enabled then
						state.Effects[effectName] = true
					end
				end
			end
		end
	end
end

return MutationService