local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = require(ReplicatedStorage.Shared.Net.Net)

local MatchController = {}

function MatchController:Init()
	print("[MatchController] Init")
end

function MatchController:Start()
	print("[MatchController] Start")

	Net:OnClientEvent("MatchStateUpdate", function(payload)
		print("[Client] MatchStateUpdate:", payload.State)
	end)

	Net:OnClientEvent("HUDUpdate", function(payload)
		if payload.TimeRemaining then
			print("[Client] Time remaining:", math.ceil(payload.TimeRemaining))
		end

		if payload.MatchReward then
			print("[Client] Reward:", payload.MatchReward, "Total:", payload.TotalCells)
			print("[Client] Kills:", payload.Kills, "Damage:", payload.DamageDealt)
		end
	end)
end

return MatchController