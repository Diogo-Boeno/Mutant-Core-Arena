local StatusEffect = {}

function StatusEffect:Execute(player, state, comp, origin)
	-- Aplica um efeito de status nos inimigos atingidos (Slow, Stun, Freeze)
	-- A lógica depende de como você controla esses debuffs; aqui apenas um exemplo usando atributos
	local radius = comp.Radius or 20
	local CombatService = require(script.Parent.Parent.Services.CombatService)
	local enemies = CombatService:GetEnemiesInRadius(origin, radius, 30)

	for _, enemy in ipairs(enemies) do
		if comp.Effect == "Slow" then
			local humanoid = enemy:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.WalkSpeed = humanoid.WalkSpeed * (1 - comp.Strength)
				task.delay(comp.Duration, function()
					if humanoid and humanoid.Parent then
						humanoid.WalkSpeed = humanoid.WalkSpeed / (1 - comp.Strength) -- restaura
					end
				end)
			end
		elseif comp.Effect == "Stun" then
			local humanoid = enemy:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.PlatformStand = true
				task.delay(comp.Duration, function()
					if humanoid and humanoid.Parent then
						humanoid.PlatformStand = false
					end
				end)
			end
		elseif comp.Effect == "Freeze" then
			local root = enemy:FindFirstChild("HumanoidRootPart")
			if root then
				root.Anchored = true
				task.delay(comp.Duration, function()
					if root and root.Parent then
						root.Anchored = false
					end
				end)
			end
		end
	end
end

return StatusEffect