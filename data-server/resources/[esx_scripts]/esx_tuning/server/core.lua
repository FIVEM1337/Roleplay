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

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Wait(50)
		local xPlayers = ESX.GetPlayers()

		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            print("jo")
			TriggerClientEvent("esx_tuning:ReloadData", xPlayer.source, xPlayer)
		end
	end
end)