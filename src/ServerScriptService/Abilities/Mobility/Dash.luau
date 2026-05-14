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

	Execute = function(player, state, origin)
		local distance          = 22
		local invincibleFrames  = 0.3

		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if not root then return end

		local direction = root.CFrame.LookVector
		root.AssemblyLinearVelocity = direction * 80

		state.IsInvincible = true
		task.delay(invincibleFrames, function()
			state.IsInvincible = false
		end)
	end,
}
