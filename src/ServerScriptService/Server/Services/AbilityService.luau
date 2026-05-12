local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = require(ReplicatedStorage.Shared.Net.Net)
local ComponentResolver = require(script.Parent.Parent.Systems.ComponentResolver) -- ajuste o caminho se necessário

local AbilityService = {}

-- Cache de módulos de componentes
local componentModules = {
	AreaDamage = require(script.Parent.Parent.Components.AreaDamage),
	Pull = require(script.Parent.Parent.Components.Pull),
	DamageOverTime = require(script.Parent.Parent.Components.DamageOverTime),
	StatusEffect = require(script.Parent.Parent.Components.StatusEffect),
	SelfBuff = require(script.Parent.Parent.Components.SelfBuff),
	Shield = require(script.Parent.Parent.Components.Shield),
	Dash = require(script.Parent.Parent.Components.Dash),
	Teleport = require(script.Parent.Parent.Components.Teleport),
	PersistentArea = require(script.Parent.Parent.Components.PersistentArea),
	MeteorShower = require(script.Parent.Parent.Components.MeteorShower),
	ChainDamage = require(script.Parent.Parent.Components.ChainDamage),
	Visual = require(script.Parent.Parent.Components.Visual),
}

function AbilityService:Init()
	print("[AbilityService] Init")
end

function AbilityService:Start()
	print("[AbilityService] Start")
	Net:OnServerEvent("AbilityRequest", function(player, abilityId)
		self:ActivateAbility(player, abilityId)
	end)
end

function AbilityService:ActivateAbility(player, abilityId)
	local MatchService = require(script.Parent.MatchService)

	if not MatchService:IsMatchRunning() then return end

	local state = MatchService:GetPlayerState(player)
	if not state or not state.IsAlive then return end

	local abilityState = state.Abilities[abilityId]
	if not abilityState then
		warn("[AbilityService] Ability not found in player state:", abilityId)
		return
	end

	local now = os.clock()
	if now < abilityState.CooldownEndsAt then
		local remaining = abilityState.CooldownEndsAt - now
		Net:FireClient(player, "HUDUpdate", {
			Type = "AbilityCooldown",
			AbilityId = abilityId,
			Remaining = remaining,
		})
		return
	end

	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	-- Resolver componentes com modificadores atuais
	local components = ComponentResolver.Resolve(abilityId, state)

	-- Calcular cooldown final (usando modificador global)
	local cooldown = abilityState.BaseCooldown or 0
	cooldown = cooldown * (1 + (state.Modifiers.GlobalCooldown or 0))
	abilityState.CooldownEndsAt = now + cooldown

	-- Executar componentes em sequência
	local origin = root.Position
	for _, comp in ipairs(components) do
		task.spawn(function()
			local module = componentModules[comp.Type]
			if module then
				module:Execute(player, state, comp, origin)
			else
				warn("[AbilityService] Missing component module:", comp.Type)
			end
		end)
	end

	-- Notificar usado
	Net:FireClient(player, "HUDUpdate", {
		Type = "AbilityUsed",
		AbilityId = abilityId,
		Cooldown = cooldown,
	})
end

return AbilityService