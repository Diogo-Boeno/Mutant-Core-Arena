local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = require(ReplicatedStorage.Shared.Net.Net)
local UIStyle = require(script.Parent:WaitForChild('UIStyle'))
local InputsConfig = require(ReplicatedStorage:WaitForChild('Shared'):WaitForChild('Config'):WaitForChild('InputsConfig'))

local InputController = {}
local abilityButtonTemplate = ReplicatedStorage:WaitForChild('UI'):WaitForChild('AbilityButtonTemplate')

local player = Players.LocalPlayer
local screenGui = player:WaitForChild('PlayerGui'):WaitForChild('MutantCoreHUD')
local abilitiesFrame = screenGui:WaitForChild('AbilitiesFrame')

local currentAbilities = {}
local slotButtons = {}

function InputController:Init()
	print("[InputController] Init")
end

function InputController:Start()
	print("[InputController] Start")

	self:SetupInputs()

	Net:OnClientEvent('AbilitiesUpdate', function(abilityList)
		self:UpdateAbilityButtons(abilityList)
	end)

	-- self:SetUpAbilities()

	self:SetupStartMatchButton()
end

function InputController:SetupInputs()
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		for _, slotConfig in ipairs(InputsConfig) do
			if input.KeyCode == slotConfig.Key then
				local abilityId = self:GetAbilityForSlot(slotConfig.Slot)
				if abilityId then
					self:UseAbility(abilityId)
				end
				break
			end
		end
	end)
end

function InputController:GetAbilityForSlot(slot)
	return currentAbilities[slot]
end

function InputController:UpdateAbilityButtons(abilityList)
	for _, btn in pairs(slotButtons) do
		btn:Destroy()
	end

	slotButtons = {}
	currentAbilities = {}

	for _, slotConfig in ipairs(InputsConfig) do
		local slotIndex = slotConfig.Slot
		local abilityData = abilityList[slotIndex]
		if not abilityData then continue end

		currentAbilities[slotIndex] = abilityData.Id

		-- local button = Instance.new('TextButton')
		local button = abilityButtonTemplate:Clone()
		button.Name = abilityData.Id

		button.Text = abilityData.Id:upper()

		local keyLabel = button:FindFirstChild('KeyLabel')
		if keyLabel then
			keyLabel.Text = slotConfig.Key.Name
		end
		
		local color = abilityData.Color or slotConfig.DefaultColor
		UIStyle:ApplyAbilityStyle(button, color)

		button.MouseButton1Click:Connect(function()
			self:UseAbility(abilityData.Id)
		end)

		button.Parent = abilitiesFrame
		table.insert(slotButtons, button)
	end
end

-- function InputController:SetUpAbilities()
-- 	local player = Players.LocalPlayer
-- 	local screenGui = player:WaitForChild('PlayerGui'):WaitForChild('MutantCoreHUD')

-- 	for keyName, config in pairs(KeyMapping) do
-- 		local button = screenGui:FindFirstChild(config.AbilityId)

-- 		if button and button:IsA('TextButton') then
-- 			UIStyle:ApplyAbilityStyle(button, config.Color)
-- 			button.Text = string.format('%s\n[%s]', config.AbilityId:upper(), keyName)
-- 			button.MouseButton1Click:Connect(function()
-- 				self:UseAbility(config.Id)
-- 			end)
-- 		end
-- 	end
-- end

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