local CombatService = require(game.ServerScriptService.Server.Services.CombatService)

return {
	Id       = "GravitonWave",
	Core     = "Gravity",
	Tier     = "Advanced",
	Cooldown = 10,

	VFX = {
		AbilityId   = "GravitonWave",
		Type        = "ExpandingArea",
		Scale       = 1,
		Duration    = 0.8,
		Sound       = "GravityWave",
		CameraShake = 0.45,
	},

	Display = {
		Name        = "Graviton Wave",
		Description = "Onda gravitacional que puxa e aplica slow nos inimigos.",
	},

	Execute = function(player, state, origin)
		local radius     = 20 * (1 + (state.Modifiers.AreaRadius or 0))
		local damage     = 35
		local pullForce  = 90
		local slowAmount = 0.4 -- 40%
		local slowDuration = 3
		local maxTargets = 25

		local enemies = CombatService:GetEnemiesInRadius(origin, radius, maxTargets)
		for _, enemy in ipairs(enemies) do
			CombatService:ApplyDamage(player, enemy, damage, "Gravity")
			CombatService:ApplyPull(enemy, origin, pullForce)

			-- Slow
			local humanoid = enemy:FindFirstChildOfClass("Humanoid")
			if humanoid then
				local originalSpeed = humanoid.WalkSpeed
				humanoid.WalkSpeed = originalSpeed * (1 - slowAmount)
				task.delay(slowDuration, function()
					if humanoid and humanoid.Parent then
						humanoid.WalkSpeed = originalSpeed
					end
				end)
			end
		end
	end,
}
