local CombatService = require(game.ServerScriptService.Server.Services.CombatService)
local HitboxService = require(game.ServerScriptService.Server.Services.HitboxService)

return {
	Id       = "FrostWave",
	Core     = "Ice",
	Tier     = "Advanced",
	Cooldown = 13,

	VFX = {
		AbilityId   = "FrostWave",
		Type        = "ExpandingArea",
		Scale       = 1.0,
		Duration    = 1.0,
		Sound       = "FrostBlast",
		CameraShake = 0.42,
	},

	Display = {
		Name        = "Frost Wave",
		Description = "Onda de gelo que congela inimigos por 1.5 segundos.",
	},

	Execute = function(player, state, origin)
		local radius    = 18 * (1 + (state.Modifiers.FrostWaveRadius or 0))
		local damage    = 32 * (1 + (state.Modifiers.FrostWaveDmg or 0))
		local freezeDur = 1.5 + (state.Modifiers.FrostWaveFreezeDur or 0)
		local maxTargets = 22

		local function applyWave(waveOrigin)
			local enemies = HitboxService:Sphere(waveOrigin, radius, maxTargets)
			for _, enemy in ipairs(enemies) do
				local actualDmg = damage

				-- Shatter: bonus damage to already-frozen
				if state.Effects.FrostWaveShatter then
					local root = enemy:FindFirstChild("HumanoidRootPart")
					if root and root.Anchored then
						actualDmg = actualDmg * 1.4
					end
				end

				CombatService:ApplyDamage(player, enemy, actualDmg, "Ice")

				-- Chill: pre-slow before freeze
				if state.Effects.FrostWaveChill then
					local humanoid = enemy:FindFirstChildOfClass("Humanoid")
					if humanoid then
						local orig = humanoid.WalkSpeed
						humanoid.WalkSpeed = orig * 0.8
						task.delay(1, function()
							if humanoid and humanoid.Parent then
								humanoid.WalkSpeed = orig
							end
						end)
					end
				end

				local root = enemy:FindFirstChild("HumanoidRootPart")
				if root then
					root.Anchored = true
					task.delay(freezeDur, function()
						if root and root.Parent then
							root.Anchored = false

							-- Slow after unfreeze
							if state.Effects.FrostWaveSlow then
								local humanoid = enemy:FindFirstChildOfClass("Humanoid")
								if humanoid then
									local orig = humanoid.WalkSpeed
									humanoid.WalkSpeed = orig * 0.6
									task.delay(2, function()
										if humanoid and humanoid.Parent then
											humanoid.WalkSpeed = orig
										end
									end)
								end
							end

							-- Break explosion: enemies explode on unfreeze
							if state.Effects.FrostWaveBreak then
								local ePos = root.Position
								local nearby = HitboxService:Sphere(ePos, 8, 10)
								for _, n in ipairs(nearby) do
									CombatService:ApplyDamage(player, n, actualDmg * 0.4, "Ice")
								end
							end
						end
					end)
				end
			end

			-- Ice field: lingering slow zone
			if state.Effects.FrostWaveIceField then
				HitboxService:SphereTick(waveOrigin, radius * 0.7, 5, 0.5, maxTargets, function(lingering)
					for _, enemy in ipairs(lingering) do
						local humanoid = enemy:FindFirstChildOfClass("Humanoid")
						if humanoid then
							humanoid.WalkSpeed = math.max(4, humanoid.WalkSpeed * 0.9)
						end
					end
				end)
			end
		end

		applyWave(origin)

		if state.Effects.FrostWaveDouble then
			task.delay(0.5, function()
				applyWave(origin)
			end)
		end
	end,
}
