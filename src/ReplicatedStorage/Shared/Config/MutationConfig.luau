-- MutationConfig.luau
-- 10+ mutations per ability across all 18 abilities (6 cores × 3 tiers).
-- Pattern: { Id, DisplayName, Description, Core, Rarity, MaxStacks, Weight, Modifiers={}, Effects={} }
-- Modifiers are additive and stack multiplicatively with base values.
-- Effects are boolean flags read by ability Execute functions.

return {

	-- ══════════════════════════════════════════════════
	-- GRAVITY
	-- ══════════════════════════════════════════════════

	-- ── GravityPulse ──────────────────────────────────

	Gravity_Radius_1 = {
		Id          = "Gravity_Radius_1",
		DisplayName = "Campo Expandido",
		Description = "+25% raio em todas as habilidades Gravity",
		Core        = "Gravity",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 40,
		Modifiers   = { AreaRadius = 0.25 },
	},

	Gravity_Damage_1 = {
		Id          = "Gravity_Damage_1",
		DisplayName = "Singularidade Instável",
		Description = "+20% dano do Gravity Pulse",
		Core        = "Gravity",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 35,
		Modifiers   = { GravityPulseDmg = 0.20 },
	},

	Gravity_Cooldown_1 = {
		Id          = "Gravity_Cooldown_1",
		DisplayName = "Pulso Acelerado",
		Description = "-15% cooldown do Gravity Pulse",
		Core        = "Gravity",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 20,
		Modifiers   = { GravityPulseCd = -0.15 },
	},

	Gravity_DoublePulse = {
		Id          = "Gravity_DoublePulse",
		DisplayName = "Pulso Duplo",
		Description = "Gravity Pulse dispara uma segunda explosão menor após 0.45s",
		Core        = "Gravity",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 8,
		Effects     = { DoublePulse = true },
	},

	Gravity_KillExplosion = {
		Id          = "Gravity_KillExplosion",
		DisplayName = "Colapso em Cadeia",
		Description = "Inimigos mortos pelo Gravity Pulse explodem causando dano em área",
		Core        = "Gravity",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 8,
		Effects     = { KillExplosion = true },
	},

	GravityPulse_Launch = {
		Id          = "GravityPulse_Launch",
		DisplayName = "Ejeção Gravitacional",
		Description = "Gravity Pulse arremessa inimigos para o alto",
		Core        = "Gravity",
		Rarity      = "Rare",
		MaxStacks   = 1,
		Weight      = 18,
		Effects     = { GravityPulseLaunch = true },
	},

	GravityPulse_Pull = {
		Id          = "GravityPulse_Pull",
		DisplayName = "Inversão de Polaridade",
		Description = "Gravity Pulse atrai inimigos em vez de repeli-los",
		Core        = "Gravity",
		Rarity      = "Rare",
		MaxStacks   = 1,
		Weight      = 15,
		Effects     = { GravityPulsePull = true },
	},

	GravityPulse_Stun = {
		Id          = "GravityPulse_Stun",
		DisplayName = "Colapso Gravitacional",
		Description = "Gravity Pulse atordoa inimigos por +0.6s",
		Core        = "Gravity",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 22,
		Modifiers   = { GravityPulseStun = 0.6 },
	},

	GravityPulse_Slow = {
		Id          = "GravityPulse_Slow",
		DisplayName = "Campo Gravitacional",
		Description = "Gravity Pulse aplica slow de 35% por 3 segundos",
		Core        = "Gravity",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 10,
		Effects     = { GravityPulseSlow = true },
	},

	GravityPulse_Targets = {
		Id          = "GravityPulse_Targets",
		DisplayName = "Onda Expansiva",
		Description = "+5 alvos máximos no Gravity Pulse",
		Core        = "Gravity",
		Rarity      = "Common",
		MaxStacks   = 2,
		Weight      = 35,
		Modifiers   = { GravityPulseTargets = 5 },
	},

	-- ── GravitonWave ──────────────────────────────────

	GravitonWave_Dmg = {
		Id          = "GravitonWave_Dmg",
		DisplayName = "Onda Amplificada",
		Description = "+20% dano do Graviton Wave",
		Core        = "Gravity",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 38,
		Modifiers   = { GravitonWaveDmg = 0.20 },
	},

	GravitonWave_Radius = {
		Id          = "GravitonWave_Radius",
		DisplayName = "Gravidade Estendida",
		Description = "+20% raio do Graviton Wave",
		Core        = "Gravity",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 35,
		Modifiers   = { GravitonWaveRadius = 0.20 },
	},

	GravitonWave_Cd = {
		Id          = "GravitonWave_Cd",
		DisplayName = "Frequência Gravitacional",
		Description = "-15% cooldown do Graviton Wave",
		Core        = "Gravity",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 20,
		Modifiers   = { GravitonWaveCd = -0.15 },
	},

	GravitonWave_SlowAmt = {
		Id          = "GravitonWave_SlowAmt",
		DisplayName = "Viscosidade Gravitacional",
		Description = "+10% slow do Graviton Wave",
		Core        = "Gravity",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 32,
		Modifiers   = { GravitonWaveSlowAmt = 0.10 },
	},

	GravitonWave_SlowDur = {
		Id          = "GravitonWave_SlowDur",
		DisplayName = "Onda Persistente",
		Description = "+1s de duração do slow do Graviton Wave",
		Core        = "Gravity",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 22,
		Modifiers   = { GravitonWaveSlowDur = 1.0 },
	},

	GravitonWave_Double = {
		Id          = "GravitonWave_Double",
		DisplayName = "Pulso Duplo de Onda",
		Description = "Graviton Wave dispara uma segunda onda após 0.6s",
		Core        = "Gravity",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 9,
		Effects     = { GravitonWaveDouble = true },
	},

	GravitonWave_Stun = {
		Id          = "GravitonWave_Stun",
		DisplayName = "Colapso Temporal",
		Description = "Graviton Wave atordoa inimigos por 0.8s antes do slow",
		Core        = "Gravity",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 10,
		Effects     = { GravitonWaveStun = true },
	},

	GravitonWave_Pull = {
		Id          = "GravitonWave_Pull",
		DisplayName = "Singularidade Intensa",
		Description = "+40 força de atração do Graviton Wave",
		Core        = "Gravity",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 25,
		Modifiers   = { GravitonWavePull = 40 },
	},

	GravitonWave_DoT = {
		Id          = "GravitonWave_DoT",
		DisplayName = "Fragmentação Gravitacional",
		Description = "Graviton Wave aplica 8 de dano/s por 4s nos atingidos",
		Core        = "Gravity",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 8,
		Effects     = { GravitonWaveDoT = true },
	},

	GravitonWave_Implode = {
		Id          = "GravitonWave_Implode",
		DisplayName = "Implosão Inevitável",
		Description = "Inimigos explodem ao fim do slow, causando dano em área",
		Core        = "Gravity",
		Rarity      = "Legendary",
		MaxStacks   = 1,
		Weight      = 3,
		Effects     = { GravitonWaveImplode = true },
	},

	-- ── Blackhole ─────────────────────────────────────

	Blackhole_Dmg = {
		Id          = "Blackhole_Dmg",
		DisplayName = "Singularidade Voraz",
		Description = "+25% dano por tick do Blackhole",
		Core        = "Gravity",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 36,
		Modifiers   = { BlackholeDmg = 0.25 },
	},

	Blackhole_Radius = {
		Id          = "Blackhole_Radius",
		DisplayName = "Horizonte Expandido",
		Description = "+15% raio do Blackhole",
		Core        = "Gravity",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 33,
		Modifiers   = { BlackholeRadius = 0.15 },
	},

	Blackhole_Cd = {
		Id          = "Blackhole_Cd",
		DisplayName = "Colapso Acelerado",
		Description = "-10% cooldown do Blackhole",
		Core        = "Gravity",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 18,
		Modifiers   = { BlackholeCd = -0.10 },
	},

	Blackhole_Duration = {
		Id          = "Blackhole_Duration",
		DisplayName = "Abismo Eterno",
		Description = "+1s de duração do Blackhole",
		Core        = "Gravity",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 20,
		Modifiers   = { BlackholeDuration = 1 },
	},

	Blackhole_Pull = {
		Id          = "Blackhole_Pull",
		DisplayName = "Gravidade Extrema",
		Description = "+25 força de atração do Blackhole",
		Core        = "Gravity",
		Rarity      = "Common",
		MaxStacks   = 2,
		Weight      = 30,
		Modifiers   = { BlackholePull = 25 },
	},

	Blackhole_Implode = {
		Id          = "Blackhole_Implode",
		DisplayName = "Grande Colapso",
		Description = "Blackhole explode ao encerrar, causando enorme dano em área",
		Core        = "Gravity",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 7,
		Effects     = { BlackholeImplode = true },
	},

	Blackhole_SlowField = {
		Id          = "Blackhole_SlowField",
		DisplayName = "Campo Residual",
		Description = "Deixa zona de slow por 4s após o Blackhole encerrar",
		Core        = "Gravity",
		Rarity      = "Rare",
		MaxStacks   = 1,
		Weight      = 16,
		Effects     = { BlackholeSlowField = true },
	},

	Blackhole_Singularity = {
		Id          = "Blackhole_Singularity",
		DisplayName = "Núcleo Singular",
		Description = "Inimigos no centro do Blackhole recebem 2x dano",
		Core        = "Gravity",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 9,
		Effects     = { BlackholeSingularity = true },
	},

	Blackhole_Absorb = {
		Id          = "Blackhole_Absorb",
		DisplayName = "Energia do Vácuo",
		Description = "Cada kill dentro do Blackhole restaura 15 de vida",
		Core        = "Gravity",
		Rarity      = "Legendary",
		MaxStacks   = 1,
		Weight      = 3,
		Effects     = { BlackholeAbsorb = true },
	},

	Blackhole_Freeze = {
		Id          = "Blackhole_Freeze",
		DisplayName = "Paralisia Gravitacional",
		Description = "Blackhole ancora inimigos no primeiro tick",
		Core        = "Gravity",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 8,
		Effects     = { BlackholeFreeze = true },
	},

	-- ══════════════════════════════════════════════════
	-- FIRE
	-- ══════════════════════════════════════════════════

	-- ── Fireball ──────────────────────────────────────

	Fireball_Dmg = {
		Id          = "Fireball_Dmg",
		DisplayName = "Chama Intensa",
		Description = "+20% dano do Fireball",
		Core        = "Fire",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 40,
		Modifiers   = { FireballDmg = 0.20 },
	},

	Fireball_BurnDmg = {
		Id          = "Fireball_BurnDmg",
		DisplayName = "Queimadura Profunda",
		Description = "+20% dano de queimadura do Fireball",
		Core        = "Fire",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 38,
		Modifiers   = { FireballBurnDmg = 0.20 },
	},

	Fireball_Cd = {
		Id          = "Fireball_Cd",
		DisplayName = "Disparo Rápido",
		Description = "-15% cooldown do Fireball",
		Core        = "Fire",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 20,
		Modifiers   = { FireballCd = -0.15 },
	},

	Fireball_Radius = {
		Id          = "Fireball_Radius",
		DisplayName = "Explosão Maior",
		Description = "+20% raio de explosão do Fireball",
		Core        = "Fire",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 35,
		Modifiers   = { FireballRadius = 0.20 },
	},

	Fireball_BurnDur = {
		Id          = "Fireball_BurnDur",
		DisplayName = "Chama Persistente",
		Description = "+1s de duração da queimadura do Fireball",
		Core        = "Fire",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 22,
		Modifiers   = { FireballBurnDur = 1 },
	},

	Fireball_Pierce = {
		Id          = "Fireball_Pierce",
		DisplayName = "Chama Penetrante",
		Description = "Fireball atravessa todos os inimigos sem parar",
		Core        = "Fire",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 9,
		Effects     = { FireballPierce = true },
	},

	Fireball_Split = {
		Id          = "Fireball_Split",
		DisplayName = "Fragmentação Ígnea",
		Description = "Fireball se divide em 3 projéteis menores ao atingir",
		Core        = "Fire",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 7,
		Effects     = { FireballSplit = true },
	},

	Fireball_Double = {
		Id          = "Fireball_Double",
		DisplayName = "Rajada de Chamas",
		Description = "Fireball dispara 2 projéteis simultaneamente",
		Core        = "Fire",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 8,
		Effects     = { FireballDouble = true },
	},

	Fireball_Explosive = {
		Id          = "Fireball_Explosive",
		DisplayName = "Impacto Devastador",
		Description = "Fireball causa dano em área ao atingir qualquer superfície",
		Core        = "Fire",
		Rarity      = "Rare",
		MaxStacks   = 1,
		Weight      = 15,
		Effects     = { FireballExplosive = true },
	},

	Fireball_Speed = {
		Id          = "Fireball_Speed",
		DisplayName = "Faísca Veloz",
		Description = "+15 velocidade do Fireball",
		Core        = "Fire",
		Rarity      = "Common",
		MaxStacks   = 2,
		Weight      = 30,
		Modifiers   = { FireballSpeed = 15 },
	},

	-- ── FireNova ──────────────────────────────────────

	FireNova_Dmg = {
		Id          = "FireNova_Dmg",
		DisplayName = "Nova Devastadora",
		Description = "+20% dano do Fire Nova",
		Core        = "Fire",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 40,
		Modifiers   = { FireNovaDmg = 0.20 },
	},

	FireNova_Radius = {
		Id          = "FireNova_Radius",
		DisplayName = "Onda Expansiva de Fogo",
		Description = "+15% raio do Fire Nova",
		Core        = "Fire",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 36,
		Modifiers   = { FireNovaRadius = 0.15 },
	},

	FireNova_Cd = {
		Id          = "FireNova_Cd",
		DisplayName = "Combustão Acelerada",
		Description = "-12% cooldown do Fire Nova",
		Core        = "Fire",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 20,
		Modifiers   = { FireNovaCd = -0.12 },
	},

	FireNova_BurnDmg = {
		Id          = "FireNova_BurnDmg",
		DisplayName = "Brasas Intensas",
		Description = "+25% dano de queimadura do Fire Nova",
		Core        = "Fire",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 35,
		Modifiers   = { FireNovaBurnDmg = 0.25 },
	},

	FireNova_BurnDur = {
		Id          = "FireNova_BurnDur",
		DisplayName = "Inferno Duradouro",
		Description = "+1s de queimadura do Fire Nova",
		Core        = "Fire",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 22,
		Modifiers   = { FireNovaBurnDur = 1 },
	},

	FireNova_SecondWave = {
		Id          = "FireNova_SecondWave",
		DisplayName = "Segunda Onda",
		Description = "Fire Nova dispara uma segunda explosão 1s depois",
		Core        = "Fire",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 9,
		Effects     = { FireNovaSecondWave = true },
	},

	FireNova_Knockback = {
		Id          = "FireNova_Knockback",
		DisplayName = "Explosão Violenta",
		Description = "Fire Nova arremessa inimigos para fora da área",
		Core        = "Fire",
		Rarity      = "Rare",
		MaxStacks   = 1,
		Weight      = 18,
		Effects     = { FireNovaKnockback = true },
	},

	FireNova_Lingering = {
		Id          = "FireNova_Lingering",
		DisplayName = "Fogo Residual",
		Description = "Fire Nova deixa chamas no chão por 3s causando dano contínuo",
		Core        = "Fire",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 8,
		Effects     = { FireNovaLingering = true },
	},

	FireNova_Slow = {
		Id          = "FireNova_Slow",
		DisplayName = "Calor Sufocante",
		Description = "Inimigos em chamas têm velocidade reduzida em 30%",
		Core        = "Fire",
		Rarity      = "Rare",
		MaxStacks   = 1,
		Weight      = 16,
		Effects     = { FireNovaSlow = true },
	},

	FireNova_Stagger = {
		Id          = "FireNova_Stagger",
		DisplayName = "Onda de Choque",
		Description = "Fire Nova atordoa inimigos por 0.5s no impacto",
		Core        = "Fire",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 10,
		Effects     = { FireNovaStagger = true },
	},

	-- ── HellfireStorm ─────────────────────────────────

	HellfireStorm_Dmg = {
		Id          = "HellfireStorm_Dmg",
		DisplayName = "Meteoro Ardente",
		Description = "+20% dano por meteoro",
		Core        = "Fire",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 38,
		Modifiers   = { HellfireStormDmg = 0.20 },
	},

	HellfireStorm_Count = {
		Id          = "HellfireStorm_Count",
		DisplayName = "Chuva Torrencial",
		Description = "+2 meteoros por ativação",
		Core        = "Fire",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 22,
		Modifiers   = { HellfireStormCount = 2 },
	},

	HellfireStorm_Cd = {
		Id          = "HellfireStorm_Cd",
		DisplayName = "Fúria Celestial",
		Description = "-10% cooldown do Hellfire Storm",
		Core        = "Fire",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 18,
		Modifiers   = { HellfireStormCd = -0.10 },
	},

	HellfireStorm_Radius = {
		Id          = "HellfireStorm_Radius",
		DisplayName = "Impacto Expansivo",
		Description = "+15% raio de explosão por meteoro",
		Core        = "Fire",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 33,
		Modifiers   = { HellfireStormRadius = 0.15 },
	},

	HellfireStorm_BurnDur = {
		Id          = "HellfireStorm_BurnDur",
		DisplayName = "Cinzas Eternas",
		Description = "+1s de queimadura por meteoro",
		Core        = "Fire",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 20,
		Modifiers   = { HellfireStormBurnDur = 1 },
	},

	HellfireStorm_FinalBlast = {
		Id          = "HellfireStorm_FinalBlast",
		DisplayName = "Último Meteoro",
		Description = "O último meteoro causa 3x de dano e tem área triplicada",
		Core        = "Fire",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 8,
		Effects     = { HellfireStormFinalBlast = true },
	},

	HellfireStorm_Inferno = {
		Id          = "HellfireStorm_Inferno",
		DisplayName = "Solo em Chamas",
		Description = "Meteoros deixam fogo no chão por 4s causando dano contínuo",
		Core        = "Fire",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 7,
		Effects     = { HellfireStormInferno = true },
	},

	HellfireStorm_Stun = {
		Id          = "HellfireStorm_Stun",
		DisplayName = "Impacto Sísmico",
		Description = "Cada meteoro atordoa inimigos por 0.5s",
		Core        = "Fire",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 9,
		Effects     = { HellfireStormStun = true },
	},

	HellfireStorm_Focus = {
		Id          = "HellfireStorm_Focus",
		DisplayName = "Ponto de Convergência",
		Description = "Todos os meteoros caem no mesmo ponto para máximo impacto",
		Core        = "Fire",
		Rarity      = "Legendary",
		MaxStacks   = 1,
		Weight      = 3,
		Effects     = { HellfireStormFocus = true },
	},

	HellfireStorm_Chain = {
		Id          = "HellfireStorm_Chain",
		DisplayName = "Explosão em Cadeia",
		Description = "Explosões de meteoro propagam dano para inimigos próximos",
		Core        = "Fire",
		Rarity      = "Legendary",
		MaxStacks   = 1,
		Weight      = 4,
		Effects     = { HellfireStormChain = true },
	},

	-- ══════════════════════════════════════════════════
	-- ELECTRIC
	-- ══════════════════════════════════════════════════

	-- ── LightningBolt ─────────────────────────────────

	LightningBolt_Dmg = {
		Id          = "LightningBolt_Dmg",
		DisplayName = "Voltagem Alta",
		Description = "+20% dano do Lightning Bolt",
		Core        = "Electric",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 40,
		Modifiers   = { LightningBoltDmg = 0.20 },
	},

	LightningBolt_Radius = {
		Id          = "LightningBolt_Radius",
		DisplayName = "Arco Elétrico",
		Description = "+25% raio do Lightning Bolt",
		Core        = "Electric",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 36,
		Modifiers   = { LightningBoltRadius = 0.25 },
	},

	LightningBolt_Cd = {
		Id          = "LightningBolt_Cd",
		DisplayName = "Descarga Acelerada",
		Description = "-15% cooldown do Lightning Bolt",
		Core        = "Electric",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 20,
		Modifiers   = { LightningBoltCd = -0.15 },
	},

	LightningBolt_StunDur = {
		Id          = "LightningBolt_StunDur",
		DisplayName = "Paralisia Prolongada",
		Description = "+0.3s de stun do Lightning Bolt",
		Core        = "Electric",
		Rarity      = "Rare",
		MaxStacks   = 3,
		Weight      = 25,
		Modifiers   = { LightningBoltStunDur = 0.3 },
	},

	LightningBolt_Targets = {
		Id          = "LightningBolt_Targets",
		DisplayName = "Campo de Raios",
		Description = "+4 alvos máximos no Lightning Bolt",
		Core        = "Electric",
		Rarity      = "Common",
		MaxStacks   = 2,
		Weight      = 32,
		Modifiers   = { LightningBoltTargets = 4 },
	},

	LightningBolt_Chain = {
		Id          = "LightningBolt_Chain",
		DisplayName = "Raio em Cadeia",
		Description = "Lightning Bolt salta para 2 inimigos adicionais após o primeiro",
		Core        = "Electric",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 9,
		Effects     = { LightningBoltChain = true },
	},

	LightningBolt_Double = {
		Id          = "LightningBolt_Double",
		DisplayName = "Dupla Descarga",
		Description = "Lightning Bolt dispara duas vezes em sequência",
		Core        = "Electric",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 8,
		Effects     = { LightningBoltDouble = true },
	},

	LightningBolt_Shock = {
		Id          = "LightningBolt_Shock",
		DisplayName = "Choque Persistente",
		Description = "Lightning Bolt aplica 6 de dano/s por 3s após o stun",
		Core        = "Electric",
		Rarity      = "Rare",
		MaxStacks   = 1,
		Weight      = 18,
		Effects     = { LightningBoltShock = true },
	},

	LightningBolt_Overload = {
		Id          = "LightningBolt_Overload",
		DisplayName = "Sobrecarga Elétrica",
		Description = "Ao fim do stun, inimigos explodem causando dano em área",
		Core        = "Electric",
		Rarity      = "Legendary",
		MaxStacks   = 1,
		Weight      = 3,
		Effects     = { LightningBoltOverload = true },
	},

	LightningBolt_EMP = {
		Id          = "LightningBolt_EMP",
		DisplayName = "Pulso EMP",
		Description = "Após o stun, inimigos ficam 40% mais lentos por 2s",
		Core        = "Electric",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 10,
		Effects     = { LightningBoltEMP = true },
	},

	-- ── ChainLightning ────────────────────────────────

	ChainLightning_Dmg = {
		Id          = "ChainLightning_Dmg",
		DisplayName = "Corrente Amplificada",
		Description = "+20% dano do Chain Lightning",
		Core        = "Electric",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 40,
		Modifiers   = { ChainLightningDmg = 0.20 },
	},

	ChainLightning_Chains = {
		Id          = "ChainLightning_Chains",
		DisplayName = "Corrente Longa",
		Description = "+2 saltos do Chain Lightning",
		Core        = "Electric",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 22,
		Modifiers   = { ChainLightningChains = 2 },
	},

	ChainLightning_Cd = {
		Id          = "ChainLightning_Cd",
		DisplayName = "Carga Rápida",
		Description = "-12% cooldown do Chain Lightning",
		Core        = "Electric",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 20,
		Modifiers   = { ChainLightningCd = -0.12 },
	},

	ChainLightning_JumpRadius = {
		Id          = "ChainLightning_JumpRadius",
		DisplayName = "Arco Estendido",
		Description = "+4 raio de salto do Chain Lightning",
		Core        = "Electric",
		Rarity      = "Common",
		MaxStacks   = 2,
		Weight      = 30,
		Modifiers   = { ChainLightningJump = 4 },
	},

	ChainLightning_StunDur = {
		Id          = "ChainLightning_StunDur",
		DisplayName = "Corrente Paralisante",
		Description = "+0.25s de stun por salto do Chain Lightning",
		Core        = "Electric",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 24,
		Modifiers   = { ChainLightningStunDur = 0.25 },
	},

	ChainLightning_Shock = {
		Id          = "ChainLightning_Shock",
		DisplayName = "Choque Encadeado",
		Description = "Cada alvo atingido pelo Chain Lightning recebe 5 de dano/s por 3s",
		Core        = "Electric",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 9,
		Effects     = { ChainLightningShock = true },
	},

	ChainLightning_Overload = {
		Id          = "ChainLightning_Overload",
		DisplayName = "Descarga Final",
		Description = "O último alvo do Chain Lightning recebe 3x de dano",
		Core        = "Electric",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 8,
		Effects     = { ChainLightningOverload = true },
	},

	ChainLightning_Return = {
		Id          = "ChainLightning_Return",
		DisplayName = "Corrente de Retorno",
		Description = "Chain Lightning retorna ao primeiro alvo, atingindo todos novamente",
		Core        = "Electric",
		Rarity      = "Legendary",
		MaxStacks   = 1,
		Weight      = 3,
		Effects     = { ChainLightningReturn = true },
	},

	ChainLightning_Amplify = {
		Id          = "ChainLightning_Amplify",
		DisplayName = "Amplificação em Cadeia",
		Description = "Cada salto do Chain Lightning causa 15% mais dano que o anterior",
		Core        = "Electric",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 7,
		Effects     = { ChainLightningAmplify = true },
	},

	ChainLightning_Double = {
		Id          = "ChainLightning_Double",
		DisplayName = "Dupla Corrente",
		Description = "Chain Lightning dispara uma segunda cadeia com 0.3s de delay",
		Core        = "Electric",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 10,
		Effects     = { ChainLightningDouble = true },
	},

	-- ── ThunderDome ───────────────────────────────────

	ThunderDome_Dmg = {
		Id          = "ThunderDome_Dmg",
		DisplayName = "Cúpula Devastadora",
		Description = "+20% dano por tick do Thunder Dome",
		Core        = "Electric",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 38,
		Modifiers   = { ThunderDomeDmg = 0.20 },
	},

	ThunderDome_Radius = {
		Id          = "ThunderDome_Radius",
		DisplayName = "Cúpula Expandida",
		Description = "+15% raio do Thunder Dome",
		Core        = "Electric",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 34,
		Modifiers   = { ThunderDomeRadius = 0.15 },
	},

	ThunderDome_Cd = {
		Id          = "ThunderDome_Cd",
		DisplayName = "Recarga Acelerada",
		Description = "-10% cooldown do Thunder Dome",
		Core        = "Electric",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 18,
		Modifiers   = { ThunderDomeCd = -0.10 },
	},

	ThunderDome_Duration = {
		Id          = "ThunderDome_Duration",
		DisplayName = "Cúpula Duradoura",
		Description = "+1s de duração do Thunder Dome",
		Core        = "Electric",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 20,
		Modifiers   = { ThunderDomeDuration = 1 },
	},

	ThunderDome_StunDur = {
		Id          = "ThunderDome_StunDur",
		DisplayName = "Paralisia Total",
		Description = "+0.3s de stun por tick do Thunder Dome",
		Core        = "Electric",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 22,
		Modifiers   = { ThunderDomeStunDur = 0.3 },
	},

	ThunderDome_Slow = {
		Id          = "ThunderDome_Slow",
		DisplayName = "Cúpula Viscosa",
		Description = "Inimigos dentro do Thunder Dome ficam 40% mais lentos",
		Core        = "Electric",
		Rarity      = "Rare",
		MaxStacks   = 1,
		Weight      = 16,
		Effects     = { ThunderDomeSlow = true },
	},

	ThunderDome_Magnetic = {
		Id          = "ThunderDome_Magnetic",
		DisplayName = "Campo Magnético",
		Description = "Thunder Dome atrai inimigos ao centro a cada tick",
		Core        = "Electric",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 9,
		Effects     = { ThunderDomeMagnetic = true },
	},

	ThunderDome_Supercharge = {
		Id          = "ThunderDome_Supercharge",
		DisplayName = "Sobrecarga Crescente",
		Description = "Dano do Thunder Dome aumenta 20% a cada segundo",
		Core        = "Electric",
		Rarity      = "Legendary",
		MaxStacks   = 1,
		Weight      = 3,
		Effects     = { ThunderDomeSupercharge = true },
	},

	ThunderDome_Implode = {
		Id          = "ThunderDome_Implode",
		DisplayName = "Colapso da Cúpula",
		Description = "Thunder Dome explode ao encerrar, causando dano enorme em área",
		Core        = "Electric",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 7,
		Effects     = { ThunderDomeImplode = true },
	},

	ThunderDome_Shock = {
		Id          = "ThunderDome_Shock",
		DisplayName = "Choque Acumulado",
		Description = "Cada tick do Thunder Dome aplica 5 de dano/s por 2s",
		Core        = "Electric",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 10,
		Effects     = { ThunderDomeShock = true },
	},

	-- ══════════════════════════════════════════════════
	-- ICE
	-- ══════════════════════════════════════════════════

	-- ── IceShard ──────────────────────────────────────

	IceShard_Dmg = {
		Id          = "IceShard_Dmg",
		DisplayName = "Cristal Afiado",
		Description = "+20% dano do Ice Shard",
		Core        = "Ice",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 40,
		Modifiers   = { IceShardDmg = 0.20 },
	},

	IceShard_Radius = {
		Id          = "IceShard_Radius",
		DisplayName = "Área de Gelo",
		Description = "+25% raio do Ice Shard",
		Core        = "Ice",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 36,
		Modifiers   = { IceShardRadius = 0.25 },
	},

	IceShard_Cd = {
		Id          = "IceShard_Cd",
		DisplayName = "Tempestade Gelada",
		Description = "-15% cooldown do Ice Shard",
		Core        = "Ice",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 20,
		Modifiers   = { IceShardCd = -0.15 },
	},

	IceShard_SlowAmt = {
		Id          = "IceShard_SlowAmt",
		DisplayName = "Congelamento Lento",
		Description = "+10% slow do Ice Shard",
		Core        = "Ice",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 34,
		Modifiers   = { IceShardSlowAmt = 0.10 },
	},

	IceShard_SlowDur = {
		Id          = "IceShard_SlowDur",
		DisplayName = "Gelo Persistente",
		Description = "+0.5s de duração do slow do Ice Shard",
		Core        = "Ice",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 22,
		Modifiers   = { IceShardSlowDur = 0.5 },
	},

	IceShard_Triple = {
		Id          = "IceShard_Triple",
		DisplayName = "Rajada Tripla",
		Description = "Ice Shard dispara 3 ondas de fragmentos em rápida sucessão",
		Core        = "Ice",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 9,
		Effects     = { IceShardTriple = true },
	},

	IceShard_Freeze = {
		Id          = "IceShard_Freeze",
		DisplayName = "Cristalização Súbita",
		Description = "Ice Shard tem 30% de chance de congelar completamente por 1s",
		Core        = "Ice",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 8,
		Effects     = { IceShardFreeze = true },
	},

	IceShard_Shatter = {
		Id          = "IceShard_Shatter",
		DisplayName = "Estilhaço de Gelo",
		Description = "Inimigos já congelados recebem 50% mais dano do Ice Shard",
		Core        = "Ice",
		Rarity      = "Rare",
		MaxStacks   = 1,
		Weight      = 15,
		Effects     = { IceShardShatter = true },
	},

	IceShard_Splinter = {
		Id          = "IceShard_Splinter",
		DisplayName = "Fragmentação Gélida",
		Description = "Cada alvo atingido libera 2 estilhaços menores que atingem inimigos próximos",
		Core        = "Ice",
		Rarity      = "Legendary",
		MaxStacks   = 1,
		Weight      = 3,
		Effects     = { IceShardSplinter = true },
	},

	IceShard_Targets = {
		Id          = "IceShard_Targets",
		DisplayName = "Tempestade de Cristais",
		Description = "+6 alvos máximos no Ice Shard",
		Core        = "Ice",
		Rarity      = "Common",
		MaxStacks   = 2,
		Weight      = 30,
		Modifiers   = { IceShardTargets = 6 },
	},

	-- ── FrostWave ─────────────────────────────────────

	FrostWave_Dmg = {
		Id          = "FrostWave_Dmg",
		DisplayName = "Onda Glacial",
		Description = "+20% dano do Frost Wave",
		Core        = "Ice",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 40,
		Modifiers   = { FrostWaveDmg = 0.20 },
	},

	FrostWave_Radius = {
		Id          = "FrostWave_Radius",
		DisplayName = "Tempestade de Gelo",
		Description = "+20% raio do Frost Wave",
		Core        = "Ice",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 36,
		Modifiers   = { FrostWaveRadius = 0.20 },
	},

	FrostWave_Cd = {
		Id          = "FrostWave_Cd",
		DisplayName = "Blizzard Rápida",
		Description = "-12% cooldown do Frost Wave",
		Core        = "Ice",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 20,
		Modifiers   = { FrostWaveCd = -0.12 },
	},

	FrostWave_FreezeDur = {
		Id          = "FrostWave_FreezeDur",
		DisplayName = "Congelamento Profundo",
		Description = "+0.5s de duração do congelamento do Frost Wave",
		Core        = "Ice",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 22,
		Modifiers   = { FrostWaveFreezeDur = 0.5 },
	},

	FrostWave_Double = {
		Id          = "FrostWave_Double",
		DisplayName = "Dupla Onda Gélida",
		Description = "Frost Wave dispara uma segunda onda após 0.5s",
		Core        = "Ice",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 9,
		Effects     = { FrostWaveDouble = true },
	},

	FrostWave_Slow = {
		Id          = "FrostWave_Slow",
		DisplayName = "Névoa Polar",
		Description = "Após o descongelamento, inimigos ficam 40% mais lentos por 2s",
		Core        = "Ice",
		Rarity      = "Rare",
		MaxStacks   = 1,
		Weight      = 18,
		Effects     = { FrostWaveSlow = true },
	},

	FrostWave_Shatter = {
		Id          = "FrostWave_Shatter",
		DisplayName = "Impacto de Gelo",
		Description = "Inimigos congelados recebem 40% mais dano",
		Core        = "Ice",
		Rarity      = "Rare",
		MaxStacks   = 1,
		Weight      = 16,
		Effects     = { FrostWaveShatter = true },
	},

	FrostWave_IceField = {
		Id          = "FrostWave_IceField",
		DisplayName = "Campo de Gelo",
		Description = "Frost Wave deixa piso escorregadio por 5s aplicando slow de 25%",
		Core        = "Ice",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 8,
		Effects     = { FrostWaveIceField = true },
	},

	FrostWave_Chill = {
		Id          = "FrostWave_Chill",
		DisplayName = "Arrepio Polar",
		Description = "Frost Wave aplica slow de 20% por 1s antes do congelamento",
		Core        = "Ice",
		Rarity      = "Common",
		MaxStacks   = 1,
		Weight      = 28,
		Effects     = { FrostWaveChill = true },
	},

	FrostWave_BreakExplosion = {
		Id          = "FrostWave_BreakExplosion",
		DisplayName = "Explosão de Gelo",
		Description = "Inimigos explodem em fragmentos de gelo ao descongelar",
		Core        = "Ice",
		Rarity      = "Legendary",
		MaxStacks   = 1,
		Weight      = 3,
		Effects     = { FrostWaveBreak = true },
	},

	-- ── AbsoluteZero ──────────────────────────────────

	AbsoluteZero_Dmg = {
		Id          = "AbsoluteZero_Dmg",
		DisplayName = "Zero Absoluto",
		Description = "+20% dano do Absolute Zero",
		Core        = "Ice",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 38,
		Modifiers   = { AbsoluteZeroDmg = 0.20 },
	},

	AbsoluteZero_Radius = {
		Id          = "AbsoluteZero_Radius",
		DisplayName = "Território Glacial",
		Description = "+15% raio do Absolute Zero",
		Core        = "Ice",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 34,
		Modifiers   = { AbsoluteZeroRadius = 0.15 },
	},

	AbsoluteZero_Cd = {
		Id          = "AbsoluteZero_Cd",
		DisplayName = "Inverno Eterno",
		Description = "-10% cooldown do Absolute Zero",
		Core        = "Ice",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 18,
		Modifiers   = { AbsoluteZeroCd = -0.10 },
	},

	AbsoluteZero_FreezeDur = {
		Id          = "AbsoluteZero_FreezeDur",
		DisplayName = "Congelamento Eterno",
		Description = "+0.5s de duração do congelamento do Absolute Zero",
		Core        = "Ice",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 20,
		Modifiers   = { AbsoluteZeroFreezeDur = 0.5 },
	},

	AbsoluteZero_SlowAmt = {
		Id          = "AbsoluteZero_SlowAmt",
		DisplayName = "Slow Extremo",
		Description = "+5% de slow do Absolute Zero",
		Core        = "Ice",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 32,
		Modifiers   = { AbsoluteZeroSlowAmt = 0.05 },
	},

	AbsoluteZero_SlowDur = {
		Id          = "AbsoluteZero_SlowDur",
		DisplayName = "Slow Prolongado",
		Description = "+1s de duração do slow do Absolute Zero",
		Core        = "Ice",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 22,
		Modifiers   = { AbsoluteZeroSlowDur = 1 },
	},

	AbsoluteZero_Shatter = {
		Id          = "AbsoluteZero_Shatter",
		DisplayName = "Estilhaços Letais",
		Description = "Ao descongelar, inimigos explodem causando dano em área",
		Core        = "Ice",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 8,
		Effects     = { AbsoluteZeroShatter = true },
	},

	AbsoluteZero_Permafrost = {
		Id          = "AbsoluteZero_Permafrost",
		DisplayName = "Permafrost",
		Description = "Após descongelar, inimigos não podem recuperar velocidade total por 3s extras",
		Core        = "Ice",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 9,
		Effects     = { AbsoluteZeroPermafrost = true },
	},

	AbsoluteZero_Crystal = {
		Id          = "AbsoluteZero_Crystal",
		DisplayName = "Armadura Cristalina",
		Description = "Inimigos congelados recebem 2x de dano de qualquer fonte",
		Core        = "Ice",
		Rarity      = "Legendary",
		MaxStacks   = 1,
		Weight      = 3,
		Effects     = { AbsoluteZeroCrystal = true },
	},

	AbsoluteZero_IceBurst = {
		Id          = "AbsoluteZero_IceBurst",
		DisplayName = "Explosão Glacial",
		Description = "Ao encerrar o congelamento, detonação de gelo causa 40 de dano adicional",
		Core        = "Ice",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 7,
		Effects     = { AbsoluteZeroIceBurst = true },
	},

	-- ══════════════════════════════════════════════════
	-- DEFENSE
	-- ══════════════════════════════════════════════════

	-- ── IronSkin ──────────────────────────────────────

	IronSkin_Duration = {
		Id          = "IronSkin_Duration",
		DisplayName = "Pele Reforçada",
		Description = "+1s de duração do Iron Skin",
		Core        = "Defense",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 38,
		Modifiers   = { IronSkinDuration = 1 },
	},

	IronSkin_Cd = {
		Id          = "IronSkin_Cd",
		DisplayName = "Armadura Rápida",
		Description = "-12% cooldown do Iron Skin",
		Core        = "Defense",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 20,
		Modifiers   = { IronSkinCd = -0.12 },
	},

	IronSkin_Reduction = {
		Id          = "IronSkin_Reduction",
		DisplayName = "Blindagem Extra",
		Description = "+10% redução de dano do Iron Skin",
		Core        = "Defense",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 24,
		Modifiers   = { IronSkinReduction = 0.10 },
	},

	IronSkin_Reflect = {
		Id          = "IronSkin_Reflect",
		DisplayName = "Armadura Reflexiva",
		Description = "Iron Skin reflete 25% do dano recebido ao atacante",
		Core        = "Defense",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 9,
		Effects     = { IronSkinReflect = true },
	},

	IronSkin_Thorns = {
		Id          = "IronSkin_Thorns",
		DisplayName = "Espinhos de Aço",
		Description = "Iron Skin causa 8 de dano a cada atacante corpo-a-corpo",
		Core        = "Defense",
		Rarity      = "Rare",
		MaxStacks   = 1,
		Weight      = 16,
		Effects     = { IronSkinThorns = true },
	},

	IronSkin_Speed = {
		Id          = "IronSkin_Speed",
		DisplayName = "Agilidade Blindada",
		Description = "+30% velocidade de movimento durante o Iron Skin",
		Core        = "Defense",
		Rarity      = "Rare",
		MaxStacks   = 1,
		Weight      = 18,
		Effects     = { IronSkinSpeed = true },
	},

	IronSkin_Heal = {
		Id          = "IronSkin_Heal",
		DisplayName = "Regeneração Pós-Batalha",
		Description = "Iron Skin restaura 30 de vida ao encerrar",
		Core        = "Defense",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 10,
		Effects     = { IronSkinHeal = true },
	},

	IronSkin_Immunity = {
		Id          = "IronSkin_Immunity",
		DisplayName = "Imunidade Total",
		Description = "Iron Skin torna imune a slow e stun durante a ativação",
		Core        = "Defense",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 8,
		Effects     = { IronSkinImmunity = true },
	},

	IronSkin_Counter = {
		Id          = "IronSkin_Counter",
		DisplayName = "Fúria Defensiva",
		Description = "+40% de dano por 4s após o Iron Skin encerrar",
		Core        = "Defense",
		Rarity      = "Legendary",
		MaxStacks   = 1,
		Weight      = 3,
		Effects     = { IronSkinCounter = true },
	},

	IronSkin_AoE = {
		Id          = "IronSkin_AoE",
		DisplayName = "Ativação Explosiva",
		Description = "Iron Skin causa 25 de dano em área ao ser ativado",
		Core        = "Defense",
		Rarity      = "Rare",
		MaxStacks   = 1,
		Weight      = 15,
		Effects     = { IronSkinAoE = true },
	},

	-- ── EnergyShield ──────────────────────────────────

	EnergyShield_Amount = {
		Id          = "EnergyShield_Amount",
		DisplayName = "Escudo Reforçado",
		Description = "+60 de pontos de escudo do Energy Shield",
		Core        = "Defense",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 38,
		Modifiers   = { EnergyShieldAmount = 60 },
	},

	EnergyShield_Cd = {
		Id          = "EnergyShield_Cd",
		DisplayName = "Recarga do Escudo",
		Description = "-10% cooldown do Energy Shield",
		Core        = "Defense",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 20,
		Modifiers   = { EnergyShieldCd = -0.10 },
	},

	EnergyShield_Duration = {
		Id          = "EnergyShield_Duration",
		DisplayName = "Escudo Duradouro",
		Description = "+1s de duração do Energy Shield",
		Core        = "Defense",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 35,
		Modifiers   = { EnergyShieldDuration = 1 },
	},

	EnergyShield_Reflect = {
		Id          = "EnergyShield_Reflect",
		DisplayName = "Escudo de Represália",
		Description = "Energy Shield reflete 30% do dano absorvido ao atacante",
		Core        = "Defense",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 9,
		Effects     = { EnergyShieldReflect = true },
	},

	EnergyShield_Regen = {
		Id          = "EnergyShield_Regen",
		DisplayName = "Escudo Regenerativo",
		Description = "Energy Shield regenera 15 pontos de escudo por segundo",
		Core        = "Defense",
		Rarity      = "Rare",
		MaxStacks   = 1,
		Weight      = 18,
		Effects     = { EnergyShieldRegen = true },
	},

	EnergyShield_Explosion = {
		Id          = "EnergyShield_Explosion",
		DisplayName = "Colapso do Escudo",
		Description = "Energy Shield explode ao ser destruído, causando dano em área",
		Core        = "Defense",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 8,
		Effects     = { EnergyShieldExplosion = true },
	},

	EnergyShield_Speed = {
		Id          = "EnergyShield_Speed",
		DisplayName = "Mobilidade Protegida",
		Description = "+25% velocidade de movimento enquanto o escudo estiver ativo",
		Core        = "Defense",
		Rarity      = "Rare",
		MaxStacks   = 1,
		Weight      = 16,
		Effects     = { EnergyShieldSpeed = true },
	},

	EnergyShield_Aura = {
		Id          = "EnergyShield_Aura",
		DisplayName = "Aura Elétrica",
		Description = "Energy Shield causa 5 de dano/s a inimigos próximos enquanto ativo",
		Core        = "Defense",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 7,
		Effects     = { EnergyShieldAura = true },
	},

	EnergyShield_Double = {
		Id          = "EnergyShield_Double",
		DisplayName = "Dupla Carga",
		Description = "Energy Shield ativa com 2 cargas independentes",
		Core        = "Defense",
		Rarity      = "Legendary",
		MaxStacks   = 1,
		Weight      = 3,
		Modifiers   = { EnergyShieldCharges = 1 },
	},

	EnergyShield_Thorns = {
		Id          = "EnergyShield_Thorns",
		DisplayName = "Escudo de Espinhos",
		Description = "Cada 20 de dano absorvido causa 10 de dano de volta ao atacante",
		Core        = "Defense",
		Rarity      = "Rare",
		MaxStacks   = 1,
		Weight      = 14,
		Effects     = { EnergyShieldThorns = true },
	},

	-- ── Immortal ──────────────────────────────────────

	Immortal_Duration = {
		Id          = "Immortal_Duration",
		DisplayName = "Invencibilidade Estendida",
		Description = "+1s de duração do Immortal",
		Core        = "Defense",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 22,
		Modifiers   = { ImmortalDuration = 1 },
	},

	Immortal_Cd = {
		Id          = "Immortal_Cd",
		DisplayName = "Ciclo Divino",
		Description = "-10% cooldown do Immortal",
		Core        = "Defense",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 18,
		Modifiers   = { ImmortalCd = -0.10 },
	},

	Immortal_Heal = {
		Id          = "Immortal_Heal",
		DisplayName = "Ressurreição Parcial",
		Description = "Immortal restaura 60 de vida ao encerrar",
		Core        = "Defense",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 10,
		Effects     = { ImmortalHeal = true },
	},

	Immortal_AoE = {
		Id          = "Immortal_AoE",
		DisplayName = "Aura Imortal",
		Description = "Durante o Immortal, pulsa 15 de dano por segundo em área",
		Core        = "Defense",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 8,
		Effects     = { ImmortalAoE = true },
	},

	Immortal_Speed = {
		Id          = "Immortal_Speed",
		DisplayName = "Velocidade Divina",
		Description = "+50% velocidade de movimento durante o Immortal",
		Core        = "Defense",
		Rarity      = "Rare",
		MaxStacks   = 1,
		Weight      = 18,
		Effects     = { ImmortalSpeed = true },
	},

	Immortal_Counter = {
		Id          = "Immortal_Counter",
		DisplayName = "Contra-Ataque Divino",
		Description = "+60% de dano durante o Immortal",
		Core        = "Defense",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 9,
		Effects     = { ImmortalCounter = true },
	},

	Immortal_Explosion = {
		Id          = "Immortal_Explosion",
		DisplayName = "Explosão Transcendental",
		Description = "Immortal termina com uma explosão enorme causando 80 de dano em área",
		Core        = "Defense",
		Rarity      = "Legendary",
		MaxStacks   = 1,
		Weight      = 3,
		Effects     = { ImmortalExplosion = true },
	},

	Immortal_Absorb = {
		Id          = "Immortal_Absorb",
		DisplayName = "Absorção de Energia",
		Description = "Dano recebido durante o Immortal é convertido em 50% de cura ao encerrar",
		Core        = "Defense",
		Rarity      = "Legendary",
		MaxStacks   = 1,
		Weight      = 4,
		Effects     = { ImmortalAbsorb = true },
	},

	Immortal_Thorns = {
		Id          = "Immortal_Thorns",
		DisplayName = "Escudo de Represália",
		Description = "Enquanto Immortal, cada ataque recebido causa 20 de dano ao atacante",
		Core        = "Defense",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 8,
		Effects     = { ImmortalThorns = true },
	},

	Immortal_Aura = {
		Id          = "Immortal_Aura",
		DisplayName = "Presença Divina",
		Description = "Immortal irradia aura que slow inimigos em 35% ao redor",
		Core        = "Defense",
		Rarity      = "Rare",
		MaxStacks   = 1,
		Weight      = 16,
		Effects     = { ImmortalAura = true },
	},

	-- ══════════════════════════════════════════════════
	-- MOBILITY
	-- ══════════════════════════════════════════════════

	-- ── Dash ──────────────────────────────────────────

	Dash_Distance = {
		Id          = "Dash_Distance",
		DisplayName = "Impulso Turbo",
		Description = "+20% distância do Dash",
		Core        = "Mobility",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 40,
		Modifiers   = { DashDistance = 0.20 },
	},

	Dash_Cd = {
		Id          = "Dash_Cd",
		DisplayName = "Dash Veloz",
		Description = "-15% cooldown do Dash",
		Core        = "Mobility",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 22,
		Modifiers   = { DashCd = -0.15 },
	},

	Dash_Damage = {
		Id          = "Dash_Damage",
		DisplayName = "Dash Cortante",
		Description = "Dash causa 20 de dano em inimigos atravessados",
		Core        = "Mobility",
		Rarity      = "Rare",
		MaxStacks   = 1,
		Weight      = 18,
		Effects     = { DashDamage = true },
	},

	Dash_InvincibleDur = {
		Id          = "Dash_InvincibleDur",
		DisplayName = "Quadros de Invencibilidade",
		Description = "+0.1s de invencibilidade no Dash",
		Core        = "Mobility",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 35,
		Modifiers   = { DashInvDur = 0.1 },
	},

	Dash_SpeedBoost = {
		Id          = "Dash_SpeedBoost",
		DisplayName = "Pós-Aceleração",
		Description = "+40% velocidade por 2s após o Dash",
		Core        = "Mobility",
		Rarity      = "Rare",
		MaxStacks   = 1,
		Weight      = 20,
		Effects     = { DashSpeedBoost = true },
	},

	Dash_Strike = {
		Id          = "Dash_Strike",
		DisplayName = "Golpe Relâmpago",
		Description = "Dash termina com um golpe que causa 35 de dano ao inimigo mais próximo",
		Core        = "Mobility",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 9,
		Effects     = { DashStrike = true },
	},

	Dash_Double = {
		Id          = "Dash_Double",
		DisplayName = "Dash Duplo",
		Description = "Pode usar o Dash duas vezes antes do cooldown",
		Core        = "Mobility",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 8,
		Effects     = { DashDouble = true },
	},

	Dash_Afterimage = {
		Id          = "Dash_Afterimage",
		DisplayName = "Imagem Fantasma",
		Description = "Dash deixa uma imagem que explode causando 20 de dano após 0.5s",
		Core        = "Mobility",
		Rarity      = "Rare",
		MaxStacks   = 1,
		Weight      = 16,
		Effects     = { DashAfterimage = true },
	},

	Dash_Chain = {
		Id          = "Dash_Chain",
		DisplayName = "Encadeamento Tático",
		Description = "Ao chegar no destino, salta automaticamente para o inimigo mais próximo causando 25 de dano",
		Core        = "Mobility",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 8,
		Effects     = { DashChain = true },
	},

	Dash_Phase = {
		Id          = "Dash_Phase",
		DisplayName = "Fase Fantasmal",
		Description = "Dash atravessa paredes e obstáculos",
		Core        = "Mobility",
		Rarity      = "Legendary",
		MaxStacks   = 1,
		Weight      = 4,
		Effects     = { DashPhase = true },
	},

	-- ── DoubleDash ────────────────────────────────────

	DoubleDash_Distance = {
		Id          = "DoubleDash_Distance",
		DisplayName = "Impulso Duplo Estendido",
		Description = "+20% distância por dash do Double Dash",
		Core        = "Mobility",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 38,
		Modifiers   = { DoubleDashDistance = 0.20 },
	},

	DoubleDash_Cd = {
		Id          = "DoubleDash_Cd",
		DisplayName = "Recarga Ágil",
		Description = "-12% cooldown do Double Dash",
		Core        = "Mobility",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 20,
		Modifiers   = { DoubleDashCd = -0.12 },
	},

	DoubleDash_Damage = {
		Id          = "DoubleDash_Damage",
		DisplayName = "Dashes Letais",
		Description = "Cada dash do Double Dash causa 15 de dano em inimigos atravessados",
		Core        = "Mobility",
		Rarity      = "Rare",
		MaxStacks   = 1,
		Weight      = 18,
		Effects     = { DoubleDashDamage = true },
	},

	DoubleDash_Triple = {
		Id          = "DoubleDash_Triple",
		DisplayName = "Triple Dash",
		Description = "Double Dash executa 3 dashes em vez de 2",
		Core        = "Mobility",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 8,
		Effects     = { DoubleDashTriple = true },
	},

	DoubleDash_Invincible = {
		Id          = "DoubleDash_Invincible",
		DisplayName = "Invulnerabilidade Dupla",
		Description = "+0.15s de invencibilidade total no Double Dash",
		Core        = "Mobility",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 35,
		Modifiers   = { DoubleDashInvDur = 0.15 },
	},

	DoubleDash_Strike = {
		Id          = "DoubleDash_Strike",
		DisplayName = "Golpe Final",
		Description = "O último dash do Double Dash causa 50 de dano ao alvo mais próximo",
		Core        = "Mobility",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 9,
		Effects     = { DoubleDashStrike = true },
	},

	DoubleDash_Trail = {
		Id          = "DoubleDash_Trail",
		DisplayName = "Rastro de Energia",
		Description = "Double Dash deixa rastro que causa 10 de dano a inimigos que passam por ele",
		Core        = "Mobility",
		Rarity      = "Rare",
		MaxStacks   = 1,
		Weight      = 15,
		Effects     = { DoubleDashTrail = true },
	},

	DoubleDash_Speed = {
		Id          = "DoubleDash_Speed",
		DisplayName = "Aceleração Total",
		Description = "+50% velocidade por 2s após completar todos os dashes",
		Core        = "Mobility",
		Rarity      = "Rare",
		MaxStacks   = 1,
		Weight      = 18,
		Effects     = { DoubleDashSpeed = true },
	},

	DoubleDash_Chain = {
		Id          = "DoubleDash_Chain",
		DisplayName = "Corrente de Dashes",
		Description = "Se o mesmo inimigo for atingido por ambos os dashes, recebe 2x de dano no segundo",
		Core        = "Mobility",
		Rarity      = "Legendary",
		MaxStacks   = 1,
		Weight      = 3,
		Effects     = { DoubleDashChain = true },
	},

	DoubleDash_Burst = {
		Id          = "DoubleDash_Burst",
		DisplayName = "Explosão de Chegada",
		Description = "Ao finalizar o último dash, detona onda causando 30 de dano em área",
		Core        = "Mobility",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 7,
		Effects     = { DoubleDashBurst = true },
	},

	-- ── PhantomStep ───────────────────────────────────

	PhantomStep_Teleports = {
		Id          = "PhantomStep_Teleports",
		DisplayName = "Passos Extras",
		Description = "+2 teleportes do Phantom Step",
		Core        = "Mobility",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 22,
		Modifiers   = { PhantomStepTeleports = 2 },
	},

	PhantomStep_Cd = {
		Id          = "PhantomStep_Cd",
		DisplayName = "Fantasia Veloz",
		Description = "-10% cooldown do Phantom Step",
		Core        = "Mobility",
		Rarity      = "Rare",
		MaxStacks   = 2,
		Weight      = 18,
		Modifiers   = { PhantomStepCd = -0.10 },
	},

	PhantomStep_InvisDur = {
		Id          = "PhantomStep_InvisDur",
		DisplayName = "Sombra Prolongada",
		Description = "+1s de invisibilidade do Phantom Step",
		Core        = "Mobility",
		Rarity      = "Common",
		MaxStacks   = 3,
		Weight      = 36,
		Modifiers   = { PhantomStepInvisDur = 1 },
	},

	PhantomStep_Damage = {
		Id          = "PhantomStep_Damage",
		DisplayName = "Teleporte Letal",
		Description = "Cada teleporte do Phantom Step causa 12 de dano em área",
		Core        = "Mobility",
		Rarity      = "Rare",
		MaxStacks   = 1,
		Weight      = 18,
		Effects     = { PhantomStepDamage = true },
	},

	PhantomStep_Strike = {
		Id          = "PhantomStep_Strike",
		DisplayName = "Ataque Sombrio",
		Description = "Primeiro ataque após sair da invisibilidade causa 2x de dano",
		Core        = "Mobility",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 9,
		Effects     = { PhantomStepStrike = true },
	},

	PhantomStep_Speed = {
		Id          = "PhantomStep_Speed",
		DisplayName = "Velocidade Fantasma",
		Description = "+60% velocidade durante a invisibilidade do Phantom Step",
		Core        = "Mobility",
		Rarity      = "Rare",
		MaxStacks   = 1,
		Weight      = 20,
		Effects     = { PhantomStepSpeed = true },
	},

	PhantomStep_Clone = {
		Id          = "PhantomStep_Clone",
		DisplayName = "Ilusão Perfeita",
		Description = "Phantom Step cria 2 clones decoys que distraem inimigos por 3s",
		Core        = "Mobility",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 7,
		Effects     = { PhantomStepClone = true },
	},

	PhantomStep_Silence = {
		Id          = "PhantomStep_Silence",
		DisplayName = "Silêncio Sombrio",
		Description = "Cada teleporte silencia inimigos próximos por 1s (sem habilidades)",
		Core        = "Mobility",
		Rarity      = "Epic",
		MaxStacks   = 1,
		Weight      = 8,
		Effects     = { PhantomStepSilence = true },
	},

	PhantomStep_Stack = {
		Id          = "PhantomStep_Stack",
		DisplayName = "Momentum Crescente",
		Description = "Cada teleporte do Phantom Step aumenta o dano do próximo em 20%",
		Core        = "Mobility",
		Rarity      = "Legendary",
		MaxStacks   = 1,
		Weight      = 3,
		Effects     = { PhantomStepStack = true },
	},

	PhantomStep_Backstab = {
		Id          = "PhantomStep_Backstab",
		DisplayName = "Golpe Pelas Costas",
		Description = "Ataques durante a invisibilidade causam 80% mais dano quando pelas costas",
		Core        = "Mobility",
		Rarity      = "Legendary",
		MaxStacks   = 1,
		Weight      = 4,
		Effects     = { PhantomStepBackstab = true },
	},
}
