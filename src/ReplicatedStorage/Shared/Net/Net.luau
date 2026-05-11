local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = {}

local REMOTE_FOLDER_NAME = "Remotes"

function Net:GetRemote(name)
	local folder = ReplicatedStorage:WaitForChild(REMOTE_FOLDER_NAME)
	return folder:WaitForChild(name)
end

function Net:FireClient(player, remoteName, ...)
	self:GetRemote(remoteName):FireClient(player, ...)
end

function Net:FireAllClients(remoteName, ...)
	self:GetRemote(remoteName):FireAllClients(...)
end

function Net:OnServerEvent(remoteName, callback)
	self:GetRemote(remoteName).OnServerEvent:Connect(callback)
end

function Net:OnClientEvent(remoteName, callback)
	self:GetRemote(remoteName).OnClientEvent:Connect(callback)
end

return Net