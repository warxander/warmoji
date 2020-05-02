local _playerEmojies = { }

local function drawEmoji(player, emoji)
	local ped = GetPlayerPed(GetPlayerFromServerId(player))
	if not DoesEntityExist(ped) then
		return
	end

	local coords = GetEntityCoords(ped)
	local camCoords = GetGameplayCamCoords()
	local distance = Vdist(coords.x, coords.y, coords.z, camCoords.x, camCoords.y, camCoords.z)
	local z =  coords.z + Config.CoordOffset.Z

	if distance > Config.MaxShowDistance or not GetScreenCoordFromWorldCoord(coords.x, coords.y, z) then
		return
	end

	local scale = Config.Scale.Min + (Config.Scale.Max - Config.Scale.Min) * (1.0 - (distance / Config.MaxShowDistance))

	SetDrawOrigin(coords.x + Config.CoordOffset.X, coords.y + Config.CoordOffset.Y, z)
	SetTextFont(0)
	SetTextColour(255, 255, 255, 255)
	SetTextScale(scale, scale)
	SetTextCentre(true)
	BeginTextCommandDisplayText('STRING')
	AddTextComponentString(emoji)
	EndTextCommandDisplayText(0, 0)
	ClearDrawOrigin()
end

RegisterNetEvent('waremoji:addEmoji')
AddEventHandler('waremoji:addEmoji', function(player, emoji)
	_playerEmojies[player] = emoji
end)

RegisterNetEvent('waremoji:removeEmoji')
AddEventHandler('waremoji:removeEmoji', function(player)
	_playerEmojies[player] = nil
end)

Citizen.CreateThread(function()
	local playerServerId = GetPlayerServerId(PlayerId())

	while true do
		Citizen.Wait(0)

		for player, emoji in pairs(_playerEmojies) do
			if player ~= playerServerId or Config.ShowAboveAuthor then
				drawEmoji(player, emoji)
			end
		end
	end
end)
