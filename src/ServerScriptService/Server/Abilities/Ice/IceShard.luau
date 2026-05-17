local CombatService  = require(game.ServerScriptService.Server.Services.CombatService)
local HitboxService  = require(game.ServerScriptService.Server.Services.HitboxService)

return {
	Id       = "IceShard",
	Core     = "Ice",
	Tier     = "Base",
	Cooldown = 6,

	VFX = {
		AbilityId   = "IceShard",
		Type        = "ExpandingArea",
		Scale       = 0.6,
		Duration    = 0.5,
		Sound       = "IceCrack",
		CameraShake = 0.20,
	},

	Display = {
		Name        = "Ice Shard",
		Description = "Fragmentos de gelo que ferem e reduzem a velocidade dos inimigos.",
	},

	Execute = function(player, _, origin)
		local radius      = 7
		local damage      = 18
		local slowAmount  = 0.3
		local slowDuration = 2
		local maxTargets  = 12

		local enemies = HitboxService:Sphere(origin, radius, maxTargets)
		for _, enemy in ipairs(enemies) do
			CombatService:ApplyDamage(player, enemy, damage, "Ice")

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
