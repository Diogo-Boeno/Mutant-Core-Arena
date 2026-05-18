local CombatService = require(game.ServerScriptService.Server.Services.CombatService)
local HitboxService = require(game.ServerScriptService.Server.Services.HitboxService)

return {
	Id       = "GravityPulse",
	Core     = "Gravity",
	Tier     = "Base",
	Cooldown = 1,

	VFX = {
		AbilityId   = "GravityPulse",
		Type        = "ExpandingArea",
		Scale       = 1,
		Duration    = 0.4,
		Sound       = "GravityPulseBoom",
		CameraShake = 0.35,
	},

	Display = {
		Name        = "Gravity Pulse",
		Description = "Emite uma onda de gravidade que empurra inimigos próximos.",
	},

	Execute = function(player, state, origin)
		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		local groundOrigin = root and (root.Position - Vector3.new(0, root.Size.Y / 2 + 2.5, 0)) or origin

		local radius     = 12 * (1 + (state.Modifiers.AreaRadius or 0))
		local damage     = 20 * (1 + (state.Modifiers.GravityPulseDmg or 0))
		local maxTargets = 15 + (state.Modifiers.GravityPulseTargets or 0)
		local stunDur    = state.Modifiers.GravityPulseStun or 0
		local pullMode   = state.Effects.GravityPulsePull  -- pull instead of push
		local doLaunch   = state.Effects.GravityPulseLaunch
		local doSlow     = state.Effects.GravityPulseSlow

		local enemies = HitboxService:Sphere(groundOrigin, radius, maxTargets)
		for _, enemy in ipairs(enemies) do
			CombatService:ApplyDamage(player, enemy, damage, "Gravity")

			if pullMode then
				CombatService:ApplyPull(enemy, origin, 80)
			else
				CombatService:ApplyPull(enemy, origin, 0)
			end

			local root2 = enemy:FindFirstChild("HumanoidRootPart")
			if root2 and doLaunch then
				root2.AssemblyLinearVelocity = Vector3.new(0, 60, 0)
			end

			if stunDur > 0 then
				local humanoid = enemy:FindFirstChildOfClass("Humanoid")
				if humanoid then
					humanoid.PlatformStand = true
					task.delay(stunDur, function()
						if humanoid and humanoid.Parent then
							humanoid.PlatformStand = false
						end
					end)
				end
			end

			if doSlow then
				local humanoid = enemy:FindFirstChildOfClass("Humanoid")
				if humanoid then
					local orig = humanoid.WalkSpeed
					humanoid.WalkSpeed = orig * 0.65
					task.delay(3, function()
						if humanoid and humanoid.Parent then
							humanoid.WalkSpeed = orig
						end
					end)
				end
			end

			-- KillExplosion handled by CombatService death callback (flag checked there)
		end

		-- Double Pulse
		if state.Effects.DoublePulse then
			task.delay(0.45, function()
				local secondEnemies = HitboxService:Sphere(origin, radius * 0.7, maxTargets)
				for _, enemy in ipairs(secondEnemies) do
					CombatService:ApplyDamage(player, enemy, damage * 0.45, "Gravity")
					CombatService:ApplyPull(enemy, origin, pullMode and 80 or 0)
				end
			end)
		end
	end,
}
