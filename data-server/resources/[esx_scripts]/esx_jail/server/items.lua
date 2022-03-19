ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('jail_shank', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if Config.ShankAllowed then
        if Config.ShankItem then
            TriggerClientEvent('esx_jail:ShankPull', source)
        else
            TriggerClientEvent('esx_jail:GiveShankie', source)
            xPlayer.removeInventoryItem('jail_shank', 1)
        end
    end
end)

ESX.RegisterUsableItem('jail_booze', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if Config.BoozeAllowed then
        if Config.BoozeEffect then
            TriggerClientEvent('esx_jail:TakeBooze', source)
        end
        TriggerClientEvent('esx_status:add', source, 'thirst', Config.BoozeGive)
        TriggerClientEvent('esx_basicneeds:onEat', source, Config.BoozeProp)
        TriggerClientEvent('esx_jail:SendNotif', source, Config.Sayings[163])
        xPlayer.removeInventoryItem('jail_booze', 1)
    else
        TriggerClientEvent('esx_jail:SendNotif', source, Config.Sayings[162])
    end
end)

ESX.RegisterUsableItem('jail_ppunch', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if Config.PunchAllowed then
        TriggerClientEvent('esx_status:add', source, 'thirst', Config.PunchGive)
        TriggerClientEvent('esx_basicneeds:onEat', source, Config.PunchProp)
        TriggerClientEvent('esx_jail:SendNotif', source, Config.Sayings[164])
        xPlayer.removeInventoryItem('jail_booze', 1)
    else
        TriggerClientEvent('esx_jail:SendNotif', source, Config.Sayings[162])
    end
end)
