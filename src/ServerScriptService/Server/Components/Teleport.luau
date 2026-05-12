local Teleport = {}

function Teleport:Execute(player, state, comp, origin)
	local count = comp.Count
	local distance = comp.Distance
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	-- Teletransporta várias vezes na direção do movimento
	local direction = root.CFrame.LookVector
	for i = 1, count do
		local newPos = root.Position + direction * distance
		root.CFrame = CFrame.new(newPos)
		task.wait(0.1) -- pequeno intervalo
	end

	-- Invisibilidade pós-teleporte (se configurado)
	if comp.Invisibility > 0 then
		-- Aplica invisibilidade (ex: transparência)
		-- Implementação depende do seu sistema visual
	end
end

return Teleport