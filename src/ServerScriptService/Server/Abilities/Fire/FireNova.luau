local CombatService = require(game.ServerScriptService.Server.Services.CombatService)

return {
	Id       = "FireNova",
	Core     = "Fire",
	Tier     = "Advanced",
	Cooldown = 12,

	VFX = {
		AbilityId   = "FireNova",
		Type        = "ExpandingArea",
		Scale       = 1,
		Duration    = 5.0,
		Sound       = "FireExplosion",
		CameraShake = 0.40,
	},

	Display = {
		Name        = "Fire Nova",
		Description = "Explosão de fogo em área ampla com queimadura.",
	},

	Execute = function(player, state, origin)
		local radius       = 24
		local damage       = 30
		local burnDamage   = 8
		local burnDuration = 4
		local maxTargets   = 20

		local enemies = CombatService:GetEnemiesInRadius(origin, radius, maxTargets)
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
	end,
}
