local CombatService = require(script.Parent.Parent.Services.CombatService)

local AreaDamage = {}

function AreaDamage:Execute(player, state, comp, origin)
	local enemies = CombatService:GetEnemiesInRadius(origin, comp.Radius, comp.MaxTargets)
	for _, enemy in ipairs(enemies) do
		CombatService:ApplyDamage(player, enemy, comp.Damage, comp.DamageType)
	end
	-- Opcional: se houver efeitos secundários como queimadura, eles são componentes separados
end

return AreaDamage