local CombatService  = require(game.ServerScriptService.Server.Services.CombatService)
local HitboxService  = require(game.ServerScriptService.Server.Services.HitboxService)

return {
	Id       = "LightningBolt",
	Core     = "Electric",
	Tier     = "Base",
	Cooldown = 5,

	VFX = {
		AbilityId   = "LightningBolt",
		Type        = "ExpandingArea",
		Scale       = 0.6,
		Duration    = 0.4,
		Sound       = "LightningStrike",
		CameraShake = 0.25,
	},

	Display = {
		Name        = "Lightning Bolt",
		Description = "Raio que atinge inimigos próximos e aplica stun.",
	},

	Execute = function(player, _, origin)
		local radius      = 6
		local damage      = 25
		local stunDuration = 0.8
		local maxTargets  = 8

		local enemies = HitboxService:Sphere(origin, radius, maxTargets)
		for _, enemy in ipairs(enemies) do
			CombatService:ApplyDamage(player, enemy, damage, "Electric")

			-- Stun
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
