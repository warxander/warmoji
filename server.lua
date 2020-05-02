local _playerEmojies = { }

local _emojiMaxLength = 4

local function addEmoji(player, emoji)
	_playerEmojies[player] = GetGameTimer()
	TriggerClientEvent('waremoji:addEmoji', -1, player, emoji)
end

local function removeEmoji(player)
	_playerEmojies[player] = nil
	TriggerClientEvent('waremoji:removeEmoji', -1, player)
end

local function isMessageAnEmoji(message)
	if not message or string.len(message) > _emojiMaxLength then
		return false
	end

	for _, emoji in ipairs(Config.Emojies) do
		if message == emoji then
			return true
		end
	end

	return false
end

function showEmoji(player, emoji)
	if isMessageAnEmoji(emoji) then
		addEmoji(player, emoji)
	end
end

function removeEmoji(player)
	if _playerEmojies[player] then
		_playerEmojies[player] = nil
		TriggerClientEvent('waremoji:removeEmoji', -1, player)
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)

		local gameTime = GetGameTimer()
		for player, emojiStartTime in pairs(_playerEmojies) do
			if gameTime - emojiStartTime > Config.ShowDuration then
				removeEmoji(player)
			end
		end
	end
end)

RegisterNetEvent('_chat:messageEntered')
AddEventHandler('_chat:messageEntered', function(_, _, message)
	showEmoji(source, message)
end)

AddEventHandler('playerDropped', function()
	removeEmoji(source)
end)
