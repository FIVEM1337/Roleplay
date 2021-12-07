ESX = nil

TriggerEvent("esx:getSharedObject", function(library) 
	ESX = library 
end)

ESX.RegisterUsableItem(Config.FishingItems["rod"]["name"], function(source)
	TriggerClientEvent("esx_fishing:StartFish", source)
end)

ESX.RegisterServerCallback("esx_fishing:receiveItem", function(source, callback, rewardtype)
	local player = ESX.GetPlayerFromId(source)
	
	if not player then 
		return callback(false) 
	end

	player.addInventoryItem(rewardtype, 1)
	callback(true)
end)

ESX.RegisterServerCallback("esx_fishing:getItems", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local item = xPlayer.getInventoryItem(Config.FishingItems["bait"]["name"])
	if item == nil then 
		cb(false) 
	elseif item.count > 0 then 
		xPlayer.removeInventoryItem(Config.FishingItems["bait"]["name"], 1)
		cb(true)
	else 
		cb(false)
	end
end)

RegisterServerEvent('esx_fishing:BackFish')
AddEventHandler('esx_fishing:BackFish', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem('fishbait', 1)	
end)