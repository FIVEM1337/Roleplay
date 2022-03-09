ESX                             = nil
local Playertasks               = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function Start(source)
    zone = Playertasks[source].zone
    local xPlayer = ESX.GetPlayerFromId(source)

    if not zone then return end

	SetTimeout(zone.time * 1000, function()
	    local xPlayer = ESX.GetPlayerFromId(source)

        if Playertasks[source].zone then

            if not rawequal(next(zone.need), nil) then
                hasInventoryItem = hasItem(source)
                if not hasInventoryItem then return end
            end

           if not rawequal(next(zone.item), nil) then
                hasInventorySpace = hasSpace(source)
                if not hasInventorySpace then return end
            end

             if not rawequal(next(zone.need), nil) then
                if xPlayer.getInventoryItem(zone.need.item).count >= zone.need.count then
                    if zone.item.item == "money" or zone.item.item == "black_money"  then
                        if zone.need.removeItem then
                            xPlayer.removeInventoryItem(zone.need.item, zone.need.count)
                        end
                        xPlayer.addAccountMoney(zone.item.item, zone.item.count)
                    else
                        if xPlayer.canCarryItem(zone.item.item, zone.item.count) then
                            xPlayer.removeInventoryItem(zone.need.item, zone.need.count)
                            xPlayer.addInventoryItem(zone.item.item, zone.item.count)
                        end
                    end
                    Start(source) 
                end
            else
                if xPlayer.canCarryItem(zone.item.item, zone.item.count) then
                    xPlayer.addInventoryItem(zone.item.item, zone.item.count)
                    Start(source) 
                end
            end
        end
	end)
end

ESX.RegisterServerCallback('esx_routen:done', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
    if not Playertasks[source] then
        Playertasks[source] = {}
    end

    if Playertasks[source].zone then
	    cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent('esx_routen:startRoute')
AddEventHandler('esx_routen:startRoute', function(zone)
    if not Playertasks[source] then
        Playertasks[source] = {}
    end 

    if not Playertasks[source].zone then
        Playertasks[source].zone = zone

        if not rawequal(next(zone.need), nil) then
            hasInventoryItem = hasItem(source)
            if not hasInventoryItem then return end
        end

       if not rawequal(next(zone.item), nil) then
            hasInventorySpace = hasSpace(source)
            if not hasInventorySpace then return end
        end

        TriggerClientEvent('esx_routen:changestatus', source, true)

        Start(source)
    else
        TriggerClientEvent('esx:showNotification', source, "Die Aktion wurde abgebrochen")
        TriggerClientEvent('esx_routen:changestatus', source, false)
        Playertasks[source] = {}
    end
end)

RegisterServerEvent('esx_routen:stopRoute')
AddEventHandler('esx_routen:stopRoute', function(zone)
    TriggerClientEvent('esx:showNotification', source, "Die Aktion wurde abgebrochen")
    TriggerClientEvent('esx_routen:changestatus', source, false)
    Playertasks[source] = {}
end)

function hasItem(source)
    zone = Playertasks[source].zone
    if not zone then return end

	local xPlayer = ESX.GetPlayerFromId(source)

    if Playertasks[source].zone then
        if xPlayer.getInventoryItem(zone.need.item).count >= zone.need.count then
            return true
        else

            TriggerClientEvent('esx:showNotification', source, "Du benötist "..zone.need.count.."x "..ESX.GetItemLabel(zone.need.item))
            TriggerClientEvent('esx_routen:changestatus', source, false)
            Playertasks[source] = {}
            return false
        end
	end
end

function hasSpace(source)
    zone = Playertasks[source].zone
    if not zone then return end

	local xPlayer = ESX.GetPlayerFromId(source)

    if Playertasks[source].zone then
        if zone.item.item == "money" or zone.item.item == "bank" or zone.item.item == "black_money" or zone.item.item == "crypto"then
            return true
        else
            if xPlayer.canCarryItem(zone.item.item, zone.item.count) then
                return true
            else
                TriggerClientEvent('esx:showNotification', source, "inventory full")
                TriggerClientEvent('esx_routen:changestatus', source, false)
                Playertasks[source] = {}
                return false
            end
        end
	end
end
