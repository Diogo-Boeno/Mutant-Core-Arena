return {
	Gravity_Radius_1 = {
		Id = "Gravity_Radius_1",
		DisplayName = "Campo Expandido",
		Description = "+25% raio do Gravity Pulse",
		Core = "Gravity",
		Rarity = "Common",
		MaxStacks = 3,
		Weight = 40,

		Modifiers = {
			GravityPulseRadiusMultiplier = 0.25,
		}
	},

	Gravity_Damage_1 = {
		Id = "Gravity_Damage_1",
		DisplayName = "Singularidade Instável",
		Description = "+20% dano do Gravity Pulse",
		Core = "Gravity",
		Rarity = "Common",
		MaxStacks = 3,
		Weight = 35,

		Modifiers = {
			GravityPulseDamageMultiplier = 0.20,
		}
	},

	Gravity_Cooldown_1 = {
		Id = "Gravity_Cooldown_1",
		DisplayName = "Pulso Acelerado",
		Description = "-15% cooldown do Gravity Pulse",
		Core = "Gravity",
		Rarity = "Rare",
		MaxStacks = 2,
		Weight = 20,

		Modifiers = {
			GravityPulseCooldownMultiplier = -0.15,
		}
	},

	Gravity_DoublePulse = {
		Id = "Gravity_DoublePulse",
		DisplayName = "Pulso Duplo",
		Description = "Gravity Pulse dispara uma segunda explosão menor",
		Core = "Gravity",
		Rarity = "Epic",
		MaxStacks = 1,
		Weight = 8,

		Effects = {
			DoublePulse = true,
		}
	},

	Gravity_KillExplosion = {
		Id = "Gravity_KillExplosion",
		DisplayName = "Colapso em Cadeia",
		Description = "Inimigos mortos pelo Gravity Pulse explodem em área pequena",
		Core = "Gravity",
		Rarity = "Epic",
		MaxStacks = 1,
		Weight = 8,

		Effects = {
			KillExplosion = true,
		}
	},
}