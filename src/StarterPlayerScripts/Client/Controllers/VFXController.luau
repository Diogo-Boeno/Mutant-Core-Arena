local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local Net = require(ReplicatedStorage.Shared.Net.Net)

local VFXController = {}
local vfxRoot = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("VFX")

-- Cache automático: salva pastas já encontradas
local folderCache = {}

function VFXController:Init()
    print("[VFXController] Init")
    Net:OnClientEvent("ClientVFX", function(data)
        self:ExecuteVFX(data)
    end)
end

-- Encontra a pasta da habilidade automaticamente (com cache)
function VFXController:GetAbilityFolder(abilityId)
    if folderCache[abilityId] then return folderCache[abilityId] end
    
    local folder = vfxRoot:FindFirstChild(abilityId)
    if not folder then
        warn("[VFXController] Pasta VFX não encontrada para:", abilityId)
        return nil
    end
    folderCache[abilityId] = folder
    return folder
end

local function getMainPart(model)
    -- Se o modelo já tem PrimaryPart, use-o
    if model.PrimaryPart then
        return model.PrimaryPart
    end
    
    -- Caso contrário, pega a maior BasePart
    local largest
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            if not largest or part.Size.Magnitude > largest.Size.Magnitude then
                largest = part
            end
        end
    end
    
    if largest then
        model.PrimaryPart = largest  -- Define para uso futuro
    end
    return largest
end

-- Função principal que todo evento chama
function VFXController:ExecuteVFX(data)
    print("[VFXController] ExecuteVFX data:", data, type(data))
    if type(data) == "table" then
        print("  AbilityId:", data.AbilityId)
    end

    local folder = self:GetAbilityFolder(data.AbilityId)
    if not folder then return end

    
    local model = folder:FindFirstChildWhichIsA('Model')
    if not model then
        warn("[VFXController] Model não encontrado na pasta:", data.AbilityId)
        return
    end

    local effectClone = model:Clone()
    effectClone:SetPrimaryPartCFrame(CFrame.new(data.Origin))
    effectClone.Parent = workspace

    -- Ativa todos os ParticleEmitters automaticamente
    for _, emitter in ipairs(effectClone:GetDescendants()) do
        if emitter:IsA("ParticleEmitter") then
            emitter:Emit(emitter:GetAttribute("EmitCount") or 20)
        elseif emitter:IsA("PointLight") then
            emitter.Brightness = 10
            TweenService:Create(emitter, TweenInfo.new(0.5), {Brightness = 0}):Play()
        end
    end

    -- Aplica o comportamento visual baseado no VFXType
    if data.VFXType == "ExpandingArea" then
        self:ApplyExpandingArea(effectClone, data)
    elseif data.VFXType == "Projectile" then
        self:ApplyProjectile(effectClone, data)
    elseif data.VFXType == "SelfBuff" then
        self:ApplySelfBuff(effectClone, data)
    end

    -- Limpeza automática após duração
    local duration = data.VFXDuration or 1
    Debris:AddItem(effectClone, duration + 0.5)
end

-- Comportamento de área expansiva
function VFXController:ApplyExpandingArea(clone, data)
    local mainPart = getMainPart(clone)
    if mainPart then
        local targetSize = mainPart.Size * (data.VFXScale or 2)

        -- Começa pequeno
        mainPart.Size = Vector3.new(0.1, 0.1, 0.1)

        TweenService:Create(mainPart, TweenInfo.new(data.VFXDuration or 0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = targetSize,
            Transparency = 12
        }):Play()
    end
end

-- Comportamento de projétil
function VFXController:ApplyProjectile(clone, data)
    local character = self:GetCharacter(data.UserId)
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local direction = root.CFrame.LookVector
    local speed = data.ProjectileSpeed or 80

    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        if not clone.Parent then
            conn:Disconnect()
            return
        end
        clone:PivotTo(clone:GetPivot() + direction * speed * dt)
    end)
end

-- Comportamento de buff no jogador
function VFXController:ApplySelfBuff(clone, data)
    local character = self:GetCharacter(data.UserId)
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- Gruda o efeito no jogador
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = root
    weld.Part1 = clone:FindFirstChildWhichIsA("BasePart") or clone.PrimaryPart
    weld.Parent = clone
end

function VFXController:GetCharacter(userId)
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player.UserId == userId and player.Character then
            return player.Character
        end
    end
    return nil
end

return VFXController