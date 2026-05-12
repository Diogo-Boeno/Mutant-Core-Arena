local SelfBuff = {}

function SelfBuff:Execute(player, state, comp, origin)
	-- Aplica um buff no próprio jogador (ex: DamageReduction, Invincible)
	-- Aqui usamos atributos temporários; você pode integrar com seu sistema de stats
	if comp.Buff == "DamageReduction" then
		-- Exemplo: cria um modificador temporário em state.Modifiers
		state.Modifiers.DamageReduction = (state.Modifiers.DamageReduction or 0) + comp.Value
		task.delay(comp.Duration, function()
			state.Modifiers.DamageReduction = state.Modifiers.DamageReduction - comp.Value
		end)
	elseif comp.Buff == "Invincible" then
		-- Define invencibilidade
		local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.MaxHealth = humanoid.MaxHealth -- placeholder; o ideal é usar um sistema de dano que cheque esse estado
			-- Marca o estado
			state.IsInvincible = true
			task.delay(comp.Duration, function()
				state.IsInvincible = false
			end)
		end
	end
end

return SelfBuff