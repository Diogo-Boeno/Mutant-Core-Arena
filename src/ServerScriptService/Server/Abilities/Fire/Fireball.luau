local CombatService = require(game.ServerScriptService.Server.Services.CombatService)
local HitboxService = require(game.ServerScriptService.Server.Services.HitboxService)

return {
	Id       = "Fireball",
	Core     = "Fire",
	Tier     = "Base",
	Cooldown = 3,

	VFX = {
		AbilityId       = "Fireball",
		Type            = "Projectile",
		ProjectileSpeed = 30,
		Duration        = 2.0,
		Sound           = "FireballWhoosh",
		CameraShake     = 0.15,
	},

	Display = {
		Name        = "Fireball",
		Description = "Lança uma bola de fogo que causa dano e queimadura.",
	},

	Execute = function(player, state, origin)
		local speed       = 30 + (state.Modifiers.FireballSpeed or 0)
		local maxDistance = speed * 2
		local hitRadius   = 4 * (1 + (state.Modifiers.FireballRadius or 0))
		local damage      = 15 * (1 + (state.Modifiers.FireballDmg or 0))
		local burnDmg     = 5  * (1 + (state.Modifiers.FireballBurnDmg or 0))
		local burnDur     = 4  + (state.Modifiers.FireballBurnDur or 0)
		local maxTargets  = 10

		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if not root then return end

		local function launchFireball(launchOrigin, direction)
			local pierce = state.Effects.FireballPierce

			HitboxService:Projectile(launchOrigin, direction, speed, maxDistance, hitRadius, maxTargets, function(enemies)
				for _, enemy in ipairs(enemies) do
					CombatService:ApplyDamage(player, enemy, damage, "Fire")

					task.spawn(function()
						local elapsed = 0
						while elapsed < burnDur do
							local humanoid = enemy:FindFirstChildOfClass("Humanoid")
							if not humanoid or humanoid.Health <= 0 then break end
							CombatService:ApplyDamage(player, enemy, burnDmg, "Fire")
							task.wait(1)
							elapsed += 1
						end
					end)

					-- Explosive: AOE sphere on hit
					if state.Effects.FireballExplosive then
						local eRoot = enemy:FindFirstChild("HumanoidRootPart")
						if eRoot then
							local nearby = HitboxService:Sphere(eRoot.Position, hitRadius * 2, 8)
							for _, n in ipairs(nearby) do
								if n ~= enemy then
									CombatService:ApplyDamage(player, n, damage * 0.5, "Fire")
								end
							end
						end
					end

					-- Split: 3 small mini-fireballs that fan out
					if state.Effects.FireballSplit then
						local eRoot = enemy:FindFirstChild("HumanoidRootPart")
						local splitOrigin = eRoot and eRoot.Position or launchOrigin
						local perpendiculars = {
							direction,
							CFrame.Angles(0, math.rad(30), 0).LookVector,
							CFrame.Angles(0, math.rad(-30), 0).LookVector,
						}
						for _, splitDir in ipairs(perpendiculars) do
							HitboxService:Projectile(splitOrigin, splitDir, speed * 0.8, maxDistance * 0.5, hitRadius * 0.6, 5, function(splitEnemies)
								for _, se in ipairs(splitEnemies) do
									CombatService:ApplyDamage(player, se, damage * 0.4, "Fire")
								end
							end)
						end
					end
				end

				return pierce -- returning true from callback would need HitboxService support; pierce is passthrough
			end)
		end

		local direction = root.CFrame.LookVector
		launchFireball(origin, direction)

		-- Double: second fireball with slight angle
		if state.Effects.FireballDouble then
			local offsetDir = CFrame.Angles(0, math.rad(8), 0):VectorToWorldSpace(direction)
			launchFireball(origin, offsetDir)
		end
	end,
}
