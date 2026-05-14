return {
	Id       = "EnergyShield",
	Core     = "Defense",
	Tier     = "Advanced",
	Cooldown = 28,

	VFX = {
		AbilityId   = "EnergyShield",
		Type        = "SelfBuff",
		Duration    = 8.0,
		Sound       = "ShieldUp",
		CameraShake = 0.10,
	},

	Display = {
		Name        = "Energy Shield",
		Description = "Cria um escudo que absorve 180 de dano por 8 segundos.",
	},

	Execute = function(player, state, origin)
		local shieldHP = 180
		local duration = 8

		state.ShieldHP = (state.ShieldHP or 0) + shieldHP

		task.delay(duration, function()
			state.ShieldHP = math.max(0, (state.ShieldHP or shieldHP) - shieldHP)
		end)

		-- Nota: CombatService:ApplyDamage precisa checar state.ShieldHP antes de aplicar dano
	end,
}
