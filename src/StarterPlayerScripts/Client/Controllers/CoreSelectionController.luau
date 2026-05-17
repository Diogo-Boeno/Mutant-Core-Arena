local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = require(ReplicatedStorage.Shared.Net.Net)

local localPlayer = Players.LocalPlayer

local DARK_BG = Color3.fromRGB(10, 7, 22)

local CORES = {
	{ name = "Gravity",  desc = "Controla gravidade\npara puxar e repelir",    color = Color3.fromRGB(70,  25,  130) },
	{ name = "Fire",     desc = "Chamas e queimadura\ncontínua nos inimigos",   color = Color3.fromRGB(230, 80,  0)   },
	{ name = "Electric", desc = "Raios que eletrificam\ne atordoam alvos",       color = Color3.fromRGB(255, 215, 0)   },
	{ name = "Ice",      desc = "Congela e desacelera\ninimigos ao redor",       color = Color3.fromRGB(100, 200, 255) },
	{ name = "Defense",  desc = "Escudos de energia\nque absorvem dano",         color = Color3.fromRGB(50,  150, 50)  },
	{ name = "Mobility", desc = "Velocidade e esquiva\npara dominar terreno",    color = Color3.fromRGB(80,  80,  100) },
}

local CoreSelectionController = {}

local screenGui  = nil
local confirmBtn = nil
local confirmStroke = nil
local cardData   = {}
local selectedCore = nil

-- Layout constants
local COL_X  = { 0.03, 0.355, 0.68 }
local ROW_Y  = { 0.21, 0.55 }
local CARD_W = 0.29
local CARD_H = 0.30

function CoreSelectionController:Init()
	print("[CoreSelectionController] Init")
end

function CoreSelectionController:Start()
	print("[CoreSelectionController] Start")
	self:BuildUI()

	Net:OnClientEvent("MatchStateUpdate", function(payload)
		if payload.State == "Running" then
			self:Hide()
		elseif payload.State == "Waiting" then
			self:Show()
		end
	end)
end

function CoreSelectionController:BuildUI()
	local playerGui = localPlayer:WaitForChild("PlayerGui")

	screenGui = Instance.new("ScreenGui")
	screenGui.Name = "CoreSelection"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.DisplayOrder = 10
	screenGui.Parent = playerGui

	local overlay = Instance.new("Frame")
	overlay.Size = UDim2.fromScale(1, 1)
	overlay.BackgroundColor3 = Color3.fromRGB(3, 2, 10)
	overlay.BackgroundTransparency = 0.25
	overlay.BorderSizePixel = 0
	overlay.Parent = screenGui

	local panel = Instance.new("Frame")
	panel.Name = "Panel"
	panel.Size = UDim2.fromScale(0.66, 0.78)
	panel.Position = UDim2.fromScale(0.17, 0.09)
	panel.BackgroundColor3 = DARK_BG
	panel.BackgroundTransparency = 0.02
	panel.BorderSizePixel = 0
	panel.Parent = screenGui

	local panelCorner = Instance.new("UICorner")
	panelCorner.CornerRadius = UDim.new(0, 12)
	panelCorner.Parent = panel

	local panelStroke = Instance.new("UIStroke")
	panelStroke.Color = Color3.fromRGB(60, 40, 100)
	panelStroke.Thickness = 2
	panelStroke.Transparency = 0.4
	panelStroke.Parent = panel

	local title = Instance.new("TextLabel")
	title.Size = UDim2.fromScale(1, 0.10)
	title.Position = UDim2.fromScale(0, 0.03)
	title.BackgroundTransparency = 1
	title.Text = "ESCOLHA SEU CORE"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextStrokeTransparency = 0.5
	title.Font = Enum.Font.GothamBlack
	title.TextScaled = true
	title.Parent = panel

	local sub = Instance.new("TextLabel")
	sub.Size = UDim2.fromScale(0.90, 0.06)
	sub.Position = UDim2.fromScale(0.05, 0.13)
	sub.BackgroundTransparency = 1
	sub.Text = "Cada Core possui habilidades únicas. Você pode trocar antes do match começar."
	sub.TextColor3 = Color3.fromRGB(160, 140, 200)
	sub.Font = Enum.Font.Gotham
	sub.TextScaled = true
	sub.TextWrapped = true
	sub.Parent = panel

	for i, coreInfo in ipairs(CORES) do
		local col = (i - 1) % 3 + 1
		local row = math.ceil(i / 3)

		local card = Instance.new("TextButton")
		card.Name = "Core_" .. coreInfo.name
		card.Size = UDim2.fromScale(CARD_W, CARD_H)
		card.Position = UDim2.fromScale(COL_X[col], ROW_Y[row])
		card.BackgroundColor3 = coreInfo.color:Lerp(DARK_BG, 0.65)
		card.BorderSizePixel = 0
		card.Text = ""
		card.AutoButtonColor = false
		card.Parent = panel

		local cc = Instance.new("UICorner")
		cc.CornerRadius = UDim.new(0, 8)
		cc.Parent = card

		local stroke = Instance.new("UIStroke")
		stroke.Color = coreInfo.color
		stroke.Thickness = 2
		stroke.Transparency = 0.65
		stroke.Parent = card

		local nameLabel = Instance.new("TextLabel")
		nameLabel.Size = UDim2.fromScale(1, 0.40)
		nameLabel.Position = UDim2.fromScale(0, 0.08)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = coreInfo.name:upper()
		nameLabel.TextColor3 = coreInfo.color
		nameLabel.TextStrokeTransparency = 0.55
		nameLabel.Font = Enum.Font.GothamBlack
		nameLabel.TextScaled = true
		nameLabel.Parent = card

		local descLabel = Instance.new("TextLabel")
		descLabel.Size = UDim2.fromScale(0.88, 0.42)
		descLabel.Position = UDim2.fromScale(0.06, 0.50)
		descLabel.BackgroundTransparency = 1
		descLabel.Text = coreInfo.desc
		descLabel.TextColor3 = Color3.fromRGB(200, 185, 225)
		descLabel.Font = Enum.Font.Gotham
		descLabel.TextScaled = true
		descLabel.TextWrapped = true
		descLabel.Parent = card

		cardData[coreInfo.name] = { card = card, stroke = stroke, color = coreInfo.color }

		local capturedName = coreInfo.name
		card.Activated:Connect(function()
			self:SelectCore(capturedName)
		end)
	end

	confirmBtn = Instance.new("TextButton")
	confirmBtn.Name = "ConfirmBtn"
	confirmBtn.Size = UDim2.fromScale(0.36, 0.07)
	confirmBtn.Position = UDim2.fromScale(0.32, 0.88)
	confirmBtn.BackgroundColor3 = Color3.fromRGB(25, 18, 50)
	confirmBtn.BorderSizePixel = 0
	confirmBtn.Text = "Selecione um Core"
	confirmBtn.TextColor3 = Color3.fromRGB(110, 90, 150)
	confirmBtn.Font = Enum.Font.GothamBold
	confirmBtn.TextScaled = true
	confirmBtn.AutoButtonColor = false
	confirmBtn.Parent = panel

	local confirmCorner = Instance.new("UICorner")
	confirmCorner.CornerRadius = UDim.new(0, 8)
	confirmCorner.Parent = confirmBtn

	confirmStroke = Instance.new("UIStroke")
	confirmStroke.Color = Color3.fromRGB(60, 40, 100)
	confirmStroke.Thickness = 2
	confirmStroke.Transparency = 0.6
	confirmStroke.Parent = confirmBtn

	confirmBtn.Activated:Connect(function()
		if not selectedCore then return end
		Net:GetRemote("CoreSelect"):FireServer(selectedCore)
		self:Hide()
	end)
end

function CoreSelectionController:SelectCore(coreName)
	if selectedCore then
		local prev = cardData[selectedCore]
		if prev then
			prev.stroke.Transparency = 0.65
			prev.stroke.Thickness = 2
			prev.card.BackgroundColor3 = prev.color:Lerp(DARK_BG, 0.65)
		end
	end

	selectedCore = coreName
	local data = cardData[coreName]
	if not data then return end

	data.stroke.Transparency = 0
	data.stroke.Thickness = 3
	data.card.BackgroundColor3 = data.color:Lerp(DARK_BG, 0.40)

	confirmBtn.BackgroundColor3 = data.color:Lerp(DARK_BG, 0.40)
	confirmBtn.TextColor3 = data.color
	confirmBtn.Text = "CONFIRMAR  —  " .. coreName:upper()
	confirmStroke.Color = data.color
	confirmStroke.Transparency = 0
end

function CoreSelectionController:Show()
	if screenGui then
		screenGui.Enabled = true
	end
end

function CoreSelectionController:Hide()
	if screenGui then
		screenGui.Enabled = false
	end
end

return CoreSelectionController
