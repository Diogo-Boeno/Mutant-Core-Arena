local CombatService  = require(game.ServerScriptService.Server.Services.CombatService)
local HitboxService  = require(game.ServerScriptService.Server.Services.HitboxService)

return {
	Id       = "AbsoluteZero",
	Core     = "Ice",
	Tier     = "Ultimate",
	Cooldown = 70,

	VFX = {
		AbilityId   = "AbsoluteZero",
		Type        = "ExpandingArea",
		Scale       = 1.5,
		Duration    = 3.0,
		Sound       = "IceApocalypse",
		CameraShake = 1.0,
	},

	Display = {
		Name        = "Absolute Zero",
		Description = "Congela todos os inimigos próximos e aplica slow extremo.",
	},

	Execute = function(player, _, origin)
		local radius        = 28
		local damage        = 65
		local freezeDuration = 4
		local slowAmount    = 0.8
		local slowDuration  = 6
		local maxTargets    = 50

		local enemies = HitboxService:Sphere(origin, radius, maxTargets)
		for _, enemy in ipairs(enemies) do
			CombatService:ApplyDamage(player, enemy, damage, "Ice")

			local root = enemy:FindFirstChild("HumanoidRootPart")
			if root then
				root.Anchored = true
				task.delay(freezeDuration, function()
					if root and root.Parent then
						root.Anchored = false
					end
				end)
			end

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
