local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = require(ReplicatedStorage.Shared.Net.Net)

local localPlayer = Players.LocalPlayer

local MutationController = {}

local screenGui
local frame
local titleLabel
local buttons = {}

local rarityColors = {
	Common = Color3.fromRGB(190, 190, 190),
	Rare = Color3.fromRGB(80, 160, 255),
	Epic = Color3.fromRGB(180, 80, 255),
	Legendary = Color3.fromRGB(255, 190, 70),
}

function MutationController:Init()
	print("[MutationController] Init")
end

function MutationController:Start()
	print("[MutationController] Start")

	self:CreateUI()

	Net:OnClientEvent("MutationOffer", function(payload)
		self:ShowChoices(payload.Choices or {})
	end)

	Net:OnClientEvent("HUDUpdate", function(payload)
		if payload.Type == "MutationApplied" then
			self:HideChoices()
			print("[MutationController] Applied:", payload.DisplayName)
		end
	end)
end

function MutationController:CreateUI()
	local playerGui = localPlayer:WaitForChild("PlayerGui")

	screenGui = playerGui:FindFirstChild("MutantCoreMutations")

	if not screenGui then
		screenGui = Instance.new("ScreenGui")
		screenGui.Name = "MutantCoreMutations"
		screenGui.ResetOnSpawn = false
		screenGui.Parent = playerGui
	end

	frame = Instance.new("Frame")
	frame.Name = "MutationFrame"
	frame.Size = UDim2.fromScale(0.72, 0.34)
	frame.Position = UDim2.fromScale(0.14, 0.31)
	frame.BackgroundColor3 = Color3.fromRGB(12, 8, 24)
	frame.BackgroundTransparency = 0.06
	frame.BorderSizePixel = 0
	frame.Visible = false
	frame.Parent = screenGui

	titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.fromScale(1, 0.18)
	titleLabel.Position = UDim2.fromScale(0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = "Escolha uma mutação"
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.TextStrokeTransparency = 0.45
	titleLabel.Font = Enum.Font.GothamBlack
	titleLabel.TextScaled = true
	titleLabel.Parent = frame

	for i = 1, 3 do
		local button = Instance.new("TextButton")
		button.Name = "Choice_" .. i
		button.Size = UDim2.fromScale(0.30, 0.70)
		button.Position = UDim2.fromScale(0.035 + (i - 1) * 0.32, 0.23)
		button.BackgroundColor3 = Color3.fromRGB(35, 25, 60)
		button.BorderSizePixel = 0
		button.TextColor3 = Color3.fromRGB(255, 255, 255)
		button.TextStrokeTransparency = 0.55
		button.Font = Enum.Font.GothamBold
		button.TextScaled = true
		button.TextWrapped = true
		button.Text = ""
		button.Visible = false
		button.Parent = frame

		buttons[i] = button
	end
end

function MutationController:ShowChoices(choices)
	if #choices <= 0 then
		return
	end

	frame.Visible = true

	for i, button in ipairs(buttons) do
		local choice = choices[i]

		if choice then
			local rarity = choice.Rarity or "Common"
			local color = rarityColors[rarity] or rarityColors.Common

			button.Visible = true
			button.BackgroundColor3 = color:Lerp(Color3.fromRGB(20, 15, 35), 0.45)

			button.Text = string.format(
				"%s\n\n%s\n\n[%s]\nStack %d/%d",
				choice.DisplayName or choice.Id,
				choice.Description or "",
				rarity,
				choice.CurrentStacks or 0,
				choice.MaxStacks or 1
			)

			button.Activated:Once(function()
				Net:GetRemote("MutationChoice"):FireServer(choice.Id)
				self:HideChoices()
			end)
		else
			button.Visible = false
		end
	end
end

function MutationController:HideChoices()
	if frame then
		frame.Visible = false
	end
end

return MutationController