return {
	Id       = "PhantomStep",
	Core     = "Mobility",
	Tier     = "Ultimate",
	Cooldown = 35,

	VFX = {
		AbilityId   = "PhantomStep",
		Type        = "SelfBuff",
		Duration    = 3.0,
		Sound       = "TeleportChain",
		CameraShake = 0.50,
	},

	Display = {
		Name        = "Phantom Step",
		Description = "Teleporta 6 vezes e fica invisível por 3 segundos.",
	},

	Execute = function(player, state, origin)
		local teleports    = 6
		local distance     = 28
		local invisibility = 3

		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if not root then return end

		-- Teleportes em sequência
		for i = 1, teleports do
			task.spawn(function()
				task.wait((i - 1) * 0.1)
				if not root or not root.Parent then return end
				local direction = root.CFrame.LookVector
				root.CFrame = root.CFrame + direction * distance
			end)
		end

		-- Invisibilidade (transparência nos parts do character)
		task.spawn(function()
			for _, part in ipairs(character:GetDescendants()) do
				if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
					part.Transparency = 1
				end
			end

			task.wait(invisibility)

			for _, part in ipairs(character:GetDescendants()) do
				if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
					part.Transparency = 0
				end
			end
		end)
	end,
}
