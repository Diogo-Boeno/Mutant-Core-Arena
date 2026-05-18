local CombatService = require(game.ServerScriptService.Server.Services.CombatService)
local HitboxService = require(game.ServerScriptService.Server.Services.HitboxService)

return {
	Id       = "AbsoluteZero",
	Core     = "Ice",
	Tier     = "Ultimate",
	Cooldown = 70,

	VFX = {
		AbilityId   = "AbsoluteZero",
		Type        = "ExpandingArea",
		Scale       = 1.5,
		Duration    = 3.0,
		Sound       = "IceApocalypse",
		CameraShake = 1.0,
	},

	Display = {
		Name        = "Absolute Zero",
		Description = "Congela todos os inimigos próximos e aplica slow extremo.",
	},

	Execute = function(player, state, origin)
		local radius      = 28 * (1 + (state.Modifiers.AbsoluteZeroRadius or 0))
		local damage      = 65 * (1 + (state.Modifiers.AbsoluteZeroDmg or 0))
		local freezeDur   = 4  + (state.Modifiers.AbsoluteZeroFreezeDur or 0)
		local slowAmt     = 0.8 + (state.Modifiers.AbsoluteZeroSlowAmt or 0)
		local slowDur     = 6  + (state.Modifiers.AbsoluteZeroSlowDur or 0)
		local maxTargets  = 50

		local enemies = HitboxService:Sphere(origin, radius, maxTargets)
		for _, enemy in ipairs(enemies) do
			-- Crystal: double damage to all enemies while frozen
			local actualDmg = damage
			if state.Effects.AbsoluteZeroCrystal then
				actualDmg = actualDmg * 2
			end

			CombatService:ApplyDamage(player, enemy, actualDmg, "Ice")

			local root = enemy:FindFirstChild("HumanoidRootPart")
			if root then
				root.Anchored = true
				task.delay(freezeDur, function()
					if root and root.Parent then
						root.Anchored = false

						-- Shatter: explosion on unfreeze
						if state.Effects.AbsoluteZeroShatter then
							local ePos = root.Position
							local nearby = HitboxService:Sphere(ePos, 10, 12)
							for _, n in ipairs(nearby) do
								CombatService:ApplyDamage(player, n, damage * 0.5, "Ice")
							end
						end

						-- Ice burst: bonus damage on unfreeze
						if state.Effects.AbsoluteZeroIceBurst then
							CombatService:ApplyDamage(player, enemy, 40, "Ice")
						end

						local humanoid = enemy:FindFirstChildOfClass("Humanoid")
						if humanoid then
							local orig = humanoid.WalkSpeed
							humanoid.WalkSpeed = orig * (1 - math.min(slowAmt, 0.95))

							local actualSlowDur = slowDur
							-- Permafrost: can't recover full speed for extra 3s
							if state.Effects.AbsoluteZeroPermafrost then
								actualSlowDur = actualSlowDur + 3
							end

							task.delay(actualSlowDur, function()
								if humanoid and humanoid.Parent then
									humanoid.WalkSpeed = orig
								end
							end)
						end
					end
				end)
			end
		end
	end,
}
