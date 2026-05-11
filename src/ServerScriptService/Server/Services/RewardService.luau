local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EconomyConfig = require(ReplicatedStorage.Shared.Config.EconomyConfig)
local Net = require(ReplicatedStorage.Shared.Net.Net)

local RewardService = {}

function RewardService:Init()
	print("[RewardService] Init")
end

function RewardService:Start()
	print("[RewardService] Start")
end

function RewardService:GrantMatchReward(player, matchState)
	local PlayerDataService = require(script.Parent.PlayerDataService)

	local reward = EconomyConfig.MatchRewards.BaseCompletion
	reward += matchState.Kills * EconomyConfig.MatchRewards.PerKill

	if matchState.IsAlive then
		reward += EconomyConfig.MatchRewards.VictoryBonus
	end

	reward += matchState.CellsEarned

	local totalCells = PlayerDataService:AddCells(player, reward)
	PlayerDataService:AddMatchPlayed(player)

	Net:FireClient(player, "HUDUpdate", {
		MatchReward = reward,
		TotalCells = totalCells,
		Kills = matchState.Kills,
		DamageDealt = math.floor(matchState.DamageDealt),
	})
end

return RewardService