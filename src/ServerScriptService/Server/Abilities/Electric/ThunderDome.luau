local CombatService = require(game.ServerScriptService.Server.Services.CombatService)
local HitboxService = require(game.ServerScriptService.Server.Services.HitboxService)

return {
	Id       = "ThunderDome",
	Core     = "Electric",
	Tier     = "Ultimate",
	Cooldown = 65,

	VFX = {
		AbilityId   = "ThunderDome",
		Type        = "ExpandingArea",
		Scale       = 1.2,
		Duration    = 6.0,
		Sound       = "ThunderRoar",
		CameraShake = 0.90,
	},

	Display = {
		Name        = "Thunder Dome",
		Description = "Cria uma cúpula elétrica que fulmina inimigos por 6 segundos.",
	},

	Execute = function(player, _, origin)
		local radius       = 22
		local damage       = 55
		local stunDuration = 1.5
		local duration     = 6
		local interval     = 0.5
		local maxTargets   = 45

		HitboxService:SphereTick(origin, radius, duration, interval, maxTargets, function(enemies)
			for _, enemy in ipairs(enemies) do
				CombatService:ApplyDamage(player, enemy, damage * interval, "Electric")

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
		end)
	end,
}
