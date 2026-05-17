local Workspace = game:GetService("Workspace")
local Players   = game:GetService("Players")
local Debris    = game:GetService("Debris")

local HitboxService = {}

-- Desative em produção
HitboxService.Debug = true

-- ─────────────────────────────────────────────────────────────────────────────
-- Debug — cores por tipo de hitbox
-- ─────────────────────────────────────────────────────────────────────────────

local DC = {
	Sphere     = Color3.fromRGB(0,   170, 255),  -- ciano
	SphereTick = Color3.fromRGB(170, 0,   255),  -- roxo
	Projectile = Color3.fromRGB(255, 140, 0  ),  -- laranja
	Cone       = Color3.fromRGB(255, 230, 0  ),  -- amarelo
	Chain      = Color3.fromRGB(0,   255, 100),  -- verde
	Ray        = Color3.fromRGB(255, 50,  50 ),  -- vermelho
	Box        = Color3.fromRGB(220, 220, 220),  -- branco
}

local function debugFolder()
	local f = Workspace:FindFirstChild("HitboxDebug")
	if not f then
		f = Instance.new("Folder")
		f.Name = "HitboxDebug"
		f.Parent = Workspace
	end
	return f
end

local function dbSphere(origin, radius, color, duration, transparency)
	if not HitboxService.Debug then return end
	local p = Instance.new("Part")
	p.Anchored      = true
	p.CanCollide    = false
	p.CastShadow    = false
	p.Shape         = Enum.PartType.Ball
	p.Size          = Vector3.new(radius * 2, radius * 2, radius * 2)
	p.CFrame        = CFrame.new(origin)
	p.Color         = color
	p.Transparency  = transparency or 0.72
	p.Material      = Enum.Material.Neon
	p.Parent        = debugFolder()
	Debris:AddItem(p, duration)
	return p
end

local function dbLine(from, to, color, duration)
	if not HitboxService.Debug then return end
	local len = (to - from).Magnitude
	if len < 0.05 then return end
	local mid = (from + to) / 2
	local cf  = CFrame.new(mid, to) * CFrame.Angles(math.pi / 2, 0, 0)
	local p = Instance.new("Part")
	p.Anchored     = true
	p.CanCollide   = false
	p.CastShadow   = false
	p.Size         = Vector3.new(0.12, len, 0.12)
	p.CFrame       = cf
	p.Color        = color
	p.Transparency = 0.35
	p.Material     = Enum.Material.Neon
	p.Parent       = debugFolder()
	Debris:AddItem(p, duration)
end

local function dbBox(cframe, size, color, duration)
	if not HitboxService.Debug then return end
	local p = Instance.new("Part")
	p.Anchored     = true
	p.CanCollide   = false
	p.CastShadow   = false
	p.Size         = size
	p.CFrame       = cframe
	p.Color        = color
	p.Transparency = 0.72
	p.Material     = Enum.Material.Neon
	p.Parent       = debugFolder()
	Debris:AddItem(p, duration)
end

-- Desenha o cone como linhas saindo do origin: 1 eixo central + 6 bordas.
local function dbCone(origin, direction, range, halfAngleDeg, color, duration)
	if not HitboxService.Debug then return end
	local halfRad = math.rad(halfAngleDeg)
	local dir     = direction.Unit

	local arb   = math.abs(dir:Dot(Vector3.yAxis)) < 0.9 and Vector3.yAxis or Vector3.xAxis
	local right = dir:Cross(arb).Unit
	local up    = dir:Cross(right).Unit

	dbLine(origin, origin + dir * range, color, duration)

	for i = 0, 5 do
		local theta   = (i / 6) * math.pi * 2
		local edgeDir = dir * math.cos(halfRad) + (right * math.cos(theta) + up * math.sin(theta)) * math.sin(halfRad)
		dbLine(origin, origin + edgeDir * range, color, duration)
	end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Helpers internos de detecção (sem debug — usados internamente)
-- ─────────────────────────────────────────────────────────────────────────────

local function getEnemiesFolder()
	return Workspace:FindFirstChild("Enemies")
end

local function getRoot(model)
	return model:FindFirstChild("HumanoidRootPart")
end

local function isAlive(model)
	local h = model:FindFirstChildOfClass("Humanoid")
	return h ~= nil and h.Health > 0
end

-- Detecção pura sem debug (chamada internamente por SphereTick, Projectile, Chain).
local function detectSphere(origin, radius, maxTargets)
	maxTargets = maxTargets or math.huge
	local folder = getEnemiesFolder()
	if not folder then return {} end

	local results = {}
	for _, enemy in ipairs(folder:GetChildren()) do
		if #results >= maxTargets then break end
		local root = getRoot(enemy)
		if root and isAlive(enemy) then
			if (root.Position - origin).Magnitude <= radius then
				table.insert(results, enemy)
			end
		end
	end
	return results
end

local function buildWallParams()
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	local exclude = {}
	local folder  = getEnemiesFolder()
	if folder then table.insert(exclude, folder) end
	for _, player in ipairs(Players:GetPlayers()) do
		if player.Character then
			table.insert(exclude, player.Character)
		end
	end
	params.FilterDescendantsInstances = exclude
	return params
end

-- ─────────────────────────────────────────────────────────────────────────────
-- SPHERE — esfera instantânea ao redor de um ponto
--
-- Uso:
--   local enemies = HitboxService:Sphere(origin, 12, 15)
--
-- Debug: esfera ciana por 0.35s
-- ─────────────────────────────────────────────────────────────────────────────
function HitboxService:Sphere(origin, radius, maxTargets)
	dbSphere(origin, radius, DC.Sphere, 0.35)
	return detectSphere(origin, radius, maxTargets)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- SPHERE TICK — esfera persistente que pulsa a cada intervalo
--
-- Uso:
--   HitboxService:SphereTick(origin, 25, 6, 0.5, 50, function(enemies)
--       for _, e in ipairs(enemies) do CombatService:ApplyDamage(...) end
--   end)
--
-- Debug: esfera roxa persistente pela duração total; pisca a cada tick
-- ─────────────────────────────────────────────────────────────────────────────
function HitboxService:SphereTick(origin, radius, duration, interval, maxTargets, onHit)
	dbSphere(origin, radius, DC.SphereTick, duration, 0.88) -- outline persistente

	task.spawn(function()
		local elapsed = 0
		while elapsed < duration do
			local enemies = detectSphere(origin, radius, maxTargets)
			if #enemies > 0 then
				onHit(enemies)
			end
			dbSphere(origin, radius, DC.SphereTick, math.min(interval * 0.7, 0.35), 0.60) -- flash por tick
			task.wait(interval)
			elapsed += interval
		end
	end)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- PROJECTILE — projétil com física, detecta parede e inimigos passo a passo
--
-- Uso:
--   HitboxService:Projectile(origin, root.CFrame.LookVector, 80, 200, 4, 8, function(enemies, hitPos)
--       for _, e in ipairs(enemies) do CombatService:ApplyDamage(...) end
--   end)
--
-- onHit(enemies, hitPos):
--   enemies vazio → bateu em parede ou expirou no alcance máximo
--
-- Debug: esfera laranja que se move junto com o projétil
-- ─────────────────────────────────────────────────────────────────────────────
function HitboxService:Projectile(origin, direction, speed, maxDistance, hitRadius, maxTargets, onHit)
	maxTargets = maxTargets or 5
	local STEP = 0.05

	task.spawn(function()
		local dir        = direction.Unit
		local stepDist   = speed * STEP
		local traveled   = 0
		local pos        = origin
		local wallParams = buildWallParams()

		-- Esfera que acompanha o projétil
		local dbPart = nil
		if HitboxService.Debug then
			dbPart = Instance.new("Part")
			dbPart.Anchored     = true
			dbPart.CanCollide   = false
			dbPart.CastShadow   = false
			dbPart.Shape        = Enum.PartType.Ball
			dbPart.Size         = Vector3.new(hitRadius * 2, hitRadius * 2, hitRadius * 2)
			dbPart.CFrame       = CFrame.new(origin)
			dbPart.Color        = DC.Projectile
			dbPart.Transparency = 0.50
			dbPart.Material     = Enum.Material.Neon
			dbPart.Parent       = debugFolder()
		end

		local function cleanup(delay)
			if dbPart then
				Debris:AddItem(dbPart, delay or 0.15)
			end
		end

		while traveled < maxDistance do
			local nextPos = pos + dir * stepDist

			local wallHit = Workspace:Raycast(pos, dir * stepDist, wallParams)
			if wallHit then
				cleanup(0.2)
				onHit({}, wallHit.Position)
				return
			end

			local enemies = detectSphere(nextPos, hitRadius, maxTargets)
			if #enemies > 0 then
				cleanup(0.2)
				onHit(enemies, nextPos)
				return
			end

			if dbPart then dbPart.CFrame = CFrame.new(nextPos) end
			pos      = nextPos
			traveled += stepDist
			task.wait(STEP)
		end

		cleanup(0.1)
		onHit({}, pos)
	end)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- CONE — arco frontal a partir de uma direção
--
-- halfAngleDeg: metade do ângulo total (30 → cone de 60°)
--
-- Uso:
--   local enemies = HitboxService:Cone(origin, root.CFrame.LookVector, 18, 45, 10)
--
-- Debug: linhas amarelas mostrando eixo central e 6 bordas do cone
-- ─────────────────────────────────────────────────────────────────────────────
function HitboxService:Cone(origin, direction, range, halfAngleDeg, maxTargets)
	maxTargets = maxTargets or math.huge
	local halfRad = math.rad(halfAngleDeg)
	local dir     = direction.Unit
	local folder  = getEnemiesFolder()
	if not folder then return {} end

	dbCone(origin, direction, range, halfAngleDeg, DC.Cone, 0.35)

	local results = {}
	for _, enemy in ipairs(folder:GetChildren()) do
		if #results >= maxTargets then break end
		local root = getRoot(enemy)
		if root and isAlive(enemy) then
			local toEnemy = root.Position - origin
			local dist    = toEnemy.Magnitude
			if dist <= range then
				local angle = math.acos(math.clamp(dir:Dot(toEnemy.Unit), -1, 1))
				if angle <= halfRad then
					table.insert(results, enemy)
				end
			end
		end
	end
	return results
end

-- ─────────────────────────────────────────────────────────────────────────────
-- CHAIN — acerta o mais próximo e salta entre alvos adjacentes
--
-- firstRadius: raio de detecção inicial a partir de origin
-- chainRadius: distância máxima de cada salto seguinte
--
-- Uso:
--   local enemies = HitboxService:Chain(origin, 10, 8, 5, 30)
--
-- Debug: linhas verdes ligando cada alvo encadeado + marcador em cada um
-- ─────────────────────────────────────────────────────────────────────────────
function HitboxService:Chain(origin, firstRadius, chainRadius, maxChains, maxTargets)
	maxChains  = maxChains  or 5
	maxTargets = maxTargets or 30

	local candidates = detectSphere(origin, firstRadius, maxTargets)
	if #candidates == 0 then
		dbSphere(origin, firstRadius, DC.Chain, 0.35, 0.80) -- mostra que não acertou nada
		return {}
	end

	table.sort(candidates, function(a, b)
		local ra, rb = getRoot(a), getRoot(b)
		if not ra or not rb then return false end
		return (ra.Position - origin).Magnitude < (rb.Position - origin).Magnitude
	end)

	local chained = { candidates[1] }
	local hit     = { [candidates[1]] = true }

	for _ = 2, maxChains do
		local last     = chained[#chained]
		local lastRoot = getRoot(last)
		if not lastRoot then break end

		local best, bestDist = nil, math.huge
		for _, enemy in ipairs(candidates) do
			if not hit[enemy] then
				local root = getRoot(enemy)
				if root then
					local dist = (root.Position - lastRoot.Position).Magnitude
					if dist <= chainRadius and dist < bestDist then
						bestDist = dist
						best     = enemy
					end
				end
			end
		end

		if not best then break end
		table.insert(chained, best)
		hit[best] = true
	end

	-- Debug: linhas ligando o trajeto do chain
	if HitboxService.Debug then
		local prevPos = origin
		for _, enemy in ipairs(chained) do
			local root = getRoot(enemy)
			if root then
				dbLine(prevPos, root.Position, DC.Chain, 0.50)
				dbSphere(root.Position, 1.0, DC.Chain, 0.50, 0.40)
				prevPos = root.Position
			end
		end
	end

	return chained
end

-- ─────────────────────────────────────────────────────────────────────────────
-- RAY — raycast de linha reta preciso (paredes + inimigos)
--
-- Uso:
--   local hit = HitboxService:Ray(origin, direction, 150)
--   if hit and hit.Enemy then
--       CombatService:ApplyDamage(player, hit.Enemy, 50, "Electric")
--   end
--
-- Retorna: { Part, Position, Normal, Enemy? } ou nil
-- Debug: linha vermelha até o ponto de impacto + marcador esférico no hit
-- ─────────────────────────────────────────────────────────────────────────────
function HitboxService:Ray(origin, direction, maxDistance)
	maxDistance = maxDistance or 500
	local result = Workspace:Raycast(origin, direction.Unit * maxDistance)

	local endPos = result and result.Position or (origin + direction.Unit * maxDistance)
	dbLine(origin, endPos, DC.Ray, 0.40)

	if not result then return nil end

	local hitEnemy = nil
	local folder   = getEnemiesFolder()
	if folder and result.Instance then
		local model = result.Instance:FindFirstAncestorOfClass("Model")
		if model and model.Parent == folder and isAlive(model) then
			hitEnemy = model
			dbSphere(result.Position, 1.5, DC.Ray, 0.40, 0.40)
		end
	end

	return {
		Part     = result.Instance,
		Position = result.Position,
		Normal   = result.Normal,
		Enemy    = hitEnemy,
	}
end

-- ─────────────────────────────────────────────────────────────────────────────
-- BOX — volume retangular orientado
--
-- cframe: centro e rotação da caixa
-- size:   Vector3 com as dimensões totais (largura, altura, profundidade)
--
-- Uso:
--   local cf = CFrame.new(origin, origin + direction) * CFrame.new(0, 0, -size.Z/2)
--   local enemies = HitboxService:Box(cf, Vector3.new(6, 4, 20), 20)
--
-- Debug: caixa branca translúcida no lugar certo
-- ─────────────────────────────────────────────────────────────────────────────
function HitboxService:Box(cframe, size, maxTargets)
	maxTargets = maxTargets or math.huge
	local half   = size / 2
	local folder = getEnemiesFolder()
	if not folder then return {} end

	dbBox(cframe, size, DC.Box, 0.35)

	local results = {}
	for _, enemy in ipairs(folder:GetChildren()) do
		if #results >= maxTargets then break end
		local root = getRoot(enemy)
		if root and isAlive(enemy) then
			local localPos = cframe:PointToObjectSpace(root.Position)
			if math.abs(localPos.X) <= half.X
				and math.abs(localPos.Y) <= half.Y
				and math.abs(localPos.Z) <= half.Z
			then
				table.insert(results, enemy)
			end
		end
	end
	return results
end

return HitboxService
