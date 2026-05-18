local CombatService = require(game.ServerScriptService.Server.Services.CombatService)
local HitboxService = require(game.ServerScriptService.Server.Services.HitboxService)

return {
	Id       = "IceShard",
	Core     = "Ice",
	Tier     = "Base",
	Cooldown = 6,

	VFX = {
		AbilityId   = "IceShard",
		Type        = "ExpandingArea",
		Scale       = 0.6,
		Duration    = 0.5,
		Sound       = "IceCrack",
		CameraShake = 0.20,
	},

	Display = {
		Name        = "Ice Shard",
		Description = "Fragmentos de gelo que ferem e reduzem a velocidade dos inimigos.",
	},

	Execute = function(player, state, origin)
		local radius     = 7  * (1 + (state.Modifiers.IceShardRadius or 0))
		local damage     = 18 * (1 + (state.Modifiers.IceShardDmg or 0))
		local slowAmt    = 0.3 + (state.Modifiers.IceShardSlowAmt or 0)
		local slowDur    = 2  + (state.Modifiers.IceShardSlowDur or 0)
		local maxTargets = 12 + (state.Modifiers.IceShardTargets or 0)

		local function applyWave(waveOrigin)
			local enemies = HitboxService:Sphere(waveOrigin, radius, maxTargets)
			for _, enemy in ipairs(enemies) do
				local humanoid = enemy:FindFirstChildOfClass("Humanoid")

				-- Shatter: frozen enemies take bonus damage
				local actualDmg = damage
				if state.Effects.IceShardShatter then
					local root = enemy:FindFirstChild("HumanoidRootPart")
					if root and root.Anchored then
						actualDmg = actualDmg * 1.5
					end
				end

				CombatService:ApplyDamage(player, enemy, actualDmg, "Ice")

				-- Freeze chance (30%)
				if state.Effects.IceShardFreeze and math.random() < 0.30 then
					local root = enemy:FindFirstChild("HumanoidRootPart")
					if root then
						root.Anchored = true
						task.delay(1, function()
							if root and root.Parent then
								root.Anchored = false
							end
						end)
					end
				else
					-- Normal slow
					if humanoid then
						local orig = humanoid.WalkSpeed
						humanoid.WalkSpeed = orig * (1 - math.min(slowAmt, 0.9))
						task.delay(slowDur, function()
							if humanoid and humanoid.Parent then
								humanoid.WalkSpeed = orig
							end
						end)
					end
				end

				-- Splinter: each hit spawns 2 mini spheres
				if state.Effects.IceShardSplinter then
					local eRoot = enemy:FindFirstChild("HumanoidRootPart")
					if eRoot then
						for _ = 1, 2 do
							local shard = HitboxService:Sphere(eRoot.Position, radius * 0.4, 3)
							for _, se in ipairs(shard) do
								if se ~= enemy then
									CombatService:ApplyDamage(player, se, actualDmg * 0.3, "Ice")
								end
							end
						end
					end
				end
			end
		end

		applyWave(origin)

		-- Triple: 3 waves with short delays
		if state.Effects.IceShardTriple then
			task.delay(0.2, function() applyWave(origin) end)
			task.delay(0.4, function() applyWave(origin) end)
		end
	end,
}
