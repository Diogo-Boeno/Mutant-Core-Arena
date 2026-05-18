-- Display data for all abilities, accessible to both client and server.
-- Ordered per core: Base → Advanced → Ultimate.

return {
	Gravity = {
		{
			Id          = "GravityPulse",
			Name        = "Gravity Pulse",
			Description = "Emite uma onda de gravidade que empurra inimigos próximos.",
			Tier        = "Base",
			Cooldown    = 1,
		},
		{
			Id          = "GravitonWave",
			Name        = "Graviton Wave",
			Description = "Onda gravitacional que puxa e aplica slow nos inimigos.",
			Tier        = "Advanced",
			Cooldown    = 10,
		},
		{
			Id          = "Blackhole",
			Name        = "Blackhole",
			Description = "Cria um buraco negro que puxa todos os inimigos por 6 segundos.",
			Tier        = "Ultimate",
			Cooldown    = 60,
		},
	},

	Fire = {
		{
			Id          = "Fireball",
			Name        = "Fireball",
			Description = "Lança uma bola de fogo que causa dano e queimadura.",
			Tier        = "Base",
			Cooldown    = 3,
		},
		{
			Id          = "FireNova",
			Name        = "Fire Nova",
			Description = "Explosão de fogo em área ampla com queimadura.",
			Tier        = "Advanced",
			Cooldown    = 12,
		},
		{
			Id          = "HellfireStorm",
			Name        = "Hellfire Storm",
			Description = "Chuva de meteoros que devastam a área.",
			Tier        = "Ultimate",
			Cooldown    = 55,
		},
	},

	Electric = {
		{
			Id          = "LightningBolt",
			Name        = "Lightning Bolt",
			Description = "Raio que atinge inimigos próximos e aplica stun.",
			Tier        = "Base",
			Cooldown    = 5,
		},
		{
			Id          = "ChainLightning",
			Name        = "Chain Lightning",
			Description = "Raio que salta entre até 5 inimigos.",
			Tier        = "Advanced",
			Cooldown    = 11,
		},
		{
			Id          = "ThunderDome",
			Name        = "Thunder Dome",
			Description = "Cúpula elétrica que fulmina inimigos por 6 segundos.",
			Tier        = "Ultimate",
			Cooldown    = 65,
		},
	},

	Ice = {
		{
			Id          = "IceShard",
			Name        = "Ice Shard",
			Description = "Fragmentos de gelo que ferem e reduzem a velocidade dos inimigos.",
			Tier        = "Base",
			Cooldown    = 6,
		},
		{
			Id          = "FrostWave",
			Name        = "Frost Wave",
			Description = "Onda de gelo que congela inimigos por 1.5 segundos.",
			Tier        = "Advanced",
			Cooldown    = 13,
		},
		{
			Id          = "AbsoluteZero",
			Name        = "Absolute Zero",
			Description = "Congela todos os inimigos próximos e aplica slow extremo.",
			Tier        = "Ultimate",
			Cooldown    = 70,
		},
	},

	Defense = {
		{
			Id          = "IronSkin",
			Name        = "Iron Skin",
			Description = "Reduz o dano recebido em 50% por 6 segundos.",
			Tier        = "Base",
			Cooldown    = 22,
		},
		{
			Id          = "EnergyShield",
			Name        = "Energy Shield",
			Description = "Cria um escudo que absorve 180 de dano por 8 segundos.",
			Tier        = "Advanced",
			Cooldown    = 28,
		},
		{
			Id          = "Immortal",
			Name        = "Immortal",
			Description = "Fica completamente invencível por 5 segundos.",
			Tier        = "Ultimate",
			Cooldown    = 120,
		},
	},

	Mobility = {
		{
			Id          = "Dash",
			Name        = "Dash",
			Description = "Avança rapidamente na direção que está olhando.",
			Tier        = "Base",
			Cooldown    = 4,
		},
		{
			Id          = "DoubleDash",
			Name        = "Double Dash",
			Description = "Avança duas vezes em sequência.",
			Tier        = "Advanced",
			Cooldown    = 8,
		},
		{
			Id          = "PhantomStep",
			Name        = "Phantom Step",
			Description = "Teleporta 6 vezes e fica invisível por 3 segundos.",
			Tier        = "Ultimate",
			Cooldown    = 35,
		},
	},
}
