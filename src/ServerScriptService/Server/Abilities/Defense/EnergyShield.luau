local CombatService = require(game.ServerScriptService.Server.Services.CombatService)
local HitboxService = require(game.ServerScriptService.Server.Services.HitboxService)

return {
	Id       = "EnergyShield",
	Core     = "Defense",
	Tier     = "Advanced",
	Cooldown = 28,

	VFX = {
		AbilityId   = "EnergyShield",
		Type        = "SelfBuff",
		Duration    = 8.0,
		Sound       = "ShieldUp",
		CameraShake = 0.10,
	},

	Display = {
		Name        = "Energy Shield",
		Description = "Cria um escudo que absorve 180 de dano por 8 segundos.",
	},

	Execute = function(player, state, _)
		local charges    = 1 + (state.Modifiers.EnergyShieldCharges or 0)
		local shieldHP   = (180 + (state.Modifiers.EnergyShieldAmount or 0)) * charges
		local duration   = 8 + (state.Modifiers.EnergyShieldDuration or 0)

		local character = player.Character
		local humanoid  = character and character:FindFirstChildOfClass("Humanoid")
		local root      = character and character:FindFirstChild("HumanoidRootPart")

		state.ShieldHP = (state.ShieldHP or 0) + shieldHP

		-- Speed boost while shielded
		if state.Effects.EnergyShieldSpeed and humanoid then
			humanoid.WalkSpeed = humanoid.WalkSpeed * 1.25
		end

		-- Regeneration: restore 15 HP/s while shield active
		local regenConn
		if state.Effects.EnergyShieldRegen then
			regenConn = task.spawn(function()
				local t = 0
				while t < duration and (state.ShieldHP or 0) > 0 do
					task.wait(1)
					t += 1
					if state.ShieldHP and state.ShieldHP > 0 then
						state.ShieldHP = state.ShieldHP + 15
					end
				end
			end)
		end

		-- Aura: 5 dmg/s to nearby enemies
		local auraRunning = true
		if state.Effects.EnergyShieldAura and root then
			task.spawn(function()
				while auraRunning do
					task.wait(1)
					if not root.Parent then break end
					local nearby = HitboxService:Sphere(root.Position, 12, 10)
					for _, enemy in ipairs(nearby) do
						CombatService:ApplyDamage(player, enemy, 5, "Defense")
					end
				end
			end)
		end

		task.delay(duration, function()
			auraRunning = false
			if regenConn then task.cancel(regenConn) end

			-- Speed reset
			if state.Effects.EnergyShieldSpeed and humanoid and humanoid.Parent then
				humanoid.WalkSpeed = humanoid.WalkSpeed / 1.25
			end

			local remaining = state.ShieldHP or 0
			state.ShieldHP = math.max(0, remaining - shieldHP)

			-- Explosion when shield is depleted
			if state.Effects.EnergyShieldExplosion and remaining <= 0 and root and root.Parent then
				local nearby = HitboxService:Sphere(root.Position, 14, 20)
				for _, enemy in ipairs(nearby) do
					CombatService:ApplyDamage(player, enemy, shieldHP * 0.3, "Defense")
				end
			end
		end)
	end,
}
