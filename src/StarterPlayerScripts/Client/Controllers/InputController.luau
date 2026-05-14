local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService('TweenService')

local Net = require(ReplicatedStorage.Shared.Net.Net)
local UIStyle = require(script.Parent:WaitForChild('UIStyle'))
local InputsConfig = require(ReplicatedStorage:WaitForChild('Shared'):WaitForChild('Config'):WaitForChild('InputsConfig'))
local CORE_COLORS = require(script.Parent:WaitForChild('CoreColors'))

local InputController = {}
local abilityButtonTemplate = ReplicatedStorage:WaitForChild('UI'):WaitForChild('AbilityButtonTemplate')

local player = Players.LocalPlayer
local screenGui = player:WaitForChild('PlayerGui'):WaitForChild('MutantCoreHUD')
local abilitiesFrame = screenGui:WaitForChild('AbilitiesFrame')

local currentAbilities = {}
local slotButtons = {}
local cooldownFrames = {}
local cooldownEndTimes = {}
local cooldownCompletedConns = {}
local cooldownTweens = {}
local COOLDOWN_TWEEN_INFO = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

function InputController:Init()
	print("[InputController] Init")
end

function InputController:Start()
	print("[InputController] Start")

	self:SetupInputs()
	self:SetupStartMatchButton()

	Net:OnClientEvent('AbilitiesUpdate', function(abilityList)
		self:UpdateAbilityButtons(abilityList)
	end)
	
	Net:OnClientEvent('HUDUpdate', function(data)
		   print("[HUDUpdate] recebido:", data.Type, data.AbilityId)
		if data.Type == 'AbilityUsed' then
			self:StartCooldown(data.AbilityId, data.Cooldown)

			-- self:PlayAbilityShake(data.AbilityId)
		elseif data.Type == 'AbilityCooldown' then
			self:SetCooldownRemaining(data.AbilityId, data.Remaining)
		end
	end)
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
	table.clear(slotButtons)
	table.clear(currentAbilities)
	table.clear(cooldownFrames)

	for _, tween in pairs(cooldownTweens) do
		if tween then tween:Cancel() end
	end
	table.clear(cooldownTweens)

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
		
		local color = CORE_COLORS[abilityData.Core] or Color3.fromRGB(128, 128, 128)
		UIStyle:ApplyAbilityStyle(button, color)

		local cooldownOverlay = button:FindFirstChild('CooldownOverlay')
		if cooldownOverlay and cooldownOverlay:IsA('Frame') then
			cooldownOverlay.Visible = false
			cooldownOverlay.Size = UDim2.new(1, 0, 1, 0)
			cooldownOverlay.Position = UDim2.new(0, 0, 0.5, 0)
			cooldownOverlay.BackgroundTransparency = 0.9
			cooldownOverlay.BorderSizePixel = 0
			cooldownOverlay.ZIndex = 5

			cooldownFrames[abilityData.Id] = cooldownOverlay
		end

		button.MouseButton1Click:Connect(function()
			self:UseAbility(abilityData.Id)
		end)

		button.Parent = abilitiesFrame
		table.insert(slotButtons, button)


		for _, conn in pairs(cooldownCompletedConns) do
			conn:Disconnect()
		end
		table.clear(cooldownCompletedConns)
		table.clear(cooldownEndTimes)
	end
end

function InputController:UseAbility(abilityId)
    if cooldownEndTimes[abilityId] and os.clock() < cooldownEndTimes[abilityId] then
        return
    end
    Net:GetRemote('AbilityRequest'):FireServer(abilityId)
end

function InputController:StartCooldown(abilityId, duration)
	local frame = cooldownFrames[abilityId]
	if not frame then return end

	cooldownEndTimes[abilityId] = os.clock() + duration

	if cooldownCompletedConns[abilityId] then
		cooldownCompletedConns[abilityId]:Disconnect()
		cooldownCompletedConns[abilityId] = nil
	end

	if cooldownTweens[abilityId] then
		cooldownTweens[abilityId]:Cancel()
	end

	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.Visible = true
	frame.BackgroundTransparency = 0.2

	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
	local targetSize = UDim2.new(0, 0, 1, 0)
	local tween = TweenService:Create(frame, tweenInfo, { Size = targetSize })

	cooldownCompletedConns[abilityId] = tween.Completed:Connect(function()
		frame.Visible = false
		cooldownTweens[abilityId] = nil
		cooldownCompletedConns[abilityId] = nil
	end)

	tween:Play()
	cooldownTweens[abilityId] = tween
end

function InputController:SetCooldownRemaining(abilityId, remaining)
	local frame = cooldownFrames[abilityId]
	if not frame then return end

	if cooldownCompletedConns[abilityId] then
		cooldownCompletedConns[abilityId]:Disconnect()
		cooldownCompletedConns[abilityId] = nil
	end

	if cooldownTweens[abilityId] then
		cooldownTweens[abilityId]:Cancel()
	end

	if remaining > 0 then
		cooldownEndTimes[abilityId] = os.clock() + remaining
	else
		cooldownEndTimes[abilityId] = nil
	end

	frame.BackgroundTransparency = 0.75
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.Visible = true

	local tweenInfo = TweenInfo.new(remaining, Enum.EasingStyle.Linear)
	local targetSize = UDim2.new(0, 0, 1, 0)
	local tween = TweenService:Create(frame, tweenInfo, { Size = UDim2.new(0, 0, 1, 0) })

	cooldownCompletedConns[abilityId] = tween.Completed:Connect(function()
		frame.Visible = false
		cooldownTweens[abilityId] = nil
		cooldownCompletedConns[abilityId] = nil
	end)

	tween:Play()
	cooldownTweens[abilityId] = tween
end

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