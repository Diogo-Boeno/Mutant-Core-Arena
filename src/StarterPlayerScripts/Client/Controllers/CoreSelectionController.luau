local Players          = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net          = require(ReplicatedStorage.Shared.Net.Net)
local AbilityConfig = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config"):WaitForChild("AbilityConfig"))

local localPlayer = Players.LocalPlayer

-- ─────────────────────────────────────────────────────────────────────────────
-- Dados dos cores
-- ─────────────────────────────────────────────────────────────────────────────

local DARK_BG = Color3.fromRGB(10, 7, 22)

local CORES = {
	{ name = "Gravity",  desc = "Controla gravidade\npara puxar e repelir",   color = Color3.fromRGB(70,  25,  130) },
	{ name = "Fire",     desc = "Chamas e queimadura\ncontínua nos inimigos",  color = Color3.fromRGB(230, 80,  0  ) },
	{ name = "Electric", desc = "Raios que eletrificam\ne atordoam alvos",      color = Color3.fromRGB(255, 215, 0  ) },
	{ name = "Ice",      desc = "Congela e desacelera\ninimigos ao redor",      color = Color3.fromRGB(100, 200, 255) },
	{ name = "Defense",  desc = "Escudos de energia\nque absorvem dano",        color = Color3.fromRGB(50,  150, 50 ) },
	{ name = "Mobility", desc = "Velocidade e esquiva\npara dominar terreno",   color = Color3.fromRGB(80,  80,  100) },
}

local TIER_COLORS = {
	Base     = Color3.fromRGB(130, 130, 145),
	Advanced = Color3.fromRGB(70,  120, 230),
	Ultimate = Color3.fromRGB(220, 165, 35 ),
}

-- Posições das 6 cartas de core no lado esquerdo
local CORE_COL_X = { 0.03, 0.36, 0.69 }
local CORE_ROW_Y = { 0.19, 0.51 }
local CORE_W     = 0.29
local CORE_H     = 0.27

-- ─────────────────────────────────────────────────────────────────────────────

local CoreSelectionController = {}

local screenGui    = nil
local confirmBtn   = nil
local confirmStroke = nil
local cardData     = {}   -- cardData[coreName] = { card, stroke, color }
local abilitySlots = {}   -- abilitySlots[1..3] = { frame, tierBadge, cdBadge, nameLabel, descLabel, stroke }
local placeholder  = nil
local coreTitleLabel = nil
local selectedCore = nil

-- ─────────────────────────────────────────────────────────────────────────────
-- Criação de UI
-- ─────────────────────────────────────────────────────────────────────────────

local function makeCorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 8)
	c.Parent = parent
end

local function makeStroke(parent, color, thickness, transparency)
	local s = Instance.new("UIStroke")
	s.Color        = color
	s.Thickness    = thickness or 2
	s.Transparency = transparency or 0
	s.Parent       = parent
	return s
end

local function makeLabel(parent, text, font, color, size, pos, textScaled, wrapped)
	local l = Instance.new("TextLabel")
	l.BackgroundTransparency = 1
	l.Text                   = text
	l.Font                   = font or Enum.Font.Gotham
	l.TextColor3             = color or Color3.fromRGB(255, 255, 255)
	l.Size                   = size
	l.Position               = pos
	l.TextScaled             = textScaled ~= false
	l.TextWrapped            = wrapped or false
	l.Parent                 = parent
	return l
end

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
	screenGui.Name           = "CoreSelection"
	screenGui.ResetOnSpawn   = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.DisplayOrder   = 10
	screenGui.Parent         = playerGui

	-- Overlay
	local overlay = Instance.new("Frame")
	overlay.Size                  = UDim2.fromScale(1, 1)
	overlay.BackgroundColor3      = Color3.fromRGB(3, 2, 10)
	overlay.BackgroundTransparency = 0.25
	overlay.BorderSizePixel        = 0
	overlay.Parent                 = screenGui

	-- Painel principal (duas colunas)
	local panel = Instance.new("Frame")
	panel.Name                  = "Panel"
	panel.Size                  = UDim2.fromScale(0.86, 0.84)
	panel.Position              = UDim2.fromScale(0.07, 0.08)
	panel.BackgroundColor3      = DARK_BG
	panel.BackgroundTransparency = 0.02
	panel.BorderSizePixel        = 0
	panel.Parent                 = screenGui
	makeCorner(panel, 12)
	makeStroke(panel, Color3.fromRGB(60, 40, 100), 2, 0.40)

	-- ── Divisória vertical ──────────────────────────────────────────────────
	local divider = Instance.new("Frame")
	divider.Size                  = UDim2.new(0, 1, 0.86, 0)
	divider.Position              = UDim2.fromScale(0.455, 0.07)
	divider.BackgroundColor3      = Color3.fromRGB(60, 40, 100)
	divider.BackgroundTransparency = 0.50
	divider.BorderSizePixel        = 0
	divider.Parent                 = panel

	-- ── Coluna esquerda: seleção de core ────────────────────────────────────
	local leftFrame = Instance.new("Frame")
	leftFrame.Name                  = "Left"
	leftFrame.Size                  = UDim2.fromScale(0.44, 0.92)
	leftFrame.Position              = UDim2.fromScale(0.01, 0.04)
	leftFrame.BackgroundTransparency = 1
	leftFrame.BorderSizePixel        = 0
	leftFrame.Parent                 = panel

	makeLabel(leftFrame, "ESCOLHA SEU CORE", Enum.Font.GothamBlack,
		Color3.fromRGB(255, 255, 255),
		UDim2.fromScale(1, 0.09), UDim2.fromScale(0, 0.01))

	local sub = makeLabel(leftFrame,
		"Cada Core possui habilidades únicas.",
		Enum.Font.Gotham, Color3.fromRGB(160, 140, 200),
		UDim2.fromScale(0.90, 0.06), UDim2.fromScale(0.05, 0.11))
	sub.TextWrapped = true

	-- 6 cartas de core
	for i, coreInfo in ipairs(CORES) do
		local col = (i - 1) % 3 + 1
		local row = math.ceil(i / 3)

		local card = Instance.new("TextButton")
		card.Name             = "Core_" .. coreInfo.name
		card.Size             = UDim2.fromScale(CORE_W, CORE_H)
		card.Position         = UDim2.fromScale(CORE_COL_X[col], CORE_ROW_Y[row])
		card.BackgroundColor3 = coreInfo.color:Lerp(DARK_BG, 0.65)
		card.BorderSizePixel  = 0
		card.Text             = ""
		card.AutoButtonColor  = false
		card.Parent           = leftFrame
		makeCorner(card)
		local stroke = makeStroke(card, coreInfo.color, 2, 0.65)

		makeLabel(card, coreInfo.name:upper(), Enum.Font.GothamBlack, coreInfo.color,
			UDim2.fromScale(1, 0.40), UDim2.fromScale(0, 0.08))

		local desc = makeLabel(card, coreInfo.desc, Enum.Font.Gotham,
			Color3.fromRGB(200, 185, 225),
			UDim2.fromScale(0.88, 0.44), UDim2.fromScale(0.06, 0.50))
		desc.TextWrapped = true

		cardData[coreInfo.name] = { card = card, stroke = stroke, color = coreInfo.color }

		local captured = coreInfo.name
		card.Activated:Connect(function()
			self:SelectCore(captured)
		end)
	end

	-- Botão confirmar
	confirmBtn = Instance.new("TextButton")
	confirmBtn.Name             = "Confirm"
	confirmBtn.Size             = UDim2.fromScale(0.56, 0.08)
	confirmBtn.Position         = UDim2.fromScale(0.22, 0.87)
	confirmBtn.BackgroundColor3 = Color3.fromRGB(25, 18, 50)
	confirmBtn.BorderSizePixel  = 0
	confirmBtn.Text             = "Selecione um Core"
	confirmBtn.TextColor3       = Color3.fromRGB(100, 85, 140)
	confirmBtn.Font             = Enum.Font.GothamBold
	confirmBtn.TextScaled       = true
	confirmBtn.AutoButtonColor  = false
	confirmBtn.Parent           = leftFrame
	makeCorner(confirmBtn)
	confirmStroke = makeStroke(confirmBtn, Color3.fromRGB(55, 38, 100), 2, 0.60)

	confirmBtn.Activated:Connect(function()
		if not selectedCore then return end
		Net:GetRemote("CoreSelect"):FireServer(selectedCore)
		self:Hide()
	end)

	-- ── Coluna direita: cartas de habilidade ────────────────────────────────
	local rightFrame = Instance.new("Frame")
	rightFrame.Name                  = "Right"
	rightFrame.Size                  = UDim2.fromScale(0.52, 0.92)
	rightFrame.Position              = UDim2.fromScale(0.47, 0.04)
	rightFrame.BackgroundTransparency = 1
	rightFrame.BorderSizePixel        = 0
	rightFrame.Parent                 = panel

	makeLabel(rightFrame, "HABILIDADES DO CORE", Enum.Font.GothamBlack,
		Color3.fromRGB(255, 255, 255),
		UDim2.fromScale(1, 0.08), UDim2.fromScale(0, 0.01))

	coreTitleLabel = makeLabel(rightFrame, "—", Enum.Font.GothamBold,
		Color3.fromRGB(150, 130, 185),
		UDim2.fromScale(0.90, 0.05), UDim2.fromScale(0.05, 0.09))

	-- Placeholder
	placeholder = makeLabel(rightFrame,
		"←  Selecione um core\npara ver as habilidades",
		Enum.Font.GothamBold, Color3.fromRGB(90, 75, 120),
		UDim2.fromScale(0.80, 0.30), UDim2.fromScale(0.10, 0.35))
	placeholder.TextWrapped = true

	-- 3 slots de habilidade (Base / Advanced / Ultimate)
	local SLOT_Y  = { 0.16, 0.43, 0.70 }
	local SLOT_H  = 0.25
	local SLOT_X  = 0.03
	local SLOT_W  = 0.94

	for slot = 1, 3 do
		local frame = Instance.new("Frame")
		frame.Name             = "AbilitySlot_" .. slot
		frame.Size             = UDim2.fromScale(SLOT_W, SLOT_H)
		frame.Position         = UDim2.fromScale(SLOT_X, SLOT_Y[slot])
		frame.BackgroundColor3 = DARK_BG
		frame.BorderSizePixel  = 0
		frame.Visible          = false
		frame.Parent           = rightFrame
		makeCorner(frame)
		local slotStroke = makeStroke(frame, Color3.fromRGB(60, 40, 100), 2, 0.50)

		-- Tier badge (top-left)
		local tierBadge = Instance.new("Frame")
		tierBadge.Name             = "TierBadge"
		tierBadge.Size             = UDim2.fromScale(0.22, 0.26)
		tierBadge.Position         = UDim2.fromScale(0.03, 0.07)
		tierBadge.BackgroundColor3 = Color3.fromRGB(50, 40, 80)
		tierBadge.BorderSizePixel  = 0
		tierBadge.Parent           = frame
		makeCorner(tierBadge, 4)
		local tierLabel = makeLabel(tierBadge, "BASE", Enum.Font.GothamBlack,
			Color3.fromRGB(200, 200, 210),
			UDim2.fromScale(1, 1), UDim2.fromScale(0, 0))

		-- Cooldown badge (top-right)
		local cdBadge = Instance.new("Frame")
		cdBadge.Name             = "CooldownBadge"
		cdBadge.Size             = UDim2.fromScale(0.20, 0.26)
		cdBadge.Position         = UDim2.fromScale(0.77, 0.07)
		cdBadge.BackgroundColor3 = Color3.fromRGB(20, 15, 40)
		cdBadge.BorderSizePixel  = 0
		cdBadge.Parent           = frame
		makeCorner(cdBadge, 4)
		local cdLabel = makeLabel(cdBadge, "—", Enum.Font.GothamBold,
			Color3.fromRGB(180, 165, 210),
			UDim2.fromScale(1, 1), UDim2.fromScale(0, 0))

		-- Nome da habilidade
		local nameLabel = makeLabel(frame, "", Enum.Font.GothamBlack,
			Color3.fromRGB(255, 255, 255),
			UDim2.fromScale(0.50, 0.32), UDim2.fromScale(0.03, 0.35))
		nameLabel.TextXAlignment = Enum.TextXAlignment.Left

		-- Descrição
		local descLabel = makeLabel(frame, "", Enum.Font.Gotham,
			Color3.fromRGB(190, 175, 215),
			UDim2.fromScale(0.94, 0.35), UDim2.fromScale(0.03, 0.62))
		descLabel.TextWrapped    = true
		descLabel.TextXAlignment = Enum.TextXAlignment.Left
		descLabel.TextScaled     = false
		descLabel.TextSize       = 13

		abilitySlots[slot] = {
			frame      = frame,
			stroke     = slotStroke,
			tierBadge  = tierBadge,
			tierLabel  = tierLabel,
			cdLabel    = cdLabel,
			nameLabel  = nameLabel,
			descLabel  = descLabel,
		}
	end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Lógica de seleção
-- ─────────────────────────────────────────────────────────────────────────────

function CoreSelectionController:SelectCore(coreName)
	-- Deseleciona anterior
	if selectedCore then
		local prev = cardData[selectedCore]
		if prev then
			prev.stroke.Transparency = 0.65
			prev.stroke.Thickness    = 2
			prev.card.BackgroundColor3 = prev.color:Lerp(DARK_BG, 0.65)
		end
	end

	selectedCore = coreName
	local data = cardData[coreName]
	if not data then return end

	-- Destaca core selecionado
	data.stroke.Transparency  = 0
	data.stroke.Thickness     = 3
	data.card.BackgroundColor3 = data.color:Lerp(DARK_BG, 0.40)

	-- Atualiza botão confirmar
	confirmBtn.BackgroundColor3 = data.color:Lerp(DARK_BG, 0.40)
	confirmBtn.TextColor3       = data.color
	confirmBtn.Text             = "CONFIRMAR  —  " .. coreName:upper()
	confirmStroke.Color         = data.color
	confirmStroke.Transparency  = 0

	-- Atualiza cartas de habilidade
	self:UpdateAbilityCards(coreName, data.color)
end

function CoreSelectionController:UpdateAbilityCards(coreName, coreColor)
	local abilities = AbilityConfig[coreName]
	if not abilities then return end

	coreTitleLabel.Text       = coreName:upper()
	coreTitleLabel.TextColor3 = coreColor
	placeholder.Visible       = false

	for i, ability in ipairs(abilities) do
		local slot = abilitySlots[i]
		if not slot then continue end

		local tierColor = TIER_COLORS[ability.Tier] or TIER_COLORS.Base

		-- Frame
		slot.frame.BackgroundColor3 = coreColor:Lerp(DARK_BG, 0.78)
		slot.frame.Visible          = true
		slot.stroke.Color           = coreColor
		slot.stroke.Transparency    = 0.55

		-- Tier badge
		slot.tierBadge.BackgroundColor3 = tierColor:Lerp(DARK_BG, 0.55)
		slot.tierLabel.Text             = ability.Tier:upper()
		slot.tierLabel.TextColor3       = tierColor

		-- Cooldown badge
		slot.cdLabel.Text       = ability.Cooldown .. "s"
		slot.cdLabel.TextColor3 = Color3.fromRGB(200, 185, 230)

		-- Nome e descrição
		slot.nameLabel.Text       = ability.Name
		slot.nameLabel.TextColor3 = coreColor
		slot.descLabel.Text       = ability.Description
	end
end

-- ─────────────────────────────────────────────────────────────────────────────

function CoreSelectionController:Show()
	if screenGui then screenGui.Enabled = true end
end

function CoreSelectionController:Hide()
	if screenGui then screenGui.Enabled = false end
end

return CoreSelectionController
