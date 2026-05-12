local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = require(ReplicatedStorage.Shared.Net.Net)
local UIStyle = require(script.Parent:WaitForChild('UIStyle'))
local KeyMapping = require(ReplicatedStorage:WaitForChild('Shared'):WaitForChild('Config'):WaitForChild('InputsConfig'))

local InputController = {}

function InputController:Init()
	print("[InputController] Init")
end

function InputController:Start()
	print("[InputController] Start")

	-- UserInputService.InputBegan:Connect(function(input, gameProcessed)
	-- 	if gameProcessed then
	-- 		return
	-- 	end

	-- 	for _, config  in ipairs(KeyMapping) do
	-- 		if input.KeyCode == config.Key then
	-- 			-- a
	-- 		end
	-- 	end
	-- end)

	self:SetupInputs()
	self:SetUpAbilities()

	self:SetupStartMatchButton()
end

function InputController:SetupInputs()
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		local keyName = input.KeyCode.Name
		local mapping = KeyMapping[keyName]

		if mapping then
			self:UseAbility(mapping.AbilityId)
		end
	end)
end

function InputController:SetUpAbilities()
	local player = Players.LocalPlayer
	local screenGui = player:WaitForChild('PlayerGui'):WaitForChild('MutantCoreHUD')

	for keyName, config in pairs(KeyMapping) do
		local button = screenGui:FindFirstChild(config.AbilityId)

		if button and button:IsA('TextButton') then
			UIStyle:ApplyAbilityStyle(button, config.Color)
			button.Text = string.format('%s\n[%s]', config.AbilityId:upper(), keyName)
			button.MouseButton1Click:Connect(function()
				self:UseAbility(config.Id)
			end)
		end
	end
end

function InputController:UseAbility(abilityId)
	Net:GetRemote('AbilityRequest'):FireServer(abilityId)
end

-- function InputController:CreateMobileButton()
-- 	local Players = game:GetService("Players")
-- 	local player = Players.LocalPlayer
-- 	local playerGui = player:WaitForChild("PlayerGui")

-- 	local screenGui = playerGui:FindFirstChild("MutantCoreHUD")

-- 	if not screenGui then
-- 		return
-- 	end

-- 	local abilityButton = screenGui:WaitForChild('GravityPulseButton')

-- 	abilityButton.MouseButton1Click:Connect(function()
-- 		self:UseMainAbility()
-- 	end)
-- end

function InputController:SetupStartMatchButton()
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	local StartMatchUI = playerGui:WaitForChild("StartMatchUI")

	local TimeHUD = playerGui:WaitForChild('Timer')

	if not StartMatchUI.Enabled then StartMatchUI.Enabled = true end

	StartMatchUI.ReadyButtonBG.Button.Activated:Connect(function()
		print('[InputController] Solicitando start match...')
		Net:FireServer('RequestStartMatch')

		
		StartMatchUI.Enabled = false
		TimeHUD.Enabled = true
	end)
end

return InputController