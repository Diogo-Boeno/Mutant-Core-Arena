local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = require(ReplicatedStorage.Shared.Net.Net)

local GravityPulseVFXTemplate = ReplicatedStorage.Assets:WaitForChild('VFX'):WaitForChild('GravityPulse'):WaitForChild('DistortionSphere')

local VFXController = {}

function VFXController:Init()
	print("[VFXController] Init")

	if not Workspace:FindFirstChild("ClientEffects") then
		local folder = Instance.new("Folder")
		folder.Name = "ClientEffects"
		folder.Parent = Workspace
	end
end

function VFXController:Start()
	print("[VFXController] Start")

	Net:OnClientEvent("ClientVFX", function(payload)
		if payload.Type == "GravityPulse" then
			self:PlayGravityPulse(payload)
		elseif payload.Type == "EnemyKilled" then
			self:PlayEnemyKilled(payload)
		elseif payload.Type == "KillExplosion" then
			self:PlayKillExplosion(payload)
		elseif payload.Type == "MutationApplied" then
			self:PlayMutationApplied(payload)
		end
	end)
end

function VFXController:PlayGravityPulse(payload)
	local origin = payload.Origin
	local radius = payload.Radius or 20

	local folder = Workspace:FindFirstChild("ClientEffects") or Workspace
	local modelTest = Workspace:FindFirstChild('Bubbles')

	-- local sphere = Instance.new("Part")
	local sphere = GravityPulseVFXTemplate:Clone()
	sphere.Name = "GravityPulseVFX"
	-- sphere.Shape = Enum.PartType.Ball
	sphere.Anchored = true
	sphere.CanCollide = false
	sphere.CanTouch = false
	sphere.CanQuery = false
	-- sphere.Material = Enum.Material.Neon
	sphere.Color = Color3.fromRGB(120, 40, 255)
	-- sphere.Transparency = 0.45
	sphere.Size = Vector3.new(1, 1, 1)
	sphere.Position = origin
	sphere.Parent = folder:WaitForChild('Grav')
	-- sphere.Parent = folder

	local expandTween = TweenService:Create(
		sphere,
		TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{
			Size = Vector3.new(radius * 2, radius * 2, radius * 2),
			Transparency = 1,
		}
	)

	expandTween:Play()

	expandTween.Completed:Connect(function()
		if sphere then
			sphere:Destroy()
		end
	end)

	local ring = Instance.new("Part")
	ring.Name = "GravityPulseRing"
	ring.Shape = Enum.PartType.Cylinder
	ring.Anchored = true
	ring.CanCollide = false
	ring.CanTouch = false
	ring.CanQuery = false
	ring.Material = Enum.Material.Neon
	ring.Color = Color3.fromRGB(170, 80, 255)
	ring.Transparency = 0.25
	ring.Size = Vector3.new(0.2, 1, 1)
	ring.CFrame = CFrame.new(origin) * CFrame.Angles(0, 0, math.rad(90))
	ring.Parent = folder


	local ringTween = TweenService:Create(
		ring,
		TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{
			Size = Vector3.new(0.2, radius * 2, radius * 2),
			Transparency = 1,
		}
	)

	ringTween:Play()

	ringTween.Completed:Connect(function()
		if ring then
			ring:Destroy()
		end
	end)
end

function VFXController:PlayKillExplosion(payload)
	local origin = payload.Origin
	local radius = payload.Radius or 10
	local folder = Workspace:FindFirstChild("ClientEffects") or Workspace

	local burst = Instance.new("Part")
	burst.Name = "KillExplosionVFX"
	burst.Shape = Enum.PartType.Ball
	burst.Anchored = true
	burst.CanCollide = false
	burst.CanTouch = false
	burst.CanQuery = false
	burst.Material = Enum.Material.Neon
	burst.Color = Color3.fromRGB(255, 70, 180)
	burst.Transparency = 0.25
	burst.Size = Vector3.new(1, 1, 1)
	burst.Position = origin
	burst.Parent = folder

	local tween = game:GetService("TweenService"):Create(
		burst,
		TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{
			Size = Vector3.new(radius * 2, radius * 2, radius * 2),
			Transparency = 1,
		}
	)

	tween:Play()
	tween.Completed:Connect(function()
		burst:Destroy()
	end)
end

function VFXController:PlayMutationApplied(payload)
	local userId = payload.UserId
	local player = game:GetService("Players"):GetPlayerByUserId(userId)

	if not player or not player.Character then
		return
	end

	local root = player.Character:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end

	local folder = Workspace:FindFirstChild("ClientEffects") or Workspace

	local aura = Instance.new("Part")
	aura.Name = "MutationAppliedVFX"
	aura.Shape = Enum.PartType.Ball
	aura.Anchored = true
	aura.CanCollide = false
	aura.CanTouch = false
	aura.CanQuery = false
	aura.Material = Enum.Material.Neon
	aura.Color = Color3.fromRGB(120, 255, 210)
	aura.Transparency = 0.35
	aura.Size = Vector3.new(3, 3, 3)
	aura.Position = root.Position
	aura.Parent = folder

	local tween = game:GetService("TweenService"):Create(
		aura,
		TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{
			Size = Vector3.new(9, 9, 9),
			Transparency = 1,
		}
	)

	tween:Play()
	tween.Completed:Connect(function()
		aura:Destroy()
	end)
end

return VFXController