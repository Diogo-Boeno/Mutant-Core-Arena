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

-- Core → fallback color map
local CORE_COLORS = {
    Gravity  = Color3.fromRGB(140, 80, 220),
    Fire     = Color3.fromRGB(255, 100, 30),
    Electric = Color3.fromRGB(255, 240, 50),
    Ice      = Color3.fromRGB(100, 210, 255),
    Defense  = Color3.fromRGB(80, 180, 80),
    Mobility = Color3.fromRGB(255, 180, 60),
}

-- Derives a rough core name from the abilityId string prefix
local function coreFromId(abilityId)
    local lower = abilityId:lower()
    if lower:find("gravity") or lower:find("graviton") or lower:find("blackhole") then return "Gravity"
    elseif lower:find("fire") or lower:find("hellfire") then return "Fire"
    elseif lower:find("lightning") or lower:find("chain") or lower:find("thunder") then return "Electric"
    elseif lower:find("ice") or lower:find("frost") or lower:find("absolute") then return "Ice"
    elseif lower:find("iron") or lower:find("shield") or lower:find("immortal") then return "Defense"
    elseif lower:find("dash") or lower:find("phantom") then return "Mobility"
    end
    return nil
end

-- Generic expanding-sphere fallback when no VFX asset exists
function VFXController:ApplyFallbackVFX(data)
    local color = CORE_COLORS[coreFromId(data.AbilityId) or ""] or Color3.fromRGB(200, 200, 255)
    local scale = data.VFXScale or 1
    local duration = data.VFXDuration or 0.5

    local part = Instance.new("Part")
    part.Name        = "FallbackVFX_" .. data.AbilityId
    part.Shape       = Enum.PartType.Ball
    part.Material    = Enum.Material.Neon
    part.Color       = color
    part.Size        = Vector3.new(1, 1, 1)
    part.CFrame      = CFrame.new(data.Origin)
    part.Anchored    = true
    part.CanCollide  = false
    part.CastShadow  = false
    part.Transparency = 0.3
    part.Parent      = workspace

    local targetSize = 12 * scale
    TweenService:Create(part, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size        = Vector3.new(targetSize, targetSize, targetSize),
        Transparency = 1,
    }):Play()

    Debris:AddItem(part, duration + 0.1)
end

-- Função principal que todo evento chama
function VFXController:ExecuteVFX(data)
    if not data.AbilityId then return end  -- mutation or non-ability events have no AbilityId

    local folder = self:GetAbilityFolder(data.AbilityId)
    if not folder then
        -- No custom VFX asset — show generic fallback so ability still feels responsive
        if data.Origin then
            self:ApplyFallbackVFX(data)
        end
        return
    end

    local model = folder:FindFirstChildWhichIsA('Model')
    if not model then
        warn("[VFXController] Model não encontrado na pasta:", data.AbilityId)
        if data.Origin then
            self:ApplyFallbackVFX(data)
        end
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