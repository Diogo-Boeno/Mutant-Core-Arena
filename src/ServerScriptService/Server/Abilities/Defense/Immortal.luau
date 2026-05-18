local CombatService = require(game.ServerScriptService.Server.Services.CombatService)
local HitboxService = require(game.ServerScriptService.Server.Services.HitboxService)

return {
	Id       = "Immortal",
	Core     = "Defense",
	Tier     = "Ultimate",
	Cooldown = 120,

	VFX = {
		AbilityId   = "Immortal",
		Type        = "SelfBuff",
		Duration    = 5.0,
		Sound       = "GodMode",
		CameraShake = 0.60,
	},

	Display = {
		Name        = "Immortal",
		Description = "Fica invencível por 5 segundos.",
	},

	Execute = function(player, state, _)
		local duration = 5 + (state.Modifiers.ImmortalDuration or 0)

		local character = player.Character
		local humanoid  = character and character:FindFirstChildOfClass("Humanoid")
		local root      = character and character:FindFirstChild("HumanoidRootPart")

		state.IsInvincible   = true
		local absorbedDamage = 0

		-- Speed boost
		if state.Effects.ImmortalSpeed and humanoid then
			humanoid.WalkSpeed = humanoid.WalkSpeed * 1.5
		end

		-- Counter: +60% damage output during
		if state.Effects.ImmortalCounter then
			state.Modifiers.DamageOut = (state.Modifiers.DamageOut or 0) + 0.60
		end

		-- AoE pulse every 1s + aura slow
		local auraRunning = true
		if (state.Effects.ImmortalAoE or state.Effects.ImmortalAura) and root then
			task.spawn(function()
				while auraRunning do
					task.wait(1)
					if not root.Parent then break end

					local nearby = HitboxService:Sphere(root.Position, 16, 20)
					for _, enemy in ipairs(nearby) do
						if state.Effects.ImmortalAoE then
							CombatService:ApplyDamage(player, enemy, 15, "Defense")
						end
						if state.Effects.ImmortalAura then
							local h = enemy:FindFirstChildOfClass("Humanoid")
							if h then
								local orig = h.WalkSpeed
								h.WalkSpeed = orig * 0.65
								task.delay(1.2, function()
									if h and h.Parent then
										h.WalkSpeed = orig
									end
								end)
							end
						end
						-- Thorns: reflect damage to attackers
						if state.Effects.ImmortalThorns then
							CombatService:ApplyDamage(player, enemy, 20, "Defense")
						end
					end
				end
			end)
		end

		task.delay(duration, function()
			auraRunning         = false
			state.IsInvincible  = false

			-- Speed reset
			if state.Effects.ImmortalSpeed and humanoid and humanoid.Parent then
				humanoid.WalkSpeed = humanoid.WalkSpeed / 1.5
			end

			-- Counter reset
			if state.Effects.ImmortalCounter then
				state.Modifiers.DamageOut = math.max(0, (state.Modifiers.DamageOut or 0.60) - 0.60)
			end

			-- Heal on end
			if state.Effects.ImmortalHeal and humanoid and humanoid.Parent then
				humanoid.Health = math.min(humanoid.MaxHealth, humanoid.Health + 60)
			end

			-- Absorb: convert absorbed damage to 50% heal
			if state.Effects.ImmortalAbsorb and humanoid and humanoid.Parent then
				local healAmount = absorbedDamage * 0.5
				humanoid.Health = math.min(humanoid.MaxHealth, humanoid.Health + healAmount)
			end

			-- Final explosion
			if state.Effects.ImmortalExplosion and root and root.Parent then
				local nearby = HitboxService:Sphere(root.Position, 20, 30)
				for _, enemy in ipairs(nearby) do
					CombatService:ApplyDamage(player, enemy, 80, "Defense")
				end
			end
		end)
	end,
}
