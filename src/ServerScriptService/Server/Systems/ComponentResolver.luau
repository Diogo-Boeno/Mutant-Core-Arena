local AbilityConfig = require(game.ReplicatedStorage.Shared.Config.AbilityConfig)

local ComponentResolver = {}

-- Mapeamento de campo do config -> componente(s) a serem gerados
-- Cada entrada retorna uma tabela de componentes (pode ser mais de um, ex: dano + slow)
local fieldMappings = {
	-- Habilidades de dano em área
	Radius = function(config, modifiers)
		-- Só gera AreaDamage se houver Damage junto
		if not config.Damage then return nil end
		local radius = config.Radius * (1 + (modifiers.AreaRadius or 0))
		local damage = config.Damage * (1 + (modifiers.AbilityDamage or 0))
		return {
			Type = "AreaDamage",
			Radius = radius,
			Damage = damage,
			MaxTargets = config.Server and config.Server.MaxTargets or 10,
			DamageType = config.Core or "Physical",
		}
	end,

	PullForce = function(config, modifiers)
		local force = config.PullForce * (1 + (modifiers.PullForce or 0))
		return {
			Type = "Pull",
			Force = force,
		}
	end,

	BurnDamage = function(config, modifiers)
		local dps = config.BurnDamage * (1 + (modifiers.DoTDamage or 0))
		return {
			Type = "DamageOverTime",
			DamagePerSecond = dps,
			Duration = 4,  -- pode ser customizável
			DamageType = "Fire",
		}
	end,

	Slow = function(config, modifiers)
		-- Percentual de slow, sem modificador por enquanto
		return {
			Type = "StatusEffect",
			Effect = "Slow",
			Strength = config.Slow,
			Duration = 3,
		}
	end,

	Stun = function(config, modifiers)
		return {
			Type = "StatusEffect",
			Effect = "Stun",
			Duration = config.Stun,
		}
	end,

	Freeze = function(config, modifiers)
		return {
			Type = "StatusEffect",
			Effect = "Freeze",
			Duration = config.Freeze,
		}
	end,

	DamageReduction = function(config, modifiers)
		return {
			Type = "SelfBuff",
			Buff = "DamageReduction",
			Value = config.DamageReduction,
			Duration = config.Duration,
		}
	end,

	ShieldHP = function(config, modifiers)
		local hp = config.ShieldHP * (1 + (modifiers.ShieldAmount or 0))
		return {
			Type = "Shield",
			HP = hp,
			Duration = config.Duration,
		}
	end,

	Invincible = function(config, modifiers)
		return {
			Type = "SelfBuff",
			Buff = "Invincible",
			Duration = config.Duration,
		}
	end,

	Distance = function(config, modifiers)
		-- Dash (se tiver InvincibleFrames) ou Teleport (se tiver Teleports)
		if config.InvincibleFrames then
			local distance = config.Distance * (1 + (modifiers.DashDistance or 0))
			return {
				Type = "Dash",
				Distance = distance,
				InvincibleDuration = config.InvincibleFrames,
			}
		elseif config.Teleports then
			local distance = config.Distance * (1 + (modifiers.TeleportRange or 0))
			return {
				Type = "Teleport",
				Count = config.Teleports,
				Distance = distance,
				Invisibility = config.Invisibility,
			}
		end
		return nil
	end,

	-- Habilidades persistentes (Blackhole, ThunderDome)
	Duration = function(config, modifiers)
		-- Apenas para habilidades que têm Radius e Duration, mas não são escudos/buffs
		if config.Radius and not config.ShieldHP and not config.DamageReduction and not config.Invincible then
			-- Ex: Blackhole, ThunderDome
			local radius = config.Radius * (1 + (modifiers.AreaRadius or 0))
			local damage = config.Damage and (config.Damage * (1 + (modifiers.AbilityDamage or 0))) or 0
			return {
				Type = "PersistentArea",
				Radius = radius,
				Damage = damage,
				Duration = config.Duration,
				PullForce = config.PullForce and (config.PullForce * (1 + (modifiers.PullForce or 0))) or nil,
				StatusEffect = config.Stun and {Effect = "Stun", Duration = config.Stun}
					or config.Freeze and {Effect = "Freeze", Duration = config.Freeze}
					or config.Slow and {Effect = "Slow", Strength = config.Slow, Duration = 3},
				MaxTargets = config.Server and config.Server.MaxTargets or 50,
			}
		end
		return nil
	end,

	-- Meteoros (HellfireStorm)
	Meteors = function(config, modifiers)
		return {
			Type = "MeteorShower",
			Count = config.Meteors,
			Radius = config.Radius,
			Damage = config.Damage,
			BurnDamage = config.BurnDamage,
			FallRadius = 25,
		}
	end,

	-- Chain (ChainLightning)
	Chains = function(config, modifiers)
		local damage = config.Damage * (1 + (modifiers.AbilityDamage or 0))
		return {
			Type = "ChainDamage",
			MaxTargets = config.Server and config.Server.MaxTargets or 30,
			Damage = damage,
			Chains = config.Chains,
			Radius = config.Radius,
			StunDuration = config.Stun,
		}
	end,
}

-- Ordem de checagem dos campos para construir a lista de componentes
local fieldOrder = {
	"Radius", "PullForce", "BurnDamage", "Slow", "Stun", "Freeze",
	"DamageReduction", "ShieldHP", "Invincible", "Distance", "Duration",
	"Meteors", "Chains",
}

function ComponentResolver.Resolve(abilityId, state)
	local config = AbilityConfig[abilityId]
	if not config then return {} end

	local modifiers = state.Modifiers
	local effects = state.Effects
	local components = {}

	local addedTypes = {} -- evita duplicar componentes do mesmo tipo

	for _, field in ipairs(fieldOrder) do
		if config[field] ~= nil and fieldMappings[field] then
			local result = fieldMappings[field](config, modifiers)
			if result then
				-- result pode ser uma tabela de componente único ou array de componentes
				if result.Type then
					-- componente único
					if not addedTypes[result.Type] then
						table.insert(components, result)
						addedTypes[result.Type] = true
					end
				elseif result[1] then
					-- array de componentes
					for _, comp in ipairs(result) do
						if not addedTypes[comp.Type] then
							table.insert(components, comp)
							addedTypes[comp.Type] = true
						end
					end
				end
			end
		end
	end

	-- Componentes condicionais (ex: DoublePulse)
	if effects.DoublePulse and config.ExtraConditional then
		local extra = ComponentResolver.Resolve(config.ExtraConditional, state) -- sub-habilidade definida no config
		for _, comp in ipairs(extra) do
			table.insert(components, comp)
		end
	end

	-- Visual sempre por último
	table.insert(components, {
		Type = "Visual",
		VFX = config.Client and config.Client.VFX,
		CameraShake = config.Client and config.Client.CameraShake,
		Sound = config.Client and config.Client.Sound,
		UserId = state.UserId, -- será preenchido pelo executor
		Origin = nil, -- preenchido pelo executor
	})

	return components
end

return ComponentResolver