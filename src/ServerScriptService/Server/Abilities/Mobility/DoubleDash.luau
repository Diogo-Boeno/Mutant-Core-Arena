local CombatService = require(game.ServerScriptService.Server.Services.CombatService)
local HitboxService = require(game.ServerScriptService.Server.Services.HitboxService)

return {
	Id       = "DoubleDash",
	Core     = "Mobility",
	Tier     = "Advanced",
	Cooldown = 8,

	VFX = {
		AbilityId   = "DoubleDash",
		Type        = "SelfBuff",
		Duration    = 0.5,
		Sound       = "DoubleWhoosh",
		CameraShake = 0.30,
	},

	Display = {
		Name        = "Double Dash",
		Description = "Avança duas vezes em sequência.",
	},

	Execute = function(player, state, _)
		local dashes   = state.Effects.DoubleDashTriple and 3 or 2
		local speed    = 80 * (1 + (state.Modifiers.DoubleDashDistance or 0))
		local invDur   = 0.4 + (state.Modifiers.DoubleDashInvDur or 0)

		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if not root then return end

		local hitTargets = {}
		state.IsInvincible = true

		for i = 1, dashes do
			task.spawn(function()
				task.wait((i - 1) * 0.2)
				if not root or not root.Parent then return end

				local direction = root.CFrame.LookVector
				local startPos  = root.Position
				root.AssemblyLinearVelocity = direction * speed

				-- Damage on each dash
				if state.Effects.DoubleDashDamage then
					local nearby = HitboxService:Sphere(startPos + direction * 4, 4, 8)
					for _, enemy in ipairs(nearby) do
						-- Chain bonus: double damage if same target hit before
						local dmg = 15
						if state.Effects.DoubleDashChain and hitTargets[enemy] then
							dmg = dmg * 2
						end
						CombatService:ApplyDamage(player, enemy, dmg, "Mobility")
						hitTargets[enemy] = true
					end
				end

				-- Strike: heavy hit on last dash only
				if i == dashes and state.Effects.DoubleDashStrike then
					task.delay(0.1, function()
						if not root.Parent then return end
						local targets = HitboxService:Sphere(root.Position, 8, 3)
						if targets[1] then
							CombatService:ApplyDamage(player, targets[1], 50, "Mobility")
						end
					end)
				end

				-- Trail: damage zone at each dash start
				if state.Effects.DoubleDashTrail then
					local trailPos = startPos
					task.delay(0.5, function()
						local nearby = HitboxService:Sphere(trailPos, 5, 8)
						for _, enemy in ipairs(nearby) do
							CombatService:ApplyDamage(player, enemy, 10, "Mobility")
						end
					end)
				end
			end)
		end

		task.delay(invDur, function()
			state.IsInvincible = false

			-- Speed boost after all dashes
			if state.Effects.DoubleDashSpeed then
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					local orig = humanoid.WalkSpeed
					humanoid.WalkSpeed = orig * 1.5
					task.delay(2, function()
						if humanoid and humanoid.Parent then
							humanoid.WalkSpeed = orig
						end
					end)
				end
			end

			-- Burst: AoE explosion at final position
			if state.Effects.DoubleDashBurst and root and root.Parent then
				local nearby = HitboxService:Sphere(root.Position, 10, 12)
				for _, enemy in ipairs(nearby) do
					CombatService:ApplyDamage(player, enemy, 30, "Mobility")
				end
			end
		end)
	end,
}
