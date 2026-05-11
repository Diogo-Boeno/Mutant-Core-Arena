local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AbilityConfig = require(ReplicatedStorage.Shared.Config.AbilityConfig)
local Net = require(ReplicatedStorage.Shared.Net.Net)

local AbilityService = {}

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
	local CombatService = require(script.Parent.CombatService)

	if not MatchService:IsMatchRunning() then
		return
	end

	local state = MatchService:GetPlayerState(player)
	if not state or not state.IsAlive then
		return
	end

	local abilityState = state.Abilities[abilityId]
	local config = AbilityConfig[abilityId]

	if not abilityState or not config then
		warn("[AbilityService] Invalid ability:", abilityId)
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

	if not root then
		return
	end

	local stats = self:GetModifiedAbilityStats(state, config)

	abilityState.CooldownEndsAt = now + stats.Cooldown

	Net:FireClient(player, "HUDUpdate", {
		Type = "AbilityUsed",
		AbilityId = abilityId,
		Cooldown = stats.Cooldown,
	})

	if abilityId == "GravityPulse" then
		CombatService:ExecuteGravityPulse(player, state, root.Position, stats)
	end
end

function AbilityService:GetModifiedAbilityStats(state, config)
	local radiusMultiplier = state.Modifiers.GravityPulseRadiusMultiplier or 0
	local damageMultiplier = state.Modifiers.GravityPulseDamageMultiplier or 0
	local cooldownMultiplier = state.Modifiers.GravityPulseCooldownMultiplier or 0

	local cooldown = config.Cooldown * (1 + cooldownMultiplier)

	return {
		Radius = config.Radius * (1 + radiusMultiplier),
		Damage = config.Damage * (1 + damageMultiplier),
		Cooldown = math.max(2, cooldown),
		PullForce = config.PullForce,
		MaxTargets = config.Server.MaxTargets,
	}
end

return AbilityService