local CombatService = require(game.ServerScriptService.Server.Services.CombatService)
local HitboxService = require(game.ServerScriptService.Server.Services.HitboxService)

return {
	Id       = "FireNova",
	Core     = "Fire",
	Tier     = "Advanced",
	Cooldown = 12,

	VFX = {
		AbilityId   = "FireNova",
		Type        = "ExpandingArea",
		Scale       = 1,
		Duration    = 5.0,
		Sound       = "FireExplosion",
		CameraShake = 0.40,
	},

	Display = {
		Name        = "Fire Nova",
		Description = "Explosão de fogo em área ampla com queimadura.",
	},

	Execute = function(player, state, origin)
		local radius    = 24 * (1 + (state.Modifiers.FireNovaRadius or 0))
		local damage    = 30 * (1 + (state.Modifiers.FireNovaDmg or 0))
		local burnDmg   = 8  * (1 + (state.Modifiers.FireNovaBurnDmg or 0))
		local burnDur   = 4  + (state.Modifiers.FireNovaBurnDur or 0)
		local maxTargets = 20

		local function applyNova(waveOrigin)
			local enemies = HitboxService:Sphere(waveOrigin, radius, maxTargets)
			for _, enemy in ipairs(enemies) do
				CombatService:ApplyDamage(player, enemy, damage, "Fire")

				-- Knockback
				if state.Effects.FireNovaKnockback then
					local eRoot = enemy:FindFirstChild("HumanoidRootPart")
					if eRoot then
						local dir = (eRoot.Position - waveOrigin).Unit
						eRoot.AssemblyLinearVelocity = dir * 55
					end
				end

				-- Stagger: stun 0.5s
				if state.Effects.FireNovaStagger then
					local humanoid = enemy:FindFirstChildOfClass("Humanoid")
					if humanoid then
						humanoid.PlatformStand = true
						task.delay(0.5, function()
							if humanoid and humanoid.Parent then
								humanoid.PlatformStand = false
							end
						end)
					end
				end

				task.spawn(function()
					local elapsed = 0
					while elapsed < burnDur do
						local humanoid = enemy:FindFirstChildOfClass("Humanoid")
						if not humanoid or humanoid.Health <= 0 then break end

						CombatService:ApplyDamage(player, enemy, burnDmg, "Fire")

						-- Slow burning enemies
						if state.Effects.FireNovaSlow then
							humanoid.WalkSpeed = math.max(4, humanoid.WalkSpeed * 0.85)
						end

						task.wait(1)
						elapsed += 1
					end
				end)
			end

			-- Lingering fire patch: SphereTick on the ground for 3s
			if state.Effects.FireNovaLingering then
				HitboxService:SphereTick(waveOrigin, radius * 0.6, 3, 0.5, maxTargets, function(lingering)
					for _, enemy in ipairs(lingering) do
						CombatService:ApplyDamage(player, enemy, burnDmg, "Fire")
					end
				end)
			end
		end

		applyNova(origin)

		if state.Effects.FireNovaSecondWave then
			task.delay(1, function()
				applyNova(origin)
			end)
		end
	end,
}
