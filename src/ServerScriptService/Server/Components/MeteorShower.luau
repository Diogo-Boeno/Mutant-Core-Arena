local CombatService = require(script.Parent.Parent.Services.CombatService)
local Net = require(game.ReplicatedStorage.Shared.Net.Net)

local MeteorShower = {}

function MeteorShower:Execute(player, state, comp, origin)
	local count = comp.Count
	local fallRadius = comp.FallRadius or 30
	local meteorDamage = comp.Damage or 70
	local burnDamage = comp.BurnDamage
	local radius = comp.Radius

	for i = 1, count do
		-- Posição aleatória ao redor da origem
		local angle = math.random() * math.pi * 2
		local dist = math.random() * fallRadius
		local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * dist
		local impactPoint = origin + offset

		-- Dano em área no impacto
		local enemies = CombatService:GetEnemiesInRadius(impactPoint, radius, 20)
		for _, enemy in ipairs(enemies) do
			CombatService:ApplyDamage(player, enemy, meteorDamage, "Fire")
			-- Queimadura pode ser aplicada via DamageOverTime separado
			if burnDamage then
				-- Aplica DoT
			end
		end

		-- Efeito visual (pode ser disparado via Net)
		Net:FireAllClients("ClientVFX", {
			Type = "MeteorImpact",
			UserId = player.UserId,
			Origin = impactPoint,
		})

		task.wait(0.3) -- intervalo entre meteoros
	end
end

return MeteorShower