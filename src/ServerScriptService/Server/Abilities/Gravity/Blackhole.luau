local CombatService = require(game.ServerScriptService.Server.Services.CombatService)
local HitboxService = require(game.ServerScriptService.Server.Services.HitboxService)

return {
	Id       = "Blackhole",
	Core     = "Gravity",
	Tier     = "Ultimate",
	Cooldown = 60,

	VFX = {
		AbilityId   = "Blackhole",
		Type        = "ExpandingArea",
		Scale       = 0.8,
		Duration    = 5.0,
		Sound       = "BlackholeRoar",
		CameraShake = 0.75,
	},

	Display = {
		Name        = "Blackhole",
		Description = "Cria um buraco negro que puxa todos os inimigos por 6 segundos.",
	},

	Execute = function(player, state, origin)
		local radius     = 25 * (1 + (state.Modifiers.AreaRadius or 0) + (state.Modifiers.BlackholeRadius or 0))
		local damage     = 10 * (1 + (state.Modifiers.BlackholeDmg or 0))
		local pullForce  = 150 + (state.Modifiers.BlackholePull or 0)
		local duration   = 6 + (state.Modifiers.BlackholeDuration or 0)
		local interval   = 0.5
		local maxTargets = 50
		local tickCount  = 0

		-- Freeze first tick
		if state.Effects.BlackholeFreeze then
			local firstHit = HitboxService:Sphere(origin, radius, maxTargets)
			for _, enemy in ipairs(firstHit) do
				local root = enemy:FindFirstChild("HumanoidRootPart")
				if root then
					root.Anchored = true
					task.delay(1.5, function()
						if root and root.Parent then
							root.Anchored = false
						end
					end)
				end
			end
		end

		HitboxService:SphereTick(origin, radius, duration, interval, maxTargets, function(enemies)
			tickCount += 1
			for _, enemy in ipairs(enemies) do
				local centerDist = 0
				local eRoot = enemy:FindFirstChild("HumanoidRootPart")
				if eRoot then
					centerDist = (eRoot.Position - origin).Magnitude
				end

				local tickDmg = damage
				-- Singularity: double damage in the inner half
				if state.Effects.BlackholeSingularity and centerDist < radius * 0.5 then
					tickDmg = tickDmg * 2
				end

				CombatService:ApplyDamage(player, enemy, tickDmg, "Gravity")
				CombatService:ApplyPull(enemy, origin, pullForce)

				-- Kills restore health
				if state.Effects.BlackholeAbsorb then
					local humanoid = enemy:FindFirstChildOfClass("Humanoid")
					if humanoid and humanoid.Health <= 0 then
						local caster = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
						if caster then
							caster.Health = math.min(caster.MaxHealth, caster.Health + 15)
						end
					end
				end
			end
		end)

		-- Implode explosion at end
		if state.Effects.BlackholeImplode then
			task.delay(duration, function()
				local finalHit = HitboxService:Sphere(origin, radius * 1.5, maxTargets)
				for _, enemy in ipairs(finalHit) do
					CombatService:ApplyDamage(player, enemy, damage * 8, "Gravity")
				end
			end)
		end

		-- Slow field after expiry
		if state.Effects.BlackholeSlowField then
			task.delay(duration, function()
				HitboxService:SphereTick(origin, radius, 4, 0.5, maxTargets, function(enemies)
					for _, enemy in ipairs(enemies) do
						local humanoid = enemy:FindFirstChildOfClass("Humanoid")
						if humanoid then
							humanoid.WalkSpeed = math.max(4, humanoid.WalkSpeed * 0.85)
						end
					end
				end)
			end)
		end
	end,
}
