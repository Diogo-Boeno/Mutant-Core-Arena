-- --[[
-- 	TEMPLATE DE HABILIDADE — Mutant Core Arena
-- 	==========================================
-- 	Copie este arquivo, renomeie para o Id da habilidade e coloque
-- 	na pasta correta: Server/Abilities/<Core>/<Id>.lua

-- 	O AbilityService carrega tudo automaticamente — você não
-- 	precisa registrar a habilidade em nenhum outro lugar.
-- ]]

-- local CombatService = require(game.ServerScriptService.Server.Services.CombatService)
-- -- local Net = require(game.ReplicatedStorage.Shared.Net.Net) -- necessário só se disparar VFX extras

-- return {
-- 	-- IDENTIDADE (obrigatório)
-- 	Id       = "NomeDaHabilidade",   -- deve ser igual ao nome do arquivo
-- 	Core     = "Gravity",            -- Gravity | Fire | Electric | Ice | Defense | Mobility
-- 	Tier     = "Base",               -- Base | Advanced | Ultimate
-- 	Cooldown = 5,                    -- segundos

-- 	-- VFX (obrigatório — AbilityService dispara automaticamente)
-- 	VFX = {
-- 		AbilityId   = "NomeDaHabilidade", -- nome da pasta em ReplicatedStorage.Assets.VFX
-- 		Type        = "ExpandingArea",    -- ExpandingArea | Projectile | SelfBuff
-- 		Scale       = 1.0,
-- 		Duration    = 1.0,
-- 		Sound       = "NomeDoSom",
-- 		CameraShake = 0.3,
-- 	},

-- 	-- HUD / UI (opcional mas recomendado)
-- 	Display = {
-- 		Name        = "Nome Visível",
-- 		Description = "Descrição curta da habilidade.",
-- 		-- Icon = "rbxassetid://...",
-- 	},

-- 	--[[
-- 		EXECUTE — lógica do servidor
-- 		============================
-- 		Parâmetros:
-- 		  player  — o Player que usou a habilidade
-- 		  state   — estado do player (state.Modifiers, state.Effects, state.ShieldHP, etc)
-- 		  origin  — Vector3 da posição do HumanoidRootPart no momento do uso

-- 		Modificadores disponíveis em state.Modifiers:
-- 		  AreaRadius                     — multiplicador de raio (ex: 0.25 = +25%)
-- 		  GlobalCooldown                 — multiplicador de cooldown (aplicado pelo AbilityService)
-- 		  DamageReduction                — redução de dano recebido
-- 		  GravityPulseDamageMultiplier   — exemplo de modificador específico
-- 		  (adicione os seus conforme criar mutações)

-- 		Efeitos especiais em state.Effects:
-- 		  DoublePulse    — ativa segundo pulso no GravityPulse
-- 		  KillExplosion  — explosão ao matar (ainda não implementado aqui)
-- 		  (adicione os seus conforme criar mutações)
-- 	]]
-- 	Execute = function(player, state, origin)
-- 		-- Exemplo: dano em área com modificador de raio
-- 		local radius     = 10 * (1 + (state.Modifiers.AreaRadius or 0))
-- 		local damage     = 30
-- 		local maxTargets = 20

-- 		local enemies = CombatService:GetEnemiesInRadius(origin, radius, maxTargets)
-- 		for _, enemy in ipairs(enemies) do
-- 			CombatService:ApplyDamage(player, enemy, damage, "Gravity")
-- 		end

-- 		-- Exemplo: efeito condicional por mutação
-- 		-- if state.Effects.MeuEfeito then
-- 		-- 	-- faz algo extra
-- 		-- end
-- 	end,
-- }
