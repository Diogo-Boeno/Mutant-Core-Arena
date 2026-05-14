local CombatService = require(game.ServerScriptService.Server.Services.CombatService)

return {
	Id       = "ChainLightning",
	Core     = "Electric",
	Tier     = "Advanced",
	Cooldown = 11,

	VFX = {
		AbilityId   = "ChainLightning",
		Type        = "ExpandingArea",
		Scale       = 0.8,
		Duration    = 0.6,
		Sound       = "ChainZap",
		CameraShake = 0.35,
	},

	Display = {
		Name        = "Chain Lightning",
		Description = "Raio que salta entre até 5 inimigos.",
	},

	Execute = function(player, state, origin)
		local radius       = 10
		local damage       = 22
		local chains       = 5
		local stunDuration = 0.5
		local maxTargets   = 30

		local enemies = CombatService:GetEnemiesInRadius(origin, radius, maxTargets)

		for i = 1, math.min(chains, #enemies) do
			local enemy = enemies[i]
			CombatService:ApplyDamage(player, enemy, damage, "Electric")

			local humanoid = enemy:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.PlatformStand = true
				task.delay(stunDuration, function()
					if humanoid and humanoid.Parent then
						humanoid.PlatformStand = false
					end
				end)
			end
		end
	end,
}
