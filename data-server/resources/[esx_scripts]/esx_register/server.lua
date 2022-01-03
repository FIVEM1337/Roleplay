ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



ESX.RegisterServerCallback('esx_register:getname', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier',  {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		if result[1] then
			result = result[1]
			cb(result)
		else
			cb(nil)
		end
	end)
end)