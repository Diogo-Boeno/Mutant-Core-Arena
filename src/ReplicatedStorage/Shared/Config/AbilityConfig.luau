return {
	GravityPulse = {
		Id = "GravityPulse",
		Core = "Gravity",

		Cooldown = 3,--8
		Radius = 24, -- 22
		Damage = 40, -- 40
		PullForce = 75, -- 70

		Server = {
			MaxTargets = 30,
		},

		Client = {
			VFX = "GravityPulse",
			CameraShake = 0.35,
			Sound = "GravityPulseBoom",
		}
	}
}