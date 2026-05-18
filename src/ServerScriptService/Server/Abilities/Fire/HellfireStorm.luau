local CombatService = require(game.ServerScriptService.Server.Services.CombatService)
local HitboxService = require(game.ServerScriptService.Server.Services.HitboxService)
local Net = require(game.ReplicatedStorage.Shared.Net.Net)

return {
	Id       = "HellfireStorm",
	Core     = "Fire",
	Tier     = "Ultimate",
	Cooldown = 55,

	VFX = {
		AbilityId       = "HellfireStorm",
		Type            = "Projectile",
		ProjectileSpeed = 80,
		Duration        = 3.0,
		Sound           = "ApocalypseFire",
		CameraShake     = 0.80,
	},

	Display = {
		Name        = "Hellfire Storm",
		Description = "Chuva de meteoros que devastam a área.",
	},

	Execute = function(player, state, origin)
		local meteorCount  = 8  + (state.Modifiers.HellfireStormCount or 0)
		local fallRadius   = 30
		local damage       = 30 * (1 + (state.Modifiers.HellfireStormDmg or 0))
		local burnDmg      = 12
		local burnDur      = 4  + (state.Modifiers.HellfireStormBurnDur or 0)
		local impactRadius = 8  * (1 + (state.Modifiers.HellfireStormRadius or 0))
		local maxTargets   = 40

		-- Focus: all meteors land at origin
		local useFocus = state.Effects.HellfireStormFocus

		for i = 1, meteorCount do
			local isLast = (i == meteorCount)

			task.spawn(function()
				task.wait((i - 1) * 0.3)

				local impactPoint
				if useFocus then
					impactPoint = origin
				else
					local angle = math.random() * math.pi * 2
					local dist  = math.random() * fallRadius
					impactPoint = origin + Vector3.new(math.cos(angle), 0, math.sin(angle)) * dist
				end

				local meteorDmg = damage
				local meteorRadius = impactRadius
				if isLast and state.Effects.HellfireStormFinalBlast then
					meteorDmg    = meteorDmg * 3
					meteorRadius = meteorRadius * 3
				end

				Net:FireAllClients("ClientVFX", {
					AbilityId   = "HellfireStorm",
					VFXType     = "ExpandingArea",
					VFXScale    = isLast and (state.Effects.HellfireStormFinalBlast and 1.5 or 0.5) or 0.5,
					VFXDuration = 0.6,
					Sound       = "MeteorImpact",
					CameraShake = 0.2,
					Origin      = impactPoint,
					UserId      = player.UserId,
				})

				local enemies = HitboxService:Sphere(impactPoint, meteorRadius, maxTargets)
				for _, enemy in ipairs(enemies) do
					CombatService:ApplyDamage(player, enemy, meteorDmg, "Fire")

					-- Stun per meteor
					if state.Effects.HellfireStormStun then
						local humanoid = enemy:FindFirstChildOfClass("Humanoid")
						if humanoid then
							humanoid.PlatformStand = true
							task.delay(0.5, function()
								if humanoid and humanoid.Parent then
									humanoid.PlatformStand = false
								end
							end)
						end
					end

					-- Chain: damage nearby non-hit enemies
					if state.Effects.HellfireStormChain then
						local eRoot = enemy:FindFirstChild("HumanoidRootPart")
						if eRoot then
							local nearby = HitboxService:Sphere(eRoot.Position, 8, 5)
							for _, n in ipairs(nearby) do
								if n ~= enemy then
									CombatService:ApplyDamage(player, n, meteorDmg * 0.4, "Fire")
								end
							end
						end
					end

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
				end

				-- Inferno: lingering ground fire
				if state.Effects.HellfireStormInferno then
					HitboxService:SphereTick(impactPoint, meteorRadius * 0.8, 4, 0.5, 20, function(lingering)
						for _, enemy in ipairs(lingering) do
							CombatService:ApplyDamage(player, enemy, burnDmg * 0.5, "Fire")
						end
					end)
				end
			end)
		end
	end,
}
