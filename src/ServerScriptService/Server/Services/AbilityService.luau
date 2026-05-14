local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Net = require(ReplicatedStorage.Shared.Net.Net)

local AbilityService = {}

-- Carrega todos os módulos de habilidade automaticamente
-- Estrutura esperada: ServerScriptService.Server.Abilities.<Core>.<AbilityId>
local abilities = {}

local function loadAbilities()
	local abilitiesFolder = ServerScriptService.Server:FindFirstChild("Abilities")
	if not abilitiesFolder then
		warn("[AbilityService] Pasta Abilities não encontrada em Server")
		return
	end

	for _, coreFolder in ipairs(abilitiesFolder:GetChildren()) do
		for _, module in ipairs(coreFolder:GetChildren()) do
			local ok, ability = pcall(require, module)
			if ok and ability and ability.Id then
				abilities[ability.Id] = ability
				-- print("[AbilityService] Carregada:", ability.Id)
			else
				warn("[AbilityService] Falha ao carregar módulo:", module.Name, ability)
			end
		end
	end
end

function AbilityService:Init()
	print("[AbilityService] Init")
	loadAbilities()
end

function AbilityService:Start()
	print("[AbilityService] Start")

	Net:OnServerEvent("AbilityRequest", function(player, abilityId)
		self:ActivateAbility(player, abilityId)
	end)
end

function AbilityService:GetAbility(abilityId)
	return abilities[abilityId]
end

function AbilityService:GetAbilitiesForCore(core)
	local result = {}
	for _, ability in pairs(abilities) do
		if ability.Core == core then
			table.insert(result, ability)
		end
	end
	return result
end

function AbilityService:ActivateAbility(player, abilityId)
	local MatchService = require(script.Parent.MatchService)

	if not MatchService:IsMatchRunning() then return end

	local state = MatchService:GetPlayerState(player)
	if not state or not state.IsAlive then return end

	local abilityState = state.Abilities[abilityId]
	if not abilityState then
		warn("[AbilityService] Habilidade não encontrada no estado do player:", abilityId)
		return
	end

	local ability = abilities[abilityId]
	if not ability then
		warn("[AbilityService] Módulo de habilidade não carregado:", abilityId)
		return
	end

	-- Checa cooldown
	local now = os.clock()
	if now < abilityState.CooldownEndsAt then
		local remaining = abilityState.CooldownEndsAt - now
		Net:FireClient(player, "HUDUpdate", {
			Type      = "AbilityCooldown",
			AbilityId = abilityId,
			Remaining = remaining,
		})
		return
	end

	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	-- Aplica modificador de cooldown
	local cooldown = abilityState.BaseCooldown or 0
	cooldown = cooldown * (1 + (state.Modifiers.GlobalCooldown or 0))
	abilityState.CooldownEndsAt = now + cooldown

	local origin = root.Position

	-- Executa a habilidade
	task.spawn(function()
		ability.Execute(player, state, origin)
	end)

	-- Dispara VFX automaticamente com todos os campos corretos
	if ability.VFX then
		Net:FireAllClients("ClientVFX", {
			AbilityId   = ability.VFX.AbilityId,
			VFXType     = ability.VFX.Type,
			VFXScale    = ability.VFX.Scale,
			VFXDuration = ability.VFX.Duration,
			Sound       = ability.VFX.Sound,
			CameraShake = ability.VFX.CameraShake,
			Origin      = origin,
			UserId      = player.UserId,
		})
	end

	-- Notifica HUD
	Net:FireClient(player, "HUDUpdate", {
		Type      = "AbilityUsed",
		AbilityId = abilityId,
		Cooldown  = cooldown,
	})
end

return AbilityService
