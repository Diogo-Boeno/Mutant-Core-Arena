local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = require(ReplicatedStorage.Shared.Net.Net)

local BuildService = {}

local VALID_CORES = {
	Gravity = true,
	Fire = true,
	Electric = true,
	Ice = true,
	Defense = true,
	Mobility = true,
}

local DEFAULT_CORE = "Gravity"
local playerCores = {}

function BuildService:Init()
	print("[BuildService] Init")
end

function BuildService:Start()
	print("[BuildService] Start")

	Players.PlayerRemoving:Connect(function(player)
		playerCores[player] = nil
	end)

	Net:OnServerEvent("CoreSelect", function(player, core)
		self:SetCore(player, core)
	end)
end

function BuildService:SetCore(player, core)
	if not VALID_CORES[core] then
		warn("[BuildService] Core inválido recebido de", player.Name, "→", tostring(core))
		return
	end
	playerCores[player] = core
	print("[BuildService]", player.Name, "→ Core selecionado:", core)
end

function BuildService:GetCore(player)
	return playerCores[player] or DEFAULT_CORE
end

return BuildService
