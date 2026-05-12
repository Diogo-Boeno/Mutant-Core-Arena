local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = require(ReplicatedStorage.Shared.Net.Net)

local CombatService = {}

function CombatService:Init()
	print("[CombatService] Init")
end

function CombatService:Start()
	print("[CombatService] Start")
end

function CombatService:GetEnemiesInRadius(origin, radius, maxTargets)
	local enemiesFolder = Workspace:FindFirstChild("Enemies")
	if not enemiesFolder then
		return {}
	end

	local results = {}

	for _, enemy in ipairs(enemiesFolder:GetChildren()) do
		local root = enemy:FindFirstChild("HumanoidRootPart")
		local humanoid = enemy:FindFirstChildOfClass("Humanoid")

		if root and humanoid and humanoid.Health > 0 then
			local distance = (root.Position - origin).Magnitude

			if distance <= radius then
				table.insert(results, enemy)

				if #results >= maxTargets then
					break
				end
			end
		end
	end

	return results
end

-- function CombatService:ExecuteGravityPulse(player, state, origin, stats)
-- 	local enemies = self:GetEnemiesInRadius(origin, stats.Radius, stats.MaxTargets)

-- 	local hitCount = 0

-- 	for _, enemy in ipairs(enemies) do
-- 		local didDamage = self:ApplyDamage(player, enemy, stats.Damage, "Gravity")

-- 		if didDamage then
-- 			hitCount += 1
-- 			self:ApplyPull(enemy, origin, stats.PullForce)
-- 		end
-- 	end

-- 	Net:FireAllClients("ClientVFX", {
-- 		Type = "GravityPulse",
-- 		UserId = player.UserId,
-- 		Origin = origin,
-- 		Radius = stats.Radius,
-- 		HitCount = hitCount,
-- 	})

-- 	if state.Effects.DoublePulse then
-- 		task.delay(0.45, function()
-- 			local secondEnemies = self:GetEnemiesInRadius(origin, stats.Radius * 0.7, stats.MaxTargets)
-- 			local secondHitCount = 0

-- 			for _, enemy in ipairs(secondEnemies) do
-- 				local didDamage = self:ApplyDamage(player, enemy, stats.Damage * 0.45, "Gravity")

-- 				if didDamage then
-- 					secondHitCount += 1
-- 					self:ApplyPull(enemy, origin, stats.PullForce * 0.55)
-- 				end
-- 			end

-- 			Net:FireAllClients("ClientVFX", {
-- 				Type = "GravityPulse",
-- 				UserId = player.UserId,
-- 				Origin = origin,
-- 				Radius = stats.Radius * 0.7,
-- 				HitCount = secondHitCount,
-- 				IsSecondary = true,
-- 			})
-- 		end)
-- 	end
-- end

-- function CombatService:TriggerKillExplosion(player, origin)
-- 	local radius = 10
-- 	local damage = 18
-- 	local enemies = self:GetEnemiesInRadius(origin, radius, 10)

-- 	for _, enemy in ipairs(enemies) do
-- 		self:ApplyDamage(player, enemy, damage, "GravityExplosion")
-- 	end

-- 	Net:FireAllClients("ClientVFX", {
-- 		Type = "KillExplosion",
-- 		Origin = origin,
-- 		Radius = radius,
-- 	})
-- end

function CombatService:HandleEnemyKilled(player, enemy, damageType)
	local MatchService = require(script.Parent.MatchService)

	local cellsReward = enemy:GetAttribute("CellsReward") or 2
	local deathPosition = self:GetEnemyPosition(enemy)
	local state = MatchService:GetPlayerState(player)

	MatchService:AddKill(player)
	MatchService:AddCellsEarned(player, cellsReward)

	if state and state.Effects.KillExplosion then
		self:TriggerKillExplosion(player, deathPosition)
	end

	Net:FireAllClients("ClientVFX", {
		Type = "EnemyKilled",
		Origin = deathPosition,
		DamageType = damageType,
		CellsReward = cellsReward,
	})

	task.delay(0.1, function()
		if enemy and enemy.Parent then
			enemy:Destroy()
		end
	end)
end

function CombatService:ApplyDamage(player, enemy, damage, damageType)
	local humanoid = enemy:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return
	end

	local oldHealth = humanoid.Health
	local finalDamage = math.floor(damage)

	humanoid:TakeDamage(finalDamage)

	local MatchService = require(script.Parent.MatchService)
	MatchService:AddDamage(player, finalDamage)

	if oldHealth > 0 and humanoid.Health <= 0 then
		MatchService:AddKill(player)

		local reward = enemy:GetAttribute("CellsReward") or 2
		MatchService:AddCellsEarned(player, reward)
	end
end

function CombatService:ApplyPull(enemy, origin, pullForce)
	local root = enemy:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end

	local offset = origin - root.Position

	if offset.Magnitude <= 1 then
		return
	end

	local direction = offset.Unit
	local force = math.clamp(pullForce, 0, 100)

	root.AssemblyLinearVelocity = root.AssemblyLinearVelocity + direction * force
end

return CombatService