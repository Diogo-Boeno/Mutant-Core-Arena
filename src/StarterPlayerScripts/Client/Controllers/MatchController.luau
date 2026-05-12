local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = require(ReplicatedStorage.Shared.Net.Net)

local MatchController = {}

function MatchController:Init()
	print("[MatchController] Init")

	local Players = game:GetService('Players')
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild('PlayerGui')

	local mainHUD = playerGui:WaitForChild('Timer')

	if mainHUD then mainHUD.Enabled = false end
end

-- Helper
local function formatTime(seconds)
	local minutes = math.floor(seconds / 60)
	local secs = math.floor(seconds % 60)
	return string.format('%02d:%02d', minutes, secs)
end

-- Começa o round
function MatchController:Start()
	local Players = game:GetService('Players')
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild('PlayerGui')

	local mainHUD = playerGui:WaitForChild('Timer')
	local timerLabel = mainHUD:WaitForChild('TimeLabel')

	print("[MatchController] Start")

	Net:OnClientEvent("MatchStateUpdate", function(payload)
		print("[Client] MatchStateUpdate:", payload.State)
	end)

	-- HUD UPDATE SET
	Net:OnClientEvent("HUDUpdate", function(payload)
		if payload.State == 'Ending' then
				mainHUD.Enabled = false
				return
			end

		if payload.TimeRemaining then
			-- print("[Client] Time remaining:", math.ceil(payload.TimeRemaining))
			-- Atualiza o timer
			if not mainHUD.Enabled then
				mainHUD.Enabled = true
			end
			timerLabel.Text = formatTime(payload.TimeRemaining)
		end

		if payload.MatchReward then
			print("[Client] Reward:", payload.MatchReward, "Total:", payload.TotalCells)
			print("[Client] Kills:", payload.Kills, "Damage:", payload.DamageDealt)
		end
	end)
end

return MatchController