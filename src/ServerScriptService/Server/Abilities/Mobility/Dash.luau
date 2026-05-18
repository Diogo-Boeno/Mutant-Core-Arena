local CombatService = require(game.ServerScriptService.Server.Services.CombatService)
local HitboxService = require(game.ServerScriptService.Server.Services.HitboxService)

return {
	Id       = "Dash",
	Core     = "Mobility",
	Tier     = "Base",
	Cooldown = 4,

	VFX = {
		AbilityId   = "Dash",
		Type        = "SelfBuff",
		Duration    = 0.3,
		Sound       = "Whoosh",
		CameraShake = 0.20,
	},

	Display = {
		Name        = "Dash",
		Description = "Avança rapidamente na direção que está olhando.",
	},

	Execute = function(player, state, _)
		local speed        = 80 * (1 + (state.Modifiers.DashDistance or 0))
		local invDur       = 0.3 + (state.Modifiers.DashInvDur or 0)

		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if not root then return end

		local function doDash()
			local direction = root.CFrame.LookVector
			root.AssemblyLinearVelocity = direction * speed

			-- Damage enemies passed through
			if state.Effects.DashDamage then
				local nearby = HitboxService:Sphere(root.Position + direction * 4, 4, 6)
				for _, enemy in ipairs(nearby) do
					CombatService:ApplyDamage(player, enemy, 20, "Mobility")
				end
			end

			-- Chain: auto-leap to nearest enemy at destination
			if state.Effects.DashChain then
				task.delay(0.15, function()
					if not root.Parent then return end
					local targets = HitboxService:Sphere(root.Position, 10, 3)
					if targets[1] then
						CombatService:ApplyDamage(player, targets[1], 25, "Mobility")
					end
				end)
			end

			-- Afterimage: exploding clone at start position
			if state.Effects.DashAfterimage then
				local startPos = root.Position
				task.delay(0.5, function()
					local nearby = HitboxService:Sphere(startPos, 6, 8)
					for _, enemy in ipairs(nearby) do
						CombatService:ApplyDamage(player, enemy, 20, "Mobility")
					end
				end)
			end

			-- Strike: heavy hit on nearest enemy at destination
			if state.Effects.DashStrike then
				task.delay(0.2, function()
					if not root.Parent then return end
					local targets = HitboxService:Sphere(root.Position, 8, 3)
					if targets[1] then
						CombatService:ApplyDamage(player, targets[1], 35, "Mobility")
					end
				end)
			end
		end

		state.IsInvincible = true

		doDash()

		-- Double dash: second dash after short delay
		if state.Effects.DashDouble then
			task.delay(0.35, function()
				if root.Parent then
					doDash()
				end
			end)
		end

		task.delay(invDur, function()
			state.IsInvincible = false

			-- Speed boost after dash
			if state.Effects.DashSpeedBoost then
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					local orig = humanoid.WalkSpeed
					humanoid.WalkSpeed = orig * 1.4
					task.delay(2, function()
						if humanoid and humanoid.Parent then
							humanoid.WalkSpeed = orig
						end
					end)
				end
			end
		end)
	end,
}
