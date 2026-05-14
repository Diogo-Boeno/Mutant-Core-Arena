local CombatService = require(game.ServerScriptService.Server.Services.CombatService)

return {
	Id      = "GravityPulse",
	Core    = "Gravity",
	Tier    = "Base",
	Cooldown = 1,

	VFX = {
		AbilityId   = "GravityPulse",
		Type        = "ExpandingArea",
		Scale       = 0.8,
		Duration    = 0.8,
		Sound       = "GravityPulseBoom",
		CameraShake = 0.35,
	},

	Display = {
		Name        = "Gravity Pulse",
		Description = "Emite uma onda de gravidade que empurra inimigos próximos.",
	},

	Execute = function(player, state, origin)
		local radius     = 12 * (1 + (state.Modifiers.AreaRadius or 0))
		local damage     = 20 * (1 + (state.Modifiers.GravityPulseDamageMultiplier or 0))
		local maxTargets = 15

		local enemies = CombatService:GetEnemiesInRadius(origin, radius, maxTargets)
		for _, enemy in ipairs(enemies) do
			CombatService:ApplyDamage(player, enemy, damage, "Gravity")
			CombatService:ApplyPull(enemy, origin, 0) -- 0 = empurra
		end

		-- Mutação: segundo pulso menor
		if state.Effects.DoublePulse then
			task.delay(0.45, function()
				local secondEnemies = CombatService:GetEnemiesInRadius(origin, radius * 0.7, maxTargets)
				for _, enemy in ipairs(secondEnemies) do
					CombatService:ApplyDamage(player, enemy, damage * 0.45, "Gravity")
					CombatService:ApplyPull(enemy, origin, 0)
				end
			end)
		end
	end,
}
