ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_resident:getResidentStatus', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchScalar('SELECT is_resident FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(isResident)
		cb(isResident)
	end)
end)

ESX.RegisterCommand('einreisen', Config.CommandGroups, function(xPlayer, args, showError)
	MySQL.Async.fetchScalar('SELECT is_resident FROM users WHERE identifier = @identifier', {
		['@identifier'] = args.SpielerID.identifier
	}, function(isResident)
		if not isResident then
			args.SpielerID.triggerEvent('dopeNotify:Alert', "", "Du bist jetzt Staatsburger", 5000, 'info')
			MySQL.Sync.execute('UPDATE users SET is_resident = @is_resident WHERE identifier = @identifier', {
				['@identifier'] = args.SpielerID.identifier,
				['@is_resident'] = 1
			})
		else
			xPlayer.triggerEvent('dopeNotify:Alert',"", "Der Spieler ist bereits Staatsburger", 5000, 'error')
		end
	end)
end, true, {help = "Spieler einreisen", validate = true, arguments = {
	{name = 'SpielerID', help = "Spiler ID", type = 'player'}
}})