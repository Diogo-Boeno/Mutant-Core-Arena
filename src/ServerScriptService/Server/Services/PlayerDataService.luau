local Players = game:GetService("Players")

local PlayerDataService = {}

local profiles = {}

local DEFAULT_PROFILE = {
	Cells = 0,
	Level = 1,
	XP = 0,
	MatchesPlayed = 0,
}

function PlayerDataService:Init()
	print("[PlayerDataService] Init")
end

function PlayerDataService:Start()
	print("[PlayerDataService] Start")

	Players.PlayerAdded:Connect(function(player)
		self:LoadProfile(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		self:SaveProfile(player)
		profiles[player] = nil
	end)

	for _, player in ipairs(Players:GetPlayers()) do
		self:LoadProfile(player)
	end
end

function PlayerDataService:LoadProfile(player)
	profiles[player] = table.clone(DEFAULT_PROFILE)
	print("[PlayerDataService] Loaded profile for", player.Name)
end

function PlayerDataService:GetProfile(player)
	return profiles[player]
end

function PlayerDataService:AddCells(player, amount)
	local profile = self:GetProfile(player)
	if not profile then
		return 0
	end

	profile.Cells += amount
	return profile.Cells
end

function PlayerDataService:AddMatchPlayed(player)
	local profile = self:GetProfile(player)
	if not profile then
		return
	end

	profile.MatchesPlayed += 1
end

function PlayerDataService:SaveProfile(player)
	-- MVP: sem DataStore ainda.
	print("[PlayerDataService] Saved profile for", player.Name)
end

return PlayerDataService