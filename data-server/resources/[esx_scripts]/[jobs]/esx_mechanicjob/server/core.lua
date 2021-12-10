local ESX = nil

TriggerEvent("esx:getSharedObject", function(library)
    ESX = library
end)

TriggerEvent('esx_society:registerSociety', 'mechanic', 'mechanic', 'society_mechanic', 'society_mechanic', 'society_mechanic', {type = 'private'})


RegisterServerEvent('mechanic:sv:removeCash')
AddEventHandler('mechanic:sv:removeCash', function(amount)
	local src = source

    amount = tonumber(amount)
    if (not amount or amount <= 0) then return end
    
    local esxPlayer = ESX.GetPlayerFromId(src)
    if (esxPlayer) then
        esxPlayer.removeMoney(amount)
    end
end)


ESX.RegisterUsableItem('blowpipe', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('blowpipe', 1)

	TriggerClientEvent('esx_mechanicjob:onHijack', _source)
	TriggerClientEvent('esx:showNotification', _source, _U('you_used_blowtorch'))
end)

ESX.RegisterUsableItem('fixkit', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('fixkit', 1)

	TriggerClientEvent('esx_mechanicjob:onFixkit', _source)
	TriggerClientEvent('esx:showNotification', _source, _U('you_used_repair_kit'))
end)

ESX.RegisterUsableItem('carokit', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('carokit', 1)

	TriggerClientEvent('esx_mechanicjob:onCarokit', _source)
	TriggerClientEvent('esx:showNotification', _source, _U('you_used_body_kit'))
end)

ESX.RegisterServerCallback('esx_mechanicjob:getPlayerInventory', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.inventory

	cb({items = items})
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(50)
		local xPlayers = ESX.GetPlayers()

		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			TriggerClientEvent("reload_esx_mechanicjob", xPlayer.source, xPlayer)
		end
	end
end)