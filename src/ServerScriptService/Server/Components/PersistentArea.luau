local CombatService = require(script.Parent.Parent.Services.CombatService)
local Net = require(game.ReplicatedStorage.Shared.Net.Net)

local PersistentArea = {}

function PersistentArea:Execute(player, state, comp, origin)
	local startTime = os.clock()
	local duration = comp.Duration
	local interval = 0.5 -- aplica dano a cada 0.5s

	task.spawn(function()
		while os.clock() - startTime < duration do
			local enemies = CombatService:GetEnemiesInRadius(origin, comp.Radius, comp.MaxTargets)
			for _, enemy in ipairs(enemies) do
				if comp.Damage > 0 then
					CombatService:ApplyDamage(player, enemy, comp.Damage, "Gravity") -- ou tipo genérico
				end
				if comp.PullForce then
					CombatService:ApplyPull(enemy, origin, comp.PullForce)
				end
				if comp.StatusEffect then
					-- Aplica efeito de status
				end
			end
			task.wait(interval)
		end
	end)
end

return PersistentArea