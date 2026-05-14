return {
	Id       = "Immortal",
	Core     = "Defense",
	Tier     = "Ultimate",
	Cooldown = 120,

	VFX = {
		AbilityId   = "Immortal",
		Type        = "SelfBuff",
		Duration    = 5.0,
		Sound       = "GodMode",
		CameraShake = 0.60,
	},

	Display = {
		Name        = "Immortal",
		Description = "Fica invencível por 5 segundos.",
	},

	Execute = function(player, state, origin)
		local duration = 5

		state.IsInvincible = true

		task.delay(duration, function()
			state.IsInvincible = false
		end)

		-- Nota: CombatService:ApplyDamage precisa checar state.IsInvincible antes de aplicar dano
	end,
}
