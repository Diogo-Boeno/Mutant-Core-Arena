local Net = require(game.ReplicatedStorage.Shared.Net.Net)

local Visual = {}

function Visual:Execute(player, state, comp, origin)
	if not comp.VFX then return end

	Net:FireAllClients("ClientVFX", {
		Type = comp.VFX,
		UserId = player.UserId,
		Origin = origin,
		CameraShake = comp.CameraShake,
		Sound = comp.Sound,
		-- Outros dados relevantes (ex: Radius)
	})
end

return Visual