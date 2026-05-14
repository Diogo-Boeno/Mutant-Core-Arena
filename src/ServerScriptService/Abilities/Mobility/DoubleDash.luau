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

	Execute = function(player, state, origin)
		local dashes           = 2
		local invincibleFrames = 0.4

		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if not root then return end

		state.IsInvincible = true

		for i = 1, dashes do
			task.spawn(function()
				task.wait((i - 1) * 0.2)
				if not root or not root.Parent then return end
				local direction = root.CFrame.LookVector
				root.AssemblyLinearVelocity = direction * 80
			end)
		end

		task.delay(invincibleFrames, function()
			state.IsInvincible = false
		end)
	end,
}
