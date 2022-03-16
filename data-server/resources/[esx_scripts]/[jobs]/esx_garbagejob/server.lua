ESX = nil
TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

RegisterNetEvent('esx_garbagejob:pay')
AddEventHandler('esx_garbagejob:pay', function(jobStatus)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if jobStatus then
        if xPlayer ~= nil then
            local randomMoney = math.random(1500,3500)
            xPlayer.addMoney(randomMoney)
        end
    else
        print("Probably a cheater: ",xPlayer.getName())
    end
end)


RegisterNetEvent('esx_garbagejob:reward')
AddEventHandler('esx_garbagejob:reward', function(item,rewardStatus)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if rewardStatus then
        if xPlayer ~= nil then
            if xPlayer.canCarryItem(item,1) then
                xPlayer.addInventoryItem(item,1)
            end
        end
    else
        print("Probably a cheater: ",xPlayer.getName())
    end
end)