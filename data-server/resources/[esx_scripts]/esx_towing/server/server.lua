ESX = nil
local ropes = {}



if Config.useEsx then
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    ESX.RegisterUsableItem(Config.towRopeItem, function(source)
        TriggerClientEvent('esx_towing:openTowingMenu', source)
    end)
end


ESX.RegisterServerCallback('esx_towing:removeItem', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
    local gotItem = xPlayer.getInventoryItem(item).count >= 1
	if gotItem then
		xPlayer.removeInventoryItem(item, 1)
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent("esx_towing:tow")
AddEventHandler("esx_towing:tow", function(veh1, veh2)
    local allPlayers = GetPlayers()
    for k, player in pairs(allPlayers) do
        TriggerClientEvent('esx_towing:makeRope', player, veh1, veh2, source)
    end
    table.insert(ropes, {veh1, veh2, source})
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.ropeSyncDuration * 1000)
        refreshRopes()
    end
end)

function refreshRopes()
    local allPlayers = GetPlayers()
    if #ropes > 0 then
        for k, rope in pairs(ropes) do
            for i, player in pairs(allPlayers) do
                TriggerClientEvent('esx_towing:makeRope', player, rope[1], rope[2], rope[3], rope[3] == player)
            end
        end
    end
end

RegisterServerEvent("esx_towing:stopTow")
AddEventHandler("esx_towing:stopTow", function()
    local allPlayers = GetPlayers()

    for k, rope in pairs(ropes) do
        if rope[3] == source then
            for i, player in pairs(allPlayers) do
                TriggerClientEvent('esx_towing:removeRope', player, source, rope[1], rope[2])
                ropes[k] = nil
            end
        end
    end
end)