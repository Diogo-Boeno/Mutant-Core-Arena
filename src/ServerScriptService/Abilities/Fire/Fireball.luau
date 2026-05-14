local CombatService = require(game.ServerScriptService.Server.Services.CombatService)

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
		local radius     = 8
		local damage     = 15
		local burnDamage = 5   -- por segundo
		local burnDuration = 4
		local maxTargets = 10

		local enemies = CombatService:GetEnemiesInRadius(origin, radius, maxTargets)
		for _, enemy in ipairs(enemies) do
			CombatService:ApplyDamage(player, enemy, damage, "Fire")

			-- Queimadura (DoT)
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
	end,
}
