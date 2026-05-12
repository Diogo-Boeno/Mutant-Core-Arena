--// Services
local TweenService = game:GetService("TweenService")

local UIStyle = {}

--// Configurações Padrão (Fácil de mudar o tema do jogo todo aqui)
local DEFAULTS = {
	CornerScale = 0.02,
	StrokeThickness = 3,
	StrokeTransparency = 0.5,
	HoverThickness = 3.5,
	TweenTime = 0.2
}

--// Função Privada: Matemática de Cores (HSV)
local function getDerivedColors(baseColor)
	local h, s, v = baseColor:ToHSV()
	
	-- Gera um tom mais claro/suave para o gradiente
	local gradientTop = Color3.fromHSV(h, s * 0.75, math.min(1, v * 1.3))
	
	-- Gera um tom vibrante para a borda
	local strokeColor = Color3.fromHSV(h, math.min(1, s * 1.1), math.min(1, v * 1.4))
	
	return gradientTop, strokeColor
end

--// Função Principal: Estilizar Botão
function UIStyle:ApplyAbilityStyle(button: TextButton, baseColor: Color3)
	local gradientTop, strokeColor = getDerivedColors(baseColor)
	
	-- 1. Configurações do Botão
	button.BackgroundColor3 = baseColor
	button.AutoButtonColor = true
	
	-- 2. UICorner
	local corner = button:FindFirstChild("StyleCorner") or Instance.new("UICorner")
	corner.Name = "StyleCorner"
	corner.CornerRadius = UDim.new(0, DEFAULTS.CornerRadius)
	corner.Parent = button

	-- 3. UIStroke (Borda)
	local stroke = button:FindFirstChild("StyleStroke") or Instance.new("UIStroke")
	stroke.Name = "StyleStroke"
	stroke.Thickness = DEFAULTS.StrokeThickness
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Color = strokeColor
	stroke.Transparency = DEFAULTS.StrokeTransparency
	stroke.Parent = button

	-- 4. UIGradient
	local grad = button:FindFirstChild("StyleGradient") or Instance.new("UIGradient")
	grad.Name = "StyleGradient"
	grad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, gradientTop),
		ColorSequenceKeypoint.new(1, baseColor)
	})
	grad.Rotation = 90
	grad.Parent = button
	
	-- 5. Animações de Hover (Otimizadas)
	local info = TweenInfo.new(DEFAULTS.TweenTime, Enum.EasingStyle.Quad)
	
	button.MouseEnter:Connect(function()
		TweenService:Create(stroke, info, {
			Thickness = DEFAULTS.HoverThickness, 
			Transparency = 0
		}):Play()
	end)
	
	button.MouseLeave:Connect(function()
		TweenService:Create(stroke, info, {
			Thickness = DEFAULTS.StrokeThickness, 
			Transparency = DEFAULTS.StrokeTransparency
		}):Play()
	end)
end

return UIStyle