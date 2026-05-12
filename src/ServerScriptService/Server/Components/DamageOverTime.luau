local CombatService = require(script.Parent.Parent.Services.CombatService)

local DamageOverTime = {}

function DamageOverTime:Execute(player, state, comp, origin)
	-- Aplica DoT nos inimigos atingidos (depende de como sua lógica define os alvos)
	-- Neste exemplo simplificado, usamos os inimigos em volta (pode ser acoplado ao AreaDamage)
	local radius = comp.Radius or 15
	local duration = comp.Duration or 4
	local dps = comp.DamagePerSecond

	local enemies = CombatService:GetEnemiesInRadius(origin, radius, 20)
	for _, enemy in ipairs(enemies) do
		-- Aplica dano contínuo via task.spawn (ou use um sistema de efeitos)
		task.spawn(function()
			local elapsed = 0
			while elapsed < duration do
				local humanoid = enemy:FindFirstChildOfClass("Humanoid")
				if not humanoid or humanoid.Health <= 0 then break end
				CombatService:ApplyDamage(player, enemy, dps, comp.DamageType)
				task.wait(1)
				elapsed += 1
			end
		end)
	end
end

return DamageOverTime