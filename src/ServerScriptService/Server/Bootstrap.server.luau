local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function ensureRemotes()
	local folder = ReplicatedStorage:FindFirstChild("Remotes")

	if not folder then
		folder = Instance.new("Folder")
		folder.Name = "Remotes"
		folder.Parent = ReplicatedStorage
	end

	local remoteNames = {
		"AbilityRequest",
		"MutationChoice",
		"MutationOffer",
		"MatchStateUpdate",
		"ClientVFX",
		"HUDUpdate",
	}

	for _, name in remoteNames do
		if not folder:FindFirstChild(name) then
			local remote = Instance.new("RemoteEvent")
			remote.Name = name
			remote.Parent = folder
		end
	end
end

ensureRemotes()

local Services = script.Parent.Services
local Systems = script.Parent.Systems

local PlayerDataService = require(Services.PlayerDataService)
local MatchService = require(Services.MatchService)
local RewardService = require(Services.RewardService)
local EnemyService = require(Services.EnemyService)
local AbilityService = require(Services.AbilityService)
local CombatService = require(Services.CombatService)
local MutationService = require(Services.MutationService)
local AISystem = require(Systems.AISystem)

PlayerDataService:Init()
RewardService:Init()
CombatService:Init()
MutationService:Init()
AbilityService:Init()
EnemyService:Init()
AISystem:Init()
MatchService:Init()

PlayerDataService:Start()
RewardService:Start()
CombatService:Start()
MutationService:Start()
AbilityService:Start()
EnemyService:Start()
AISystem:Start()
MatchService:Start()