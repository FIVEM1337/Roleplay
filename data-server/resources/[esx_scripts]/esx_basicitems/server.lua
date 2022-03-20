ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('use_kevlar_west', function (source)
    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeInventoryItem('use_kevlar_west', 1)
    TriggerClientEvent('basicitems:kevlar', source)
end)