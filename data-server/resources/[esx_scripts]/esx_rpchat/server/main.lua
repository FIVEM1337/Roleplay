local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function getIdentity(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height']
		}
	else
		return nil
	end
end

AddEventHandler('chatMessage', function(source, name, message)
	if string.sub(message, 1, string.len("/")) ~= "/" then
		local name = getIdentity(source)
		TriggerClientEvent("sendProximityMessageMe", -1, source, name.firstname, message)
	end
	CancelEvent()
end)

RegisterCommand('ooc', function(source, args, rawCommand)
	local playerName = GetPlayerName(source)
	local msg = rawCommand:sub(5)
	local name = getIdentity(source)

	TriggerClientEvent('chat:addMessage', -1, {
		template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(41, 41, 41, 0.6); border-radius: 3px;"><i class="fas fa-globe"></i> {0}:<br> {1}</div>',
		args = { playerName, msg }
	})
end, false)

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end
