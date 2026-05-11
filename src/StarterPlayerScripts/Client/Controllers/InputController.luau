local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = require(ReplicatedStorage.Shared.Net.Net)

local InputController = {}

local abilityButton

function InputController:Init()
	print("[InputController] Init")
end

function InputController:Start()
	print("[InputController] Start")

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		if input.KeyCode == Enum.KeyCode.Q then
			self:UseMainAbility()
		end
	end)

	self:CreateMobileButton()
	self:SetupStartMatchButton()
end

function InputController:UseMainAbility()
	Net:GetRemote("AbilityRequest"):FireServer("GravityPulse")
end

function InputController:CreateMobileButton()
	local Players = game:GetService("Players")
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	local screenGui = playerGui:FindFirstChild("MutantCoreHUD")

	if not screenGui then
		screenGui = Instance.new("ScreenGui")
		screenGui.Name = "MutantCoreHUD"
		screenGui.ResetOnSpawn = false
		screenGui.Parent = playerGui
	end

	abilityButton = Instance.new("TextButton")
	abilityButton.Name = "GravityPulseButton"
	abilityButton.Size = UDim2.fromScale(0.14, 0.14)
	abilityButton.Position = UDim2.fromScale(0.82, 0.72)
	abilityButton.BackgroundColor3 = Color3.fromRGB(70, 25, 130)
	abilityButton.BackgroundTransparency = 0.1
	abilityButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	abilityButton.TextStrokeTransparency = 0.4
	abilityButton.Font = Enum.Font.GothamBold
	abilityButton.TextSize = 18
	abilityButton.Text = "GRAVITY\nQ"
	abilityButton.Parent = screenGui

	abilityButton.MouseButton1Click:Connect(function()
		self:UseMainAbility()
	end)
end

function InputController:SetupStartMatchButton()
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	local StartMatchUI = playerGui:WaitForChild("StartMatchUI")

	StartMatchUI.ReadyButtonBG.Button.Activated:Connect(function()
		print('[InputController] Solicitando start match...')
		Net:FireServer('RequestStartMatch')

		StartMatchUI.Enabled = false
	end)
end

return InputController