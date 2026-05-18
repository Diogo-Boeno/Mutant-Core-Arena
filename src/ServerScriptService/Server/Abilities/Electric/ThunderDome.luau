local CombatService = require(game.ServerScriptService.Server.Services.CombatService)
local HitboxService = require(game.ServerScriptService.Server.Services.HitboxService)

return {
	Id       = "ThunderDome",
	Core     = "Electric",
	Tier     = "Ultimate",
	Cooldown = 65,

	VFX = {
		AbilityId   = "ThunderDome",
		Type        = "ExpandingArea",
		Scale       = 1.2,
		Duration    = 6.0,
		Sound       = "ThunderRoar",
		CameraShake = 0.90,
	},

	Display = {
		Name        = "Thunder Dome",
		Description = "Cria uma cúpula elétrica que fulmina inimigos por 6 segundos.",
	},

	Execute = function(player, state, origin)
		local radius    = 22 * (1 + (state.Modifiers.ThunderDomeRadius or 0))
		local damage    = 55 * (1 + (state.Modifiers.ThunderDomeDmg or 0))
		local stunDur   = 1.5 + (state.Modifiers.ThunderDomeStunDur or 0)
		local duration  = 6  + (state.Modifiers.ThunderDomeDuration or 0)
		local interval  = 0.5
		local maxTargets = 45
		local elapsed   = 0

		HitboxService:SphereTick(origin, radius, duration, interval, maxTargets, function(enemies)
			elapsed += interval
			local tickDmg = damage * interval

			-- Supercharge: damage ramps up 20% per second
			if state.Effects.ThunderDomeSupercharge then
				tickDmg = tickDmg * (1 + elapsed * 0.20)
			end

			for _, enemy in ipairs(enemies) do
				CombatService:ApplyDamage(player, enemy, tickDmg, "Electric")

				local humanoid = enemy:FindFirstChildOfClass("Humanoid")
				if humanoid then
					humanoid.PlatformStand = true
					task.delay(stunDur, function()
						if humanoid and humanoid.Parent then
							humanoid.PlatformStand = false
						end
					end)

					-- Slow inside dome
					if state.Effects.ThunderDomeSlow then
						local orig = humanoid.WalkSpeed
						humanoid.WalkSpeed = orig * 0.6
						task.delay(interval + 0.1, function()
							if humanoid and humanoid.Parent then
								humanoid.WalkSpeed = orig
							end
						end)
					end
				end

				-- Magnetic: pull toward center each tick
				if state.Effects.ThunderDomeMagnetic then
					CombatService:ApplyPull(enemy, origin, 60)
				end

				-- Shock DoT per tick
				if state.Effects.ThunderDomeShock then
					task.spawn(function()
						for _ = 1, 2 do
							local h = enemy:FindFirstChildOfClass("Humanoid")
							if not h or h.Health <= 0 then break end
							CombatService:ApplyDamage(player, enemy, 5, "Electric")
							task.wait(1)
						end
					end)
				end
			end
		end)

		-- Implode: explosion when dome ends
		if state.Effects.ThunderDomeImplode then
			task.delay(duration, function()
				local finalHit = HitboxService:Sphere(origin, radius * 1.4, maxTargets)
				for _, enemy in ipairs(finalHit) do
					CombatService:ApplyDamage(player, enemy, damage * 6, "Electric")
				end
			end)
		end
	end,
}
