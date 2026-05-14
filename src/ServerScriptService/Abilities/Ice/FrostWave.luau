local CombatService = require(game.ServerScriptService.Server.Services.CombatService)

return {
	Id       = "FrostWave",
	Core     = "Ice",
	Tier     = "Advanced",
	Cooldown = 13,

	VFX = {
		AbilityId   = "FrostWave",
		Type        = "ExpandingArea",
		Scale       = 1.0,
		Duration    = 1.0,
		Sound       = "FrostBlast",
		CameraShake = 0.42,
	},

	Display = {
		Name        = "Frost Wave",
		Description = "Onda de gelo que congela inimigos por 1.5 segundos.",
	},

	Execute = function(player, state, origin)
		local radius        = 18
		local damage        = 32
		local freezeDuration = 1.5
		local maxTargets    = 22

		local enemies = CombatService:GetEnemiesInRadius(origin, radius, maxTargets)
		for _, enemy in ipairs(enemies) do
			CombatService:ApplyDamage(player, enemy, damage, "Ice")

			-- Freeze (ancora o root)
			local root = enemy:FindFirstChild("HumanoidRootPart")
			if root then
				root.Anchored = true
				task.delay(freezeDuration, function()
					if root and root.Parent then
						root.Anchored = false
					end
				end)
			end
		end
	end,
}
