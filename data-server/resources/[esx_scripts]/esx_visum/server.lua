local ESX = nil
-- ESX
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Open Visum card
RegisterServerEvent('esx_visum:open')
AddEventHandler('esx_visum:open', function(ID, targetID)
	local identifier = ESX.GetPlayerFromId(ID).identifier
	local _source 	 = ESX.GetPlayerFromId(targetID).source

	MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, height, state, visum FROM users WHERE identifier = @identifier', {['@identifier'] = identifier},
	function (user)
		if (user[1] ~= nil) then
			if (string.len(user[1].visum) >= 1) then
				local array = {
					user = user
				}

				TriggerClientEvent('esx_visum:open', _source, array)
			else
				TriggerClientEvent('esx:showNotification', _source, "Du hast keinen Visum..")
			end
		end
	end)
end)
