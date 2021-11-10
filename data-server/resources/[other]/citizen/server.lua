ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(source)
	local _source = source
	local xPlayerz = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local steamname = GetPlayerName(_source)
		MySQL.Async.fetchAll('SELECT citizen FROM users WHERE identifier = @identifier', {['@identifier'] = xPlayerz.identifier}, function(result)
			if result[1] then
				if result[1].citizen == "0" then
					for i=1, #xPlayers, 1 do
						local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
						if xPlayer.getGroup() == "mod" or xPlayer.getGroup() == "guide" or xPlayer.getGroup() == "supporter" or xPlayer.getGroup() == "admin" then
							TriggerClientEvent('notifications', xPlayer.source, "#ff0000", "EINREISE","Neuer Spieler in der Einreise: " .. steamname .. " | ID: " .. source)
						end
					end
					TriggerClientEvent("iscitizen", _source, false)
				elseif result[1].citizen == "1" then
					TriggerClientEvent("iscitizen", _source, true)
				end
			end
		end)
end)


AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(3000)
		local xPlayers = ESX.GetPlayers()

		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			MySQL.Async.fetchAll('SELECT citizen FROM users WHERE identifier = @identifier', {['@identifier'] = xPlayer.identifier}, function(result)

				if result[1].citizen == "0" then
					TriggerClientEvent("iscitizen", xPlayer.source, false)
				else
					TriggerClientEvent("iscitizen", xPlayer.source, true)
				end
			end)

		end
	end
end)


RegisterCommand("einreisen", function(source, args)
	local einreiseID = table.concat(args, " ")
	local xPlayer = ESX.GetPlayerFromId(source)
	local newCitizen = ESX.GetPlayerFromId(einreiseID)

	if xPlayer.getGroup() == "mod" or xPlayer.getGroup() == "guide" or xPlayer.getGroup() == "supporter" or xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "superadmin" then

		if newCitizen == nil then
			TriggerClientEvent('notifications', xPlayer.source, "#ff0000", "ERROR", "User ID existiert nicht!")
		else
			MySQL.Async.fetchAll('SELECT citizen FROM users WHERE identifier = @identifier', {['@identifier'] = newCitizen.identifier}, function(result)
				if result[1] then
					if result[1].citizen == "1" then
						TriggerClientEvent('notifications', xPlayer.source, "#ff0000", "ERROR", "User ist bereits Staatsbürger!")
					else
						MySQL.Sync.execute("UPDATE users SET citizen = 1 WHERE identifier = @identifier", {
							['@identifier'] = newCitizen.identifier
						})
			
						TriggerClientEvent('notifications', xPlayer.source, "#ff0000", "ERFOLGREICH", "Du hast eine Person erfolgreich freigeschaltet")
						TriggerClientEvent('notifications', newCitizen.source, "#ff0000", "ERFOLGREICH", "Du bist nun freigeschaltet")
						TriggerClientEvent("citizen:teleport", newCitizen.source, Config.raus, Config.angle_raus)
						TriggerClientEvent("iscitizen", newCitizen.source, true)
					end
				else
					TriggerClientEvent('notifications', xPlayer.source, "#ff0000", "ERROR", "User ist nicht in Datenbank!")
				end
			end)
		end
	else
		TriggerClientEvent('notifications', xPlayer.source, "#ff0000", "ERROR", "Keine Rechte")
	end
end)

RegisterCommand("rein", function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getGroup() == "mod" or xPlayer.getGroup() == "guide" or xPlayer.getGroup() == "supporter" or xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "superadmin" then
		TriggerClientEvent("citizen:teleport", xPlayer.source, Config.rein, Config.angle_rein)
	else
		TriggerClientEvent('notifications', xPlayer.source, "#ff0000", "ERROR", "Keine Rechte")
	end
end)

RegisterCommand("raus", function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getGroup() == "mod" or xPlayer.getGroup() == "guide" or xPlayer.getGroup() == "supporter" or xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "superadmin" then
		TriggerClientEvent("citizen:teleport", xPlayer.source, Config.raus, Config.angle_raus)
	else
		TriggerClientEvent('notifications', xPlayer.source, "#ff0000", "ERROR", "Keine Rechte")
	end
end)