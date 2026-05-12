local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MatchConfig = require(ReplicatedStorage.Shared.Config.MatchConfig)
local Net = require(ReplicatedStorage.Shared.Net.Net)

local MatchService = {}

local MatchState = {
	Waiting = "Waiting",
	Running = "Running",
	Ending = "Ending",
}

local currentState = MatchState.Waiting
local matchStartedAt = 0
local playerStates = {}

function MatchService:Init()
	print("[MatchService] Init")
end

function MatchService:Start()
	print("[MatchService] Start")

	-- task.spawn(function()
	-- 	while true do
	-- 		if currentState == MatchState.Waiting and #Players:GetPlayers() > 0 then
	-- 			task.wait(5)

	-- 			if currentState == MatchState.Waiting and #Players:GetPlayers() > 0 then
	-- 				self:StartMatch()
	-- 			end
	-- 		end

	-- 		task.wait(1)
	-- 	end
	-- end)

	Net:OnServerEvent('RequestStartMatch', function(player)
		if self:IsMatchRunning() then return end

		print(player.Name .. 'Started the match!')
		self:StartMatch()
	end)
end

function MatchService:StartMatch()
	print("[MatchService] Starting match")

	currentState = MatchState.Running
	matchStartedAt = os.clock()
	playerStates = {}

	for _, player in ipairs(Players:GetPlayers()) do
		self:CreatePlayerState(player)
	end

	Net:FireAllClients("MatchStateUpdate", {
		State = currentState,
		Duration = MatchConfig.MatchDuration,
		StartedAt = matchStartedAt,
	})

	task.spawn(function()
		self:RunMatchLoop()
	end)
end

function MatchService:CreatePlayerState(player)
	local selectedCore = "Gravity"
	local AbilityConfig = require(game.ReplicatedStorage.Shared.Config.AbilityConfig)

	local abilities = {}
	for _, ability in pairs(AbilityConfig) do
		if ability.Core == selectedCore then
			abilities[ability.Id] = {
				Id = ability.Id,
				CooldownEndsAt = 0,
				BaseCooldown = ability.Cooldown,
			}
		end
	end

	local state = {
		Player = player,
		UserId = player.UserId,
		Core = selectedCore,
		MaxHealth = 100,
		Health = 100,
		Kills = 0,
		DamageDealt = 0,
		CellsEarned = 0,
		Abilities = abilities,
		Mutations = {},
		Modifiers = {},
		Effects = {},
		IsAlive = true,
	}

	playerStates[player] = state

	local abilityList = {}
	local sortedIds = {}
	for abilityId, _ in pairs(state.Abilities) do
		table.insert(sortedIds, abilityId)
	end
	table.sort(sortedIds)

	for i, id in ipairs(sortedIds) do
		abilityList[i] = {
			Id = id,
			Color = nil,
		}
	end

	Net:FireClient(player, "AbilitiesUpdate", abilityList)
end

function MatchService:AddCellsEarned(player, reward)
    self:GetPlayerState(player).CellsEarned += reward
end

function MatchService:RunMatchLoop()
	local nextMutationOfferAt = os.clock() + (MatchConfig.MutationOfferInterval or 45)

	while currentState == MatchState.Running do
		local elapsed = os.clock() - matchStartedAt
		local remaining = math.max(0, MatchConfig.MatchDuration - elapsed)

		-- Set payload
		Net:FireAllClients("HUDUpdate", {
			Type = "Timer",
			TimeRemaining = remaining,
			Elapsed = elapsed,
		})

		if os.clock() >= nextMutationOfferAt then
			local MutationService = require(script.Parent.MutationService)

			for player, state in pairs(playerStates) do
				if player.Parent == Players and state.IsAlive then
					MutationService:OfferMutations(player)
				end
			end

			nextMutationOfferAt = os.clock() + (MatchConfig.MutationOfferInterval or 45)
		end

		if elapsed >= MatchConfig.MatchDuration then
			Net:FireAllClients('HUDUpdate', {
				Type = 'Timer',
				State = MatchState.Ending,
				TimeRemaining = 0,
			})
			self:EndMatch()
			break
		end

		task.wait(1)
	end
end

function MatchService:EndMatch()
	if currentState ~= MatchState.Running then
		return
	end

	print("[MatchService] Ending match")

    local EnemyService = require(script.Parent.EnemyService)

    EnemyService:ClearEnemies()

	currentState = MatchState.Ending

	local RewardService = require(script.Parent.RewardService)

	for player, state in pairs(playerStates) do
		if player and player.Parent == Players then
			RewardService:GrantMatchReward(player, state)
		end
	end

	Net:FireAllClients("HUDUpdate", {
		Type = 'Timer',
		TimeRemaining = 0,
		State = currentState,
	}) -- tirar o timer

	Net:FireAllClients("MatchStateUpdate", {
		State = currentState,
	})

	task.wait(8)

	currentState = MatchState.Waiting
	playerStates = {}

	print("[MatchService] Back to waiting")
end

function MatchService:GetPlayerState(player)
	return playerStates[player]
end

function MatchService:GetAllPlayerStates()
	return playerStates
end

function MatchService:IsMatchRunning()
	return currentState == MatchState.Running
end

function MatchService:AddKill(player)
	local state = self:GetPlayerState(player)
	if not state then return end

	state.Kills += 1
	state.CellsEarned += MatchConfig.CellsPerKill
end

function MatchService:AddDamage(player, amount)
	local state = self:GetPlayerState(player)
	if not state then return end

	state.DamageDealt += amount
end

function MatchService:SetPlayerAlive(player, isAlive)
	local state = self:GetPlayerState(player)
	if not state then return end

	state.IsAlive = isAlive
end

return MatchService