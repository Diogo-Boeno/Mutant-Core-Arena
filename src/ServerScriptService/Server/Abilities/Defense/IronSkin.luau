local CombatService = require(game.ServerScriptService.Server.Services.CombatService)
local HitboxService = require(game.ServerScriptService.Server.Services.HitboxService)

return {
	Id       = "IronSkin",
	Core     = "Defense",
	Tier     = "Base",
	Cooldown = 22,

	VFX = {
		AbilityId   = "IronSkin",
		Type        = "SelfBuff",
		Duration    = 6.0,
		Sound       = "MetalClank",
		CameraShake = 0,
	},

	Display = {
		Name        = "Iron Skin",
		Description = "Reduz o dano recebido em 50% por 6 segundos.",
	},

	Execute = function(player, state, _)
		local reduction = 0.5 + (state.Modifiers.IronSkinReduction or 0)
		local duration  = 6  + (state.Modifiers.IronSkinDuration or 0)

		local character = player.Character
		local humanoid  = character and character:FindFirstChildOfClass("Humanoid")
		local root      = character and character:FindFirstChild("HumanoidRootPart")

		-- AoE burst on activation
		if state.Effects.IronSkinAoE and root then
			local nearby = HitboxService:Sphere(root.Position, 10, 15)
			for _, enemy in ipairs(nearby) do
				CombatService:ApplyDamage(player, enemy, 25, "Defense")
			end
		end

		-- Speed boost during
		if state.Effects.IronSkinSpeed and humanoid then
			humanoid.WalkSpeed = humanoid.WalkSpeed * 1.3
		end

		-- Immunity: prevent slow/stun (set flag in state)
		if state.Effects.IronSkinImmunity then
			state.IsImmune = true
		end

		state.Modifiers.DamageReduction = (state.Modifiers.DamageReduction or 0) + reduction

		task.delay(duration, function()
			state.Modifiers.DamageReduction = math.max(0, (state.Modifiers.DamageReduction or reduction) - reduction)

			if state.Effects.IronSkinImmunity then
				state.IsImmune = false
			end

			-- Speed reset
			if state.Effects.IronSkinSpeed and humanoid and humanoid.Parent then
				humanoid.WalkSpeed = humanoid.WalkSpeed / 1.3
			end

			-- Heal on end
			if state.Effects.IronSkinHeal and humanoid and humanoid.Parent then
				humanoid.Health = math.min(humanoid.MaxHealth, humanoid.Health + 30)
			end

			-- Counter: damage bonus for 4s after
			if state.Effects.IronSkinCounter then
				state.Modifiers.DamageOut = (state.Modifiers.DamageOut or 0) + 0.40
				task.delay(4, function()
					state.Modifiers.DamageOut = math.max(0, (state.Modifiers.DamageOut or 0.40) - 0.40)
				end)
			end
		end)
	end,
}
