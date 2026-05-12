local Shield = {}

function Shield:Execute(player, state, comp, origin)
	-- Cria um escudo que absorve dano (exemplo simplificado)
	local shieldHP = comp.HP
	state.ShieldHP = (state.ShieldHP or 0) + shieldHP

	task.delay(comp.Duration, function()
		state.ShieldHP = math.max(0, (state.ShieldHP or 0) - shieldHP)
	end)
	-- Você precisará alterar o sistema de dano para considerar o escudo (ApplyDamage checar state.ShieldHP)
end

return Shield