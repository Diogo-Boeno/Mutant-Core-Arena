local CombatService = require(game.ServerScriptService.Server.Services.CombatService)
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
		local meteorCount  = 8
		local fallRadius   = 30
		local damage       = 30
		local burnDamage   = 12
		local burnDuration = 4
		local impactRadius = 8
		local maxTargets   = 40

		for i = 1, meteorCount do
			task.spawn(function()
				task.wait((i - 1) * 0.3)

				local angle      = math.random() * math.pi * 2
				local dist       = math.random() * fallRadius
				local offset     = Vector3.new(math.cos(angle), 0, math.sin(angle)) * dist
				local impactPoint = origin + offset

				-- VFX do impacto individual
				Net:FireAllClients("ClientVFX", {
					AbilityId   = "HellfireStorm",
					Type        = "ExpandingArea",
					Scale       = 0.5,
					Duration    = 0.6,
					Sound       = "MeteorImpact",
					CameraShake = 0.2,
					Origin      = impactPoint,
					UserId      = player.UserId,
				})

				local enemies = CombatService:GetEnemiesInRadius(impactPoint, impactRadius, maxTargets)
				for _, enemy in ipairs(enemies) do
					CombatService:ApplyDamage(player, enemy, damage, "Fire")

					task.spawn(function()
						local elapsed = 0
						while elapsed < burnDuration do
							local humanoid = enemy:FindFirstChildOfClass("Humanoid")
							if not humanoid or humanoid.Health <= 0 then break end
							CombatService:ApplyDamage(player, enemy, burnDamage, "Fire")
							task.wait(1)
							elapsed += 1
						end
					end)
				end
			end)
		end
	end,
}
