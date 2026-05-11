return {
	GravityPulse = {
		Id = "GravityPulse",
		Core = "Gravity",

		Cooldown = 8,
		Radius = 22,
		Damage = 35,
		PullForce = 70,

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