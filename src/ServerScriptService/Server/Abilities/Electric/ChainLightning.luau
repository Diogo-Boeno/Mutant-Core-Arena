local CombatService = require(game.ServerScriptService.Server.Services.CombatService)
local HitboxService = require(game.ServerScriptService.Server.Services.HitboxService)

return {
	Id       = "ChainLightning",
	Core     = "Electric",
	Tier     = "Advanced",
	Cooldown = 11,

	VFX = {
		AbilityId   = "ChainLightning",
		Type        = "ExpandingArea",
		Scale       = 0.8,
		Duration    = 0.6,
		Sound       = "ChainZap",
		CameraShake = 0.35,
	},

	Display = {
		Name        = "Chain Lightning",
		Description = "Raio que salta entre até 5 inimigos.",
	},

	Execute = function(player, state, origin)
		local firstRadius  = 10
		local chainRadius  = 10 + (state.Modifiers.ChainLightningJump or 0)
		local damage       = 22 * (1 + (state.Modifiers.ChainLightningDmg or 0))
		local maxChains    = 5  + (state.Modifiers.ChainLightningChains or 0)
		local stunDur      = 0.5 + (state.Modifiers.ChainLightningStunDur or 0)
		local maxTargets   = 30

		local function doChain(chainOrigin)
			local enemies = HitboxService:Chain(chainOrigin, firstRadius, chainRadius, maxChains, maxTargets)
			for jumpIndex, enemy in ipairs(enemies) do
				local jumpDmg = damage
				-- Amplify: each jump does 15% more
				if state.Effects.ChainLightningAmplify then
					jumpDmg = jumpDmg * (1 + (jumpIndex - 1) * 0.15)
				end
				-- Overload: last target takes 3x
				if state.Effects.ChainLightningOverload and jumpIndex == #enemies then
					jumpDmg = jumpDmg * 3
				end

				CombatService:ApplyDamage(player, enemy, jumpDmg, "Electric")

				local humanoid = enemy:FindFirstChildOfClass("Humanoid")
				if humanoid then
					humanoid.PlatformStand = true
					task.delay(stunDur, function()
						if humanoid and humanoid.Parent then
							humanoid.PlatformStand = false
						end
					end)
				end

				-- Shock DoT per hit
				if state.Effects.ChainLightningShock then
					task.spawn(function()
						for _ = 1, 3 do
							local h = enemy:FindFirstChildOfClass("Humanoid")
							if not h or h.Health <= 0 then break end
							CombatService:ApplyDamage(player, enemy, 5, "Electric")
							task.wait(1)
						end
					end)
				end
			end

			-- Return: bounce back through all targets again
			if state.Effects.ChainLightningReturn then
				task.delay(0.4, function()
					for i = #enemies, 1, -1 do
						local enemy = enemies[i]
						local h = enemy:FindFirstChildOfClass("Humanoid")
						if h and h.Health > 0 then
							CombatService:ApplyDamage(player, enemy, damage * 0.5, "Electric")
						end
					end
				end)
			end
		end

		doChain(origin)

		if state.Effects.ChainLightningDouble then
			task.delay(0.3, function()
				doChain(origin)
			end)
		end
	end,
}
