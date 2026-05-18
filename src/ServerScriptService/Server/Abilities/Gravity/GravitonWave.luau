local CombatService = require(game.ServerScriptService.Server.Services.CombatService)
local HitboxService = require(game.ServerScriptService.Server.Services.HitboxService)

return {
	Id       = "GravitonWave",
	Core     = "Gravity",
	Tier     = "Advanced",
	Cooldown = 10,

	VFX = {
		AbilityId   = "GravitonWave",
		Type        = "ExpandingArea",
		Scale       = 1,
		Duration    = 0.8,
		Sound       = "GravityWave",
		CameraShake = 0.45,
	},

	Display = {
		Name        = "Graviton Wave",
		Description = "Onda gravitacional que puxa e aplica slow nos inimigos.",
	},

	Execute = function(player, state, origin)
		local radius     = 20 * (1 + (state.Modifiers.AreaRadius or 0) + (state.Modifiers.GravitonWaveRadius or 0))
		local damage     = 35 * (1 + (state.Modifiers.GravitonWaveDmg or 0))
		local pullForce  = 90 + (state.Modifiers.GravitonWavePull or 0)
		local slowAmount = 0.4 + (state.Modifiers.GravitonWaveSlowAmt or 0)
		local slowDur    = 3 + (state.Modifiers.GravitonWaveSlowDur or 0)
		local maxTargets = 25

		local function applyWave(waveOrigin)
			local enemies = HitboxService:Sphere(waveOrigin, radius, maxTargets)
			for _, enemy in ipairs(enemies) do
				CombatService:ApplyDamage(player, enemy, damage, "Gravity")
				CombatService:ApplyPull(enemy, waveOrigin, pullForce)

				local humanoid = enemy:FindFirstChildOfClass("Humanoid")
				if humanoid then
					-- Stun before slow
					if state.Effects.GravitonWaveStun then
						humanoid.PlatformStand = true
						task.delay(0.8, function()
							if humanoid and humanoid.Parent then
								humanoid.PlatformStand = false
							end
						end)
					end

					local origSpeed = humanoid.WalkSpeed
					humanoid.WalkSpeed = origSpeed * (1 - math.min(slowAmount, 0.9))

					task.delay(slowDur, function()
						if humanoid and humanoid.Parent then
							humanoid.WalkSpeed = origSpeed

							-- Implode: enemy explodes when slow ends
							if state.Effects.GravitonWaveImplode then
								local eRoot = enemy:FindFirstChild("HumanoidRootPart")
								local ePos  = eRoot and eRoot.Position or waveOrigin
								local nearby = HitboxService:Sphere(ePos, 8, 10)
								for _, n in ipairs(nearby) do
									CombatService:ApplyDamage(player, n, damage * 0.5, "Gravity")
								end
							end
						end
					end)
				end

				-- DoT: 8 dmg/s for 4s
				if state.Effects.GravitonWaveDoT then
					task.spawn(function()
						for _ = 1, 4 do
							local h = enemy:FindFirstChildOfClass("Humanoid")
							if not h or h.Health <= 0 then break end
							CombatService:ApplyDamage(player, enemy, 8, "Gravity")
							task.wait(1)
						end
					end)
				end
			end
		end

		applyWave(origin)

		if state.Effects.GravitonWaveDouble then
			task.delay(0.6, function()
				applyWave(origin)
			end)
		end
	end,
}
