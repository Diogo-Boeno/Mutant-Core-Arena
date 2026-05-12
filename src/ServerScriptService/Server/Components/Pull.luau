local CombatService = require(script.Parent.Parent.Services.CombatService)

local Pull = {}

function Pull:Execute(player, state, comp, origin)
	-- Busca inimigos na área (raio pode ser configurado ou usar um valor padrão)
	local radius = comp.Radius or 50
	local enemies = CombatService:GetEnemiesInRadius(origin, radius, 100)
	for _, enemy in ipairs(enemies) do
		CombatService:ApplyPull(enemy, origin, comp.Force)
	end
end

return Pull