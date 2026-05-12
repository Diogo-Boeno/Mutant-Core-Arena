local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MatchConfig = require(ReplicatedStorage.Shared.Config.MatchConfig)
local EnemyConfig = require(ReplicatedStorage.Shared.Config.EnemyConfig)

local EnemyService = {}

local enemiesFolder
local spawnLoopRunning = false

function EnemyService:Init()
	print("[EnemyService] Init")

	enemiesFolder = Workspace:FindFirstChild("Enemies")

	if not enemiesFolder then
		enemiesFolder = Instance.new("Folder")
		enemiesFolder.Name = "Enemies"
		enemiesFolder.Parent = Workspace
	end
end

function EnemyService:Start()
	print("[EnemyService] Start")

	if spawnLoopRunning then
		return
	end

	spawnLoopRunning = true

	task.spawn(function()
		while true do
			self:SpawnLoop()
			task.wait(MatchConfig.EnemySpawnInterval or 3)
		end
	end)
end

function EnemyService:SpawnLoop()
	local MatchService = require(script.Parent.MatchService)

	if not MatchService:IsMatchRunning() then
		return
	end

	local aliveCount = self:GetAliveEnemyCount()

	local MaxEnemies = MatchConfig.MaxEnemiesAlive()

	if aliveCount >= MaxEnemies then
		return
	end

	local amountToSpawn = math.clamp(
		MaxEnemies - aliveCount,
		1,
		3
	)
	print(MaxEnemies)
	
	for _ = 1, amountToSpawn do
		self:SpawnEnemy("BasicMutant")
	end
end

function EnemyService:GetAliveEnemyCount()
	if not enemiesFolder then
		return 0
	end

	local count = 0

	for _, enemy in ipairs(enemiesFolder:GetChildren()) do
		local humanoid = enemy:FindFirstChildOfClass("Humanoid")

		if humanoid and humanoid.Health > 0 then
			count += 1
		end
	end

	return count
end

function EnemyService:GetSpawnPoints()
	local arenas = Workspace:FindFirstChild("Arenas")
	if not arenas then
		warn("[EnemyService] Missing Workspace.Arenas")
		return {}
	end

	local arena = arenas:FindFirstChild("MVP_Arena")
	if not arena then
		warn("[EnemyService] Missing Workspace.Arenas.MVP_Arena")
		return {}
	end

	local folder = arena:FindFirstChild("EnemySpawnPoints")
	if not folder then
		warn("[EnemyService] Missing EnemySpawnPoints")
		return {}
	end

	return folder:GetChildren()
end

function EnemyService:SpawnEnemy(enemyId)
	local templateFolder = ServerStorage:FindFirstChild("EnemyTemplates")
	if not templateFolder then
		warn("[EnemyService] Missing ServerStorage.EnemyTemplates")
		return
	end

	local template = templateFolder:FindFirstChild(enemyId)
	if not template then
		warn("[EnemyService] Missing enemy template:", enemyId)
		return
	end

	local spawnPoints = self:GetSpawnPoints()
	if #spawnPoints == 0 then
		warn("[EnemyService] No spawn points found")
		return
	end

	local config = EnemyConfig[enemyId]
	if not config then
		warn("[EnemyService] Missing EnemyConfig for", enemyId)
		return
	end

	local spawnPoint = spawnPoints[math.random(1, #spawnPoints)]
	local enemy = template:Clone()

	enemy.Name = enemyId

	local humanoid = enemy:FindFirstChildOfClass("Humanoid")
	local root = enemy:FindFirstChild("HumanoidRootPart")

	if not humanoid or not root then
		warn("[EnemyService] Enemy missing Humanoid or HumanoidRootPart:", enemyId)
		enemy:Destroy()
		return
	end

	humanoid.MaxHealth = config.MaxHealth
	humanoid.Health = config.MaxHealth
	humanoid.WalkSpeed = config.MoveSpeed

	enemy:SetAttribute("EnemyId", enemyId)
	enemy:SetAttribute("Damage", config.Damage)
	enemy:SetAttribute("AttackRange", config.AttackRange)
	enemy:SetAttribute("AttackCooldown", config.AttackCooldown)
	enemy:SetAttribute("CellsReward", config.CellsReward)

	enemy:PivotTo(spawnPoint.CFrame + Vector3.new(0, 3, 0))
	enemy.Parent = enemiesFolder
end

function EnemyService:ClearEnemies()
	if not enemiesFolder then
		return
	end

	for _, enemy in ipairs(enemiesFolder:GetChildren()) do
		enemy:Destroy()
	end
end

return EnemyService