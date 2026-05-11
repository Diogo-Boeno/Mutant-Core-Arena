local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = require(ReplicatedStorage.Shared.Net.Net)

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
		end
	end)
end

function VFXController:PlayGravityPulse(payload)
	local origin = payload.Origin
	local radius = payload.Radius or 20

	local folder = Workspace:FindFirstChild("ClientEffects") or Workspace

	local sphere = Instance.new("Part")
	sphere.Name = "GravityPulseVFX"
	sphere.Shape = Enum.PartType.Ball
	sphere.Anchored = true
	sphere.CanCollide = false
	sphere.CanTouch = false
	sphere.CanQuery = false
	sphere.Material = Enum.Material.Neon
	sphere.Color = Color3.fromRGB(120, 40, 255)
	sphere.Transparency = 0.45
	sphere.Size = Vector3.new(1, 1, 1)
	sphere.Position = origin
	sphere.Parent = folder

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

return VFXController