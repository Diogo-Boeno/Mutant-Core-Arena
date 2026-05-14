local CombatService = require(game.ServerScriptService.Server.Services.CombatService)

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
		local radius     = 25 * (1 + (state.Modifiers.AreaRadius or 0))
		local damage     = 10
		local pullForce  = 150
		local duration   = 6
		local interval   = 0.5
		local maxTargets = 50

		local startTime = os.clock()

		task.spawn(function()
			while os.clock() - startTime < duration do
				local enemies = CombatService:GetEnemiesInRadius(origin, radius, maxTargets)
				for _, enemy in ipairs(enemies) do
					CombatService:ApplyDamage(player, enemy, damage, "Gravity")
					CombatService:ApplyPull(enemy, origin, pullForce)
				end
				task.wait(interval)
			end
		end)
	end,
}
