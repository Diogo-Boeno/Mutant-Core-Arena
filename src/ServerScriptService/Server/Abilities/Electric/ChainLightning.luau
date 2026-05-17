local CombatService = require(game.ServerScriptService.Server.Services.CombatService)
local HitboxService = require(game.ServerScriptService.Server.Services.HitboxService)

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

	Execute = function(player, _, origin)
		local firstRadius  = 10
		local chainRadius  = 10
		local damage       = 22
		local maxChains    = 5
		local stunDuration = 0.5
		local maxTargets   = 30

		local enemies = HitboxService:Chain(origin, firstRadius, chainRadius, maxChains, maxTargets)
		for _, enemy in ipairs(enemies) do
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
