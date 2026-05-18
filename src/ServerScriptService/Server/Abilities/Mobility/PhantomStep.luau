local CombatService = require(game.ServerScriptService.Server.Services.CombatService)
local HitboxService = require(game.ServerScriptService.Server.Services.HitboxService)

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

	Execute = function(player, state, _)
		local teleports  = 6  + (state.Modifiers.PhantomStepTeleports or 0)
		local distance   = 28
		local invisDur   = 3  + (state.Modifiers.PhantomStepInvisDur or 0)

		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if not root then return end

		local stackDmgBonus = 0

		-- Teleport sequence
		for i = 1, teleports do
			task.spawn(function()
				task.wait((i - 1) * 0.1)
				if not root or not root.Parent then return end

				local direction = root.CFrame.LookVector
				local startPos  = root.Position
				root.CFrame = root.CFrame + direction * distance

				-- Damage at each teleport position
				if state.Effects.PhantomStepDamage then
					local baseDmg = 12 * (1 + stackDmgBonus)
					local nearby = HitboxService:Sphere(startPos, 5, 8)
					for _, enemy in ipairs(nearby) do
						CombatService:ApplyDamage(player, enemy, baseDmg, "Mobility")
					end
				end

				-- Silence: prevent enemy ability use near each teleport point
				if state.Effects.PhantomStepSilence then
					local nearby = HitboxService:Sphere(startPos, 6, 8)
					for _, enemy in ipairs(nearby) do
						local h = enemy:FindFirstChildOfClass("Humanoid")
						if h then
							h.PlatformStand = true
							task.delay(1, function()
								if h and h.Parent then
									h.PlatformStand = false
								end
							end)
						end
					end
				end

				-- Stack: each teleport increases next damage by 20%
				if state.Effects.PhantomStepStack then
					stackDmgBonus += 0.20
				end
			end)
		end

		-- Speed boost while invisible
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if state.Effects.PhantomStepSpeed and humanoid then
			humanoid.WalkSpeed = humanoid.WalkSpeed * 1.6
		end

		-- Strike: first attack after invisible does 2x (flag for CombatService)
		if state.Effects.PhantomStepStrike then
			state.PhantomStrikeReady = true
		end

		-- Clones: place 2 decoy parts that distract/confuse
		if state.Effects.PhantomStepClone and root then
			for _ = 1, 2 do
				task.spawn(function()
					local clone = Instance.new("Part")
					clone.Name      = "PhantomClone"
					clone.Shape     = Enum.PartType.Ball
					clone.Size      = Vector3.new(3, 3, 3)
					clone.Color     = Color3.fromRGB(100, 100, 200)
					clone.Material  = Enum.Material.Neon
					clone.Anchored  = true
					clone.CanCollide = false
					clone.CFrame    = CFrame.new(root.Position + Vector3.new(math.random(-6, 6), 0, math.random(-6, 6)))
					clone.Parent    = workspace
					game:GetService("Debris"):AddItem(clone, invisDur)
				end)
			end
		end

		-- Invisibility
		task.spawn(function()
			for _, part in ipairs(character:GetDescendants()) do
				if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
					part.Transparency = 1
				end
			end

			task.wait(invisDur)

			for _, part in ipairs(character:GetDescendants()) do
				if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
					part.Transparency = 0
				end
			end

			if state.Effects.PhantomStepSpeed and humanoid and humanoid.Parent then
				humanoid.WalkSpeed = humanoid.WalkSpeed / 1.6
			end

			state.PhantomStrikeReady = false
		end)
	end,
}
