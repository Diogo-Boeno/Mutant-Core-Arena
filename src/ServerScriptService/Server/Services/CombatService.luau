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

function CombatService:ExecuteGravityPulse(player, state, origin, stats)
	local enemies = self:GetEnemiesInRadius(origin, stats.Radius, stats.MaxTargets)

	for _, enemy in ipairs(enemies) do
		self:ApplyDamage(player, enemy, stats.Damage, "Gravity")
		self:ApplyPull(enemy, origin, stats.PullForce)
	end

	Net:FireAllClients("ClientVFX", {
		Type = "GravityPulse",
		UserId = player.UserId,
		Origin = origin,
		Radius = stats.Radius,
		HitCount = #enemies,
	})
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