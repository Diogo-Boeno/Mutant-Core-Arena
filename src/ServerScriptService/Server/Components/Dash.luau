local Players = game:GetService("Players")

local Dash = {}

function Dash:Execute(player, state, comp, origin)
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local direction = root.CFrame.LookVector
	local targetPos = root.Position + direction * comp.Distance

	-- Aplica força para o dash (simples)
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.Sit = true -- evita animação estranha
	end

	root.AssemblyLinearVelocity = direction * 80 -- valor arbitrário, ajuste conforme necessário

	-- Invencibilidade curta
	if comp.InvincibleDuration > 0 then
		state.IsInvincible = true
		task.delay(comp.InvincibleDuration, function()
			state.IsInvincible = false
		end)
	end
end

return Dash