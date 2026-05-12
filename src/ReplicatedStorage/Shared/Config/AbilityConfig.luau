return {
	--// GRAVITY CORE
	-- Base Attack
	GravityPulse = {
		Id = "GravityPulse",
		Core = "Gravity",
		Cooldown = 1,
		Radius = 14,
		Damage = 20,
		PullForce = 65,

		Server = { MaxTargets = 15 },
		Client = {
			VFX = "GravityPulse",
			CameraShake = 0.35,
			Sound = "GravityPulseBoom",
		},
	},

	-- Advanced
	GravitonWave = {
		Id = "GravitonWave",
		Core = "Gravity",
		Cooldown = 10,
		Radius = 20,
		Damage = 35,
		PullForce = 90,
		Slow = 0.4, -- 40% slow por 3s

		Server = { MaxTargets = 25 },
		Client = {
			VFX = "GravitonWave",
			CameraShake = 0.45,
			Sound = "GravityWave",
		},
	},

	-- Ultimate
	Blackhole = {
		Id = "Blackhole",
		Core = "Gravity",
		Cooldown = 60,
		Radius = 30,
		Damage = 60,
		PullForce = 150,
		Duration = 8, -- Segundos ativos

		Server = { MaxTargets = 50 },
		Client = {
			VFX = "Blackhole",
			CameraShake = 0.75,
			Sound = "BlackholeRoar",
		},
	},

	--// FIRE CORE
	-- Base Attack
	Fireball = {
		Id = "Fireball",
		Core = "Fire",
		Cooldown = 3,
		Radius = 8,
		Damage = 15,
		BurnDamage = 5, -- 5 dano/seg por 4s

		Server = { MaxTargets = 10 },
		Client = {
			VFX = "Fireball",
			CameraShake = 0.15,
			Sound = "FireballWhoosh",
		},
	},

	-- Advanced
	FireNova = {
		Id = "FireNova",
		Core = "Fire",
		Cooldown = 12,
		Radius = 16,
		Damage = 30,
		BurnDamage = 8,

		Server = { MaxTargets = 20 },
		Client = {
			VFX = "FireNova",
			CameraShake = 0.40,
			Sound = "FireExplosion",
		},
	},

	-- Ultimate
	HellfireStorm = {
		Id = "HellfireStorm",
		Core = "Fire",
		Cooldown = 55,
		Radius = 25,
		Damage = 70,
		BurnDamage = 12,
		Meteors = 8, -- Número de meteoros

		Server = { MaxTargets = 40 },
		Client = {
			VFX = "HellfireStorm",
			CameraShake = 0.80,
			Sound = "ApocalypseFire",
		},
	},

	--// ELECTRIC CORE
	-- Base Attack
	LightningBolt = {
		Id = "LightningBolt",
		Core = "Electric",
		Cooldown = 5,
		Radius = 6,
		Damage = 25,
		Stun = 0.8, -- 0.8s stun

		Server = { MaxTargets = 8 },
		Client = {
			VFX = "LightningBolt",
			CameraShake = 0.25,
			Sound = "LightningStrike",
		},
	},

	-- Advanced
	ChainLightning = {
		Id = "ChainLightning",
		Core = "Electric",
		Cooldown = 11,
		Radius = 10,
		Damage = 22,
		Chains = 5, -- Salta 5 vezes
		Stun = 0.5,

		Server = { MaxTargets = 30 },
		Client = {
			VFX = "ChainLightning",
			CameraShake = 0.35,
			Sound = "ChainZap",
		},
	},

	-- Ultimate
	ThunderDome = {
		Id = "ThunderDome",
		Core = "Electric",
		Cooldown = 65,
		Radius = 22,
		Damage = 55,
		Stun = 1.5,
		Duration = 6,

		Server = { MaxTargets = 45 },
		Client = {
			VFX = "ThunderDome",
			CameraShake = 0.90,
			Sound = "ThunderRoar",
		},
	},

	--// ICE CORE
	-- Base Attack
	IceShard = {
		Id = "IceShard",
		Core = "Ice",
		Cooldown = 6,
		Radius = 7,
		Damage = 18,
		Slow = 0.3,

		Server = { MaxTargets = 12 },
		Client = {
			VFX = "IceShard",
			CameraShake = 0.20,
			Sound = "IceCrack",
		},
	},

	-- Advanced
	FrostWave = {
		Id = "FrostWave",
		Core = "Ice",
		Cooldown = 13,
		Radius = 18,
		Damage = 32,
		Freeze = 1.5, -- 1.5s congelado

		Server = { MaxTargets = 22 },
		Client = {
			VFX = "FrostWave",
			CameraShake = 0.42,
			Sound = "FrostBlast",
		},
	},

	-- Ultimate
	AbsoluteZero = {
		Id = "AbsoluteZero",
		Core = "Ice",
		Cooldown = 70,
		Radius = 28,
		Damage = 65,
		Freeze = 4,
		Slow = 0.8,

		Server = { MaxTargets = 50 },
		Client = {
			VFX = "AbsoluteZero",
			CameraShake = 1.0,
			Sound = "IceApocalypse",
		},
	},

	--// DEFESA CORE
	-- Base Attack
	IronSkin = {
		Id = "IronSkin",
		Core = "Defense",
		Cooldown = 22,
		DamageReduction = 0.5, -- 50%
		Duration = 6,

		Server = { MaxTargets = 1 },
		Client = {
			VFX = "IronSkin",
			CameraShake = 0,
			Sound = "MetalClank",
		},
	},

	-- Advanced
	EnergyShield = {
		Id = "EnergyShield",
		Core = "Defense",
		Cooldown = 28,
		ShieldHP = 180,
		Duration = 8,

		Server = { MaxTargets = 1 },
		Client = {
			VFX = "EnergyShield",
			CameraShake = 0.10,
			Sound = "ShieldUp",
		},
	},

	-- Ultimate
	Immortal = {
		Id = "Immortal",
		Core = "Defense",
		Cooldown = 120,
		Invincible = true,
		Duration = 5,

		Server = { MaxTargets = 1 },
		Client = {
			VFX = "Immortal",
			CameraShake = 0.60,
			Sound = "GodMode",
		},
	},

	--// MOBILITY CORE
	-- Base Attack
	Dash = {
		Id = "Dash",
		Core = "Mobility",
		Cooldown = 4,
		Distance = 22,
		InvincibleFrames = 0.3,

		Server = { MaxTargets = 1 },
		Client = {
			VFX = "DashTrail",
			CameraShake = 0.20,
			Sound = "Whoosh",
		},
	},

	-- Advanced
	DoubleDash = {
		Id = "DoubleDash",
		Core = "Mobility",
		Cooldown = 8,
		Dashes = 2,
		Distance = 25,
		InvincibleFrames = 0.4,

		Server = { MaxTargets = 1 },
		Client = {
			VFX = "DoubleDash",
			CameraShake = 0.30,
			Sound = "DoubleWhoosh",
		},
	},

	-- Ultimate
	PhantomStep = {
		Id = "PhantomStep",
		Core = "Mobility",
		Cooldown = 35,
		Teleports = 6,
		Distance = 28,
		Invisibility = 3, -- Segundos invisível

		Server = { MaxTargets = 1 },
		Client = {
			VFX = "PhantomStep",
			CameraShake = 0.50,
			Sound = "TeleportChain",
		},
	},
}