local CombatService = require(script.Parent.Parent.Services.CombatService)

local ChainDamage = {}

function ChainDamage:Execute(player, state, comp, origin)
	local enemies = CombatService:GetEnemiesInRadius(origin, comp.Radius, comp.MaxTargets)
	local hits = {}
	local lastPos = origin

	for _, enemy in ipairs(enemies) do
		if #hits >= comp.Chains then break end
		table.insert(hits, enemy)
	end

	for i, enemy in ipairs(hits) do
		CombatService:ApplyDamage(player, enemy, comp.Damage, "Electric")
		if comp.StunDuration then
			-- Aplica stun
		end
		lastPos = enemy:FindFirstChild("HumanoidRootPart").Position
		-- Efeito visual de chain pode ser chamado aqui
		if i < #hits then
			-- efeito de raio entre lastPos e próximo
		end
	end
end

return ChainDamage