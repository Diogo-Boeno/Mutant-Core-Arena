return {
	Id       = "IronSkin",
	Core     = "Defense",
	Tier     = "Base",
	Cooldown = 22,

	VFX = {
		AbilityId   = "IronSkin",
		Type        = "SelfBuff",
		Duration    = 6.0,
		Sound       = "MetalClank",
		CameraShake = 0,
	},

	Display = {
		Name        = "Iron Skin",
		Description = "Reduz o dano recebido em 50% por 6 segundos.",
	},

	Execute = function(player, state, origin)
		local reduction = 0.5
		local duration  = 6

		state.Modifiers.DamageReduction = (state.Modifiers.DamageReduction or 0) + reduction

		task.delay(duration, function()
			state.Modifiers.DamageReduction = (state.Modifiers.DamageReduction or reduction) - reduction
		end)
	end,
}
