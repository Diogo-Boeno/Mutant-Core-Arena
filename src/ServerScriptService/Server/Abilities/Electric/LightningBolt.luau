local CombatService = require(game.ServerScriptService.Server.Services.CombatService)
local HitboxService = require(game.ServerScriptService.Server.Services.HitboxService)

return {
	Id       = "LightningBolt",
	Core     = "Electric",
	Tier     = "Base",
	Cooldown = 5,

	VFX = {
		AbilityId   = "LightningBolt",
		Type        = "ExpandingArea",
		Scale       = 0.6,
		Duration    = 0.4,
		Sound       = "LightningStrike",
		CameraShake = 0.25,
	},

	Display = {
		Name        = "Lightning Bolt",
		Description = "Raio que atinge inimigos próximos e aplica stun.",
	},

	Execute = function(player, state, origin)
		local radius     = 6  * (1 + (state.Modifiers.LightningBoltRadius or 0))
		local damage     = 25 * (1 + (state.Modifiers.LightningBoltDmg or 0))
		local stunDur    = 0.8 + (state.Modifiers.LightningBoltStunDur or 0)
		local maxTargets = 8  + (state.Modifiers.LightningBoltTargets or 0)

		local function applyBolt(boltOrigin)
			local enemies = HitboxService:Sphere(boltOrigin, radius, maxTargets)
			for _, enemy in ipairs(enemies) do
				CombatService:ApplyDamage(player, enemy, damage, "Electric")

				local humanoid = enemy:FindFirstChildOfClass("Humanoid")
				if humanoid then
					humanoid.PlatformStand = true
					task.delay(stunDur, function()
						if humanoid and humanoid.Parent then
							humanoid.PlatformStand = false

							-- Overload: explosion at stun end
							if state.Effects.LightningBoltOverload then
								local nearby = HitboxService:Sphere(
									enemy:FindFirstChild("HumanoidRootPart") and enemy.HumanoidRootPart.Position or boltOrigin,
									6, 8)
								for _, n in ipairs(nearby) do
									CombatService:ApplyDamage(player, n, damage * 0.6, "Electric")
								end
							end

							-- EMP: slow after stun
							if state.Effects.LightningBoltEMP then
								local orig = humanoid.WalkSpeed
								humanoid.WalkSpeed = orig * 0.6
								task.delay(2, function()
									if humanoid and humanoid.Parent then
										humanoid.WalkSpeed = orig
									end
								end)
							end
						end
					end)
				end

				-- Shock DoT
				if state.Effects.LightningBoltShock then
					task.spawn(function()
						for _ = 1, 3 do
							local h = enemy:FindFirstChildOfClass("Humanoid")
							if not h or h.Health <= 0 then break end
							CombatService:ApplyDamage(player, enemy, 6, "Electric")
							task.wait(1)
						end
					end)
				end

				-- Chain: jump to 2 nearby after main hit
				if state.Effects.LightningBoltChain then
					local eRoot = enemy:FindFirstChild("HumanoidRootPart")
					if eRoot then
						local chained = HitboxService:Chain(eRoot.Position, 10, 10, 2, 10)
						for _, ce in ipairs(chained) do
							if ce ~= enemy then
								CombatService:ApplyDamage(player, ce, damage * 0.5, "Electric")
							end
						end
					end
				end
			end
		end

		applyBolt(origin)

		if state.Effects.LightningBoltDouble then
			task.delay(0.25, function()
				applyBolt(origin)
			end)
		end
	end,
}
