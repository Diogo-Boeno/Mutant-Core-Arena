local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local AISystem = {}

local UPDATE_INTERVAL = 0.35
local lastAttackByEnemy = {}
local aiLoopRunning = false

function AISystem:Init()
	print("[AISystem] Init")
end

function AISystem:Start()
	print("[AISystem] Start")

	if aiLoopRunning then
		return
	end

	aiLoopRunning = true

	task.spawn(function()
		while true do
			self:UpdateEnemies()
			task.wait(UPDATE_INTERVAL)
		end
	end)
end

function AISystem:UpdateEnemies()
	local enemiesFolder = Workspace:FindFirstChild("Enemies")
	if not enemiesFolder then
		return
	end

	for _, enemy in ipairs(enemiesFolder:GetChildren()) do
		self:UpdateEnemy(enemy)
	end
end

function AISystem:UpdateEnemy(enemy)
	local humanoid = enemy:FindFirstChildOfClass("Humanoid")
	local root = enemy:FindFirstChild("HumanoidRootPart")

	if not humanoid or not root then
		return
	end

	if humanoid.Health <= 0 then
		task.delay(2, function()
			if enemy and enemy.Parent then
				enemy:Destroy()
			end
		end)

		return
	end

	local targetPlayer, targetRoot = self:GetNearestPlayer(root.Position)

	if not targetPlayer or not targetRoot then
		return
	end

	local distance = (targetRoot.Position - root.Position).Magnitude
	local attackRange = enemy:GetAttribute("AttackRange") or 4

	if distance <= attackRange then
		self:Attack(enemy, targetPlayer)
	else
		humanoid:MoveTo(targetRoot.Position)
	end
end

function AISystem:GetNearestPlayer(position)
	local nearestPlayer = nil
	local nearestRoot = nil
	local nearestDistance = math.huge

	for _, player in ipairs(Players:GetPlayers()) do
		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		if root and humanoid and humanoid.Health > 0 then
			local distance = (root.Position - position).Magnitude

			if distance < nearestDistance then
				nearestDistance = distance
				nearestPlayer = player
				nearestRoot = root
			end
		end
	end

	return nearestPlayer, nearestRoot
end

function AISystem:Attack(enemy, player)
	local now = os.clock()
	local cooldown = enemy:GetAttribute("AttackCooldown") or 1.2

	if lastAttackByEnemy[enemy] and now - lastAttackByEnemy[enemy] < cooldown then
		return
	end

	lastAttackByEnemy[enemy] = now

	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")

	if not humanoid or humanoid.Health <= 0 then
		return
	end

	local damage = enemy:GetAttribute("Damage") or 8
	humanoid:TakeDamage(damage)
end

return AISystem