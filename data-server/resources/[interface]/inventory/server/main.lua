ESX = nil
OpenInventories = {}
Inventories = {}
Drops = {}
dropId = 0

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("inventory:getInventory", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local inventory, weight, hotbar = GetPlayerInventory(xPlayer)
    cb(inventory, weight, hotbar)
end)

ESX.RegisterServerCallback("inventory:getOtherInventory", function(source, cb, otherInv)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    if otherInv.type == 'shop' then
        local items = {}

        for k,v in pairs(otherInv.shopItems) do
            if v.type == 'weapon' then
                table.insert(items, {
                    type = 'item_weapon',
                    name = v.name,
                    label = ESX.GetWeaponLabel(v.name),
                    count = v.price,
                    moneytype = v.moneytype
                })
            elseif v.type == 'item' then  
                local info = xPlayer.getInventoryItem(v.name)
                if not info then return end
                table.insert(items, {
                    type = 'item_standard',
                    name = v.name,
                    label = info.label or '',
                    count = v.price,
                    moneytype = v.moneytype
                })
            else 
                local info = xPlayer.getInventoryItem(v.name)
                if not info then return end
                table.insert(items, {
                    type = 'item_standard',
                    name = v.name,
                    label = info.label or '',
                    count = v.price,
                    moneytype = v.moneytype
                })
            end
        end

        cb(items, nil)
        return
    end

    if OpenInventories[otherInv.type] == nil then
        OpenInventories[otherInv.type] = {}
    end

    if OpenInventories[otherInv.type][otherInv.id] == nil then
        OpenInventories[otherInv.type][otherInv.id] = {}
    end

    OpenInventories[otherInv.type][otherInv.id][source] = true

    if otherInv.type == 'player' then
        local target = ESX.GetPlayerFromId(otherInv.id)
        if not target then return end
        
        local inventory, weight = GetPlayerInventory(target)
        cb(inventory, weight)
        return
    end

    local inventory, weight = GetInventory(xPlayer, otherInv)
    cb(inventory, weight)
end)

RegisterNetEvent('inventory:moveItemToPlayer', function(item, count, otherInv)
    local src = source

    local xPlayer = ESX.GetPlayerFromId(src)

    local currency
	for k,v in pairs(xPlayer.accounts) do
		if v.name == item.moneytype then
            currency = v.money
		end
	end
    
    if not xPlayer then return end
    if otherInv.type == 'shop' then
        if item.type == 'item_weapon' then
            if not xPlayer.hasWeapon(item.name) and currency >= item.count then
                xPlayer.removeAccountMoney(item.moneytype, item.count)
                xPlayer.addWeapon(item.name, item.count)
                TriggerClientEvent('dopeNotify:Alert', src, "", ('%s <b>%s</b> gekauft!'):format(count, item.label), 5000, 'success')
                TriggerEvent('CryptoHooker:SendBuyLog', src, item.label, count, count * item.count)
                GiveSocietyMoney(item.moneytype, item.count)
            else 
                TriggerClientEvent('dopeNotify:Alert', src, "", "Du hast diese Waffe bereits!", 5000, 'error')
            end
        elseif item.type == 'item_standard' then
            if Config.PlayerWeight then
                if xPlayer.canCarryItem(item.name, count) then
                    if currency >= (count * item.count) then
                        xPlayer.removeAccountMoney(item.moneytype, count * item.count)
                        xPlayer.addInventoryItem(item.name, count)
                        TriggerClientEvent('dopeNotify:Alert', src, "", ('%s <b>%s</b> gekauft!'):format(count, item.label), 5000, 'success')
                        TriggerEvent('CryptoHooker:SendBuyLog', src, item.label, count, count * item.count)
                        GiveSocietyMoney(item.moneytype, count * item.count)
                    else
                        TriggerClientEvent('dopeNotify:Alert', src, "", "Du kannst dir das nicht leisten!", 5000, 'error')
                    end
                else 
                    TriggerClientEvent('dopeNotify:Alert', src, "", "Inventar voll!", 5000, 'error')
                end
            else 
                local newCount = xPlayer.getInventoryItem(item.name).count + count
                if newCount <= xPlayer.getInventoryItem(item.name).limit then
                    if currency >= (count * item.count) then
                        xPlayer.removeAccountMoney(item.moneytype, count * item.count)
                        xPlayer.addInventoryItem(item.name, count)
                        TriggerClientEvent('dopeNotify:Alert', src, "", ('%s <b>%s</b> gekauft!'):format(count, item.label), 5000, 'success')
                        TriggerEvent('CryptoHooker:SendBuyLog', src, item.label, count, count * item.count)
                        GiveSocietyMoney(item.moneytype, count * item.count)
                    else 
                        TriggerClientEvent('dopeNotify:Alert', src, "", "Du kannst dir das nicht leisten!", 5000, 'error')
                    end
                else 
                    TriggerClientEvent('dopeNotify:Alert', src, "", "Item Limit erreicht", 5000, 'error')
                end
            end
        end
    elseif otherInv.type == 'player' then 
        local target = ESX.GetPlayerFromId(otherInv.id)
        if not target then return end

        for k,v in pairs(Config.BlacklistedItems) do
            if v == item.name then
                return
            end
        end

        if item.type == 'item_account' then
            if item.name == 'cash' then
                if target.getMoney() >= count then
                    target.removeMoney(count)
                    xPlayer.addMoney(count)
                    TriggerClientEvent('dopeNotify:Alert', src, "",('%sx <b>%s</b> erhalten!'):format(count, item.label), 5000, 'success')
                    TriggerEvent('CryptoHooker:SendMoveLog', src, item, count, target.getName(), xPlayer.getName())
                end
            else 
                if target.getAccount(item.name).money >= count then
                    target.removeAccountMoney(item.name, count)
                    xPlayer.addAccountMoney(item.name, count)
                    TriggerClientEvent('dopeNotify:Alert', src, "",('%sx <b>%s</b> erhalten!'):format(count, item.label), 5000, 'success')
                    TriggerEvent('CryptoHooker:SendMoveLog', src, item, count, target.getName(), xPlayer.getName())
                end
            end
        elseif item.type == 'item_weapon' then
            if target.hasWeapon(item.name) then
                if not xPlayer.hasWeapon(item.name) then
                    target.removeWeapon(item.name)
                    xPlayer.addWeapon(item.name, item.count)
                    TriggerClientEvent('dopeNotify:Alert', src, "",('<b>%s</b> moved to <b>%s</b>!'):format(item.label, 'Your Inventory'), 5000, 'success')
                    TriggerEvent('CryptoHooker:SendMoveLog', src, item, count, target.getName(), xPlayer.getName())
                else 
                    TriggerClientEvent('dopeNotify:Alert', src, "", "Du hast die Waffe bereits", 5000, 'error')
                end
            end
        elseif item.type == 'item_standard' then
            if target.getInventoryItem(item.name).count >= count then
                if Config.PlayerWeight then
                    if xPlayer.canCarryItem(item.name, count) then
                        target.removeInventoryItem(item.name, count)
                        xPlayer.addInventoryItem(item.name, count)
                        TriggerClientEvent('dopeNotify:Alert', src, "",('%sx <b>%s</b> erhalten!'):format(count, item.label), 5000, 'success')
                        TriggerEvent('CryptoHooker:SendMoveLog', src, item, count, target.getName(), xPlayer.getName())
                    else 
                        TriggerClientEvent('dopeNotify:Alert', src, "", "Inventar voll", 5000, 'error')
                    end
                else 
                    local newCount = xPlayer.getInventoryItem(item.name).count + count
                    if newCount <= xPlayer.getInventoryItem(item.name).limit then
                        target.removeInventoryItem(item.name, count)
                        xPlayer.addInventoryItem(item.name, count)
                        TriggerClientEvent('dopeNotify:Alert', src, "",('%sx <b>%s</b> erhalten!'):format(count, item.label), 5000, 'success')
                        TriggerEvent('CryptoHooker:SendMoveLog', src, item, count, target.getName(), xPlayer.getName())
                    else 
                        TriggerClientEvent('dopeNotify:Alert', src, "", "Item Limit erreicht", 5000, 'error')
                    end
                end
            end
        end
    else 
        if item.type == 'item_account' then
            if item.name == 'cash' then
                RemoveItemFromInventory(xPlayer, item, count, otherInv, function()
                    xPlayer.addMoney(count)
                    TriggerClientEvent('dopeNotify:Alert', src, "",('%sx <b>%s</b> erhalten!'):format(count, item.label), 5000, 'success')
                    TriggerEvent('CryptoHooker:SendMoveLog', src, item, count, otherInv.title, xPlayer.getName())
                end)
            else 
                RemoveItemFromInventory(xPlayer, item, count, otherInv, function()
                    xPlayer.addAccountMoney(item.name, count)
                    TriggerClientEvent('dopeNotify:Alert', src, "",('%sx <b>%s</b> erhalten!'):format(count, item.label), 5000, 'success')
                    TriggerEvent('CryptoHooker:SendMoveLog', src, item, count, otherInv.title, xPlayer.getName())
                end)
            end
        elseif item.type == 'item_weapon' then
            if not xPlayer.hasWeapon(item.name) then
                RemoveItemFromInventory(xPlayer, item, item.count, otherInv, function()
                    xPlayer.addWeapon(item.name, item.count)
                    TriggerClientEvent('dopeNotify:Alert', src, "",('<b>%s</b> moved to <b>%s</b>!'):format(item.label, 'Your Inventory'), 5000, 'success')
                    TriggerEvent('CryptoHooker:SendMoveLog', src, item, count, otherInv.title, xPlayer.getName())
                end)
            else 
                TriggerClientEvent('dopeNotify:Alert', src, "", "Du hast die Waffe bereits", 5000, 'error')
            end
        elseif item.type == 'item_standard' then
            if Config.PlayerWeight then
                if xPlayer.canCarryItem(item.name, count) then
                    RemoveItemFromInventory(xPlayer, item, count, otherInv, function()
                        xPlayer.addInventoryItem(item.name, count)
                        TriggerClientEvent('dopeNotify:Alert', src, "",('%sx <b>%s</b> erhalten!'):format(count, item.label), 5000, 'success')
                        TriggerEvent('CryptoHooker:SendMoveLog', src, item, count, otherInv.title, xPlayer.getName())
                    end)
                else 
                    TriggerClientEvent('dopeNotify:Alert', src, "", "Inventar voll", 5000, 'error')
                end
            else 
                local newCount = xPlayer.getInventoryItem(item.name).count + count
                if newCount <= xPlayer.getInventoryItem(item.name).limit then
                    RemoveItemFromInventory(xPlayer, item, count, otherInv, function()
                        xPlayer.addInventoryItem(item.name, count)
                        TriggerClientEvent('dopeNotify:Alert', src, "",('%sx <b>%s</b> erhalten!'):format(count, item.label), 5000, 'success')
                        TriggerEvent('CryptoHooker:SendMoveLog', src, item, count, otherInv.title, xPlayer.getName())
                    end)
                else 
                    TriggerClientEvent('dopeNotify:Alert', src, "", "Item Limit erreicht", 5000, 'error')
                end
            end
        end
    end
    
    TriggerClientEvent('inventory:refresh', src)
    Refresh(otherInv.type, otherInv.id)
end)

RegisterNetEvent('inventory:moveItemToOther', function(item, count, otherInv)
    local src = source

    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    if otherInv.type == 'player' then 
        local target = ESX.GetPlayerFromId(otherInv.id)
        if not target then return end

        if item.type == 'item_account' then
            if item.name == 'cash' then
                if xPlayer.getMoney() >= count then
                    xPlayer.removeMoney(count)
                    target.addMoney(count)
                    TriggerClientEvent('dopeNotify:Alert', src, "", ('%sx <b>%s</b> verschoben zu <b>%s</b>!'):format(count, item.label, otherInv.title), 5000, 'success')
                    TriggerEvent('CryptoHooker:SendMoveLog', src, item, count, xPlayer.getName(), target.getName())
                end
            else 
                if xPlayer.getAccount(item.name).money >= count then
                    xPlayer.removeAccountMoney(item.name, count)
                    target.addAccountMoney(item.name, count)
                    TriggerClientEvent('dopeNotify:Alert', src, "", ('%sx <b>%s</b> verschoben zu <b>%s</b>!'):format(count, item.label, otherInv.title), 5000, 'success')
                    TriggerEvent('CryptoHooker:SendMoveLog', src, item, count, xPlayer.getName(), target.getName())
                end
            end
        elseif item.type == 'item_weapon' then
            if xPlayer.hasWeapon(item.name) then
                if not target.hasWeapon(item.name) then
                    xPlayer.removeWeapon(item.name)
                    target.addWeapon(item.name, item.count)
                    TriggerClientEvent('dopeNotify:Alert', src, "", ('<b>%s</b> verschoben zu <b>%s</b>!'):format(item.label, otherInv.title), 5000, 'success')
                    TriggerEvent('CryptoHooker:SendMoveLog', src, item, count, xPlayer.getName(), target.getName())
                else 
                    TriggerClientEvent('dopeNotify:Alert', src, "", "Die Person hat diese Waffe bereits", 5000, 'error')
                end
            end
        elseif item.type == 'item_standard' then
            if xPlayer.getInventoryItem(item.name).count >= count then
                if Config.PlayerWeight then
                    if target.canCarryItem(item.name, count) then
                        xPlayer.removeInventoryItem(item.name, count)
                        target.addInventoryItem(item.name, count)
                        TriggerClientEvent('dopeNotify:Alert', src, "", ('%sx <b>%s</b> verschoben zu <b>%s</b>!'):format(count, item.label, otherInv.title), 5000, 'success') 
                        TriggerEvent('CryptoHooker:SendMoveLog', src, item, count, xPlayer.getName(), target.getName())
                    else 
                        TriggerClientEvent('dopeNotify:Alert', src, "", "Die Person kann das nicht Tragen", 5000, 'error')
                    end
                else 
                    local newCount = target.getInventoryItem(item.name).count + count
                    if newCount <= target.getInventoryItem(item.name).limit then
                        xPlayer.removeInventoryItem(item.name, count)
                        target.addInventoryItem(item.name, count)
                        TriggerClientEvent('dopeNotify:Alert', src, "", ('%sx <b>%s</b> verschoben zu <b>%s</b>!'):format(count, item.label, otherInv.title), 5000, 'success') 
                        TriggerEvent('CryptoHooker:SendMoveLog', src, item, count, xPlayer.getName(), target.getName())
                    else 
                        TriggerClientEvent('dopeNotify:Alert', src, "", "Die Person hat das Limit erreicht", 5000, 'error')
                    end
                end
            end
        end
    else
        if item.type == 'item_account' then
            if item.name == 'cash' then
                if xPlayer.getMoney() >= count then
                    AddItemToInventory(xPlayer, item, count, otherInv, function()
                        xPlayer.removeMoney(count)
                        TriggerClientEvent('dopeNotify:Alert', src, "", ('%sx <b>%s</b> verschoben zu <b>%s</b>!'):format(count, item.label, otherInv.title), 5000, 'success')
                        TriggerEvent('CryptoHooker:SendMoveLog', src, item, count, xPlayer.getName(), otherInv.title)
                    end)
                end
            else 
                if xPlayer.getAccount(item.name).money >= count then
                    AddItemToInventory(xPlayer, item, count, otherInv, function()
                        xPlayer.removeAccountMoney(item.name, count)
                        TriggerClientEvent('dopeNotify:Alert', src, "", ('%sx <b>%s</b> verschoben zu <b>%s</b>!'):format(count, item.label, otherInv.title), 5000, 'success')
                        TriggerEvent('CryptoHooker:SendMoveLog', src, item, count, xPlayer.getName(), otherInv.title)
                    end)
                end
            end
        elseif item.type == 'item_weapon' then
            if xPlayer.hasWeapon(item.name) then
                AddItemToInventory(xPlayer, item, item.count, otherInv, function()
                    xPlayer.removeWeapon(item.name)
                    TriggerClientEvent('dopeNotify:Alert', src, "", ('<b>%s</b> verschoben zu <b>%s</b>!'):format(item.label, otherInv.title), 5000, 'success')
                    TriggerEvent('CryptoHooker:SendMoveLog', src, item, count, xPlayer.getName(), otherInv.title)
                end)
            end
        elseif item.type == 'item_standard' then
            if xPlayer.getInventoryItem(item.name).count >= count then
                AddItemToInventory(xPlayer, item, count, otherInv, function()
                    xPlayer.removeInventoryItem(item.name, count)
                    TriggerClientEvent('dopeNotify:Alert', src, "", ('%sx <b>%s</b> verschoben zu <b>%s</b>!'):format(count, item.label, otherInv.title), 5000, 'success')
                    TriggerEvent('CryptoHooker:SendMoveLog', src, item, count, xPlayer.getName(), otherInv.title)
                end)
            end
        end
    end
    
    TriggerClientEvent('inventory:refresh', src)
    Refresh(otherInv.type, otherInv.id)
end)

RegisterNetEvent('inventory:addItemToHotbar', function(slot, item) 
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local identifier = xPlayer.getIdentifier()

    if item.inventory == 'hotbar' then
        Inventories['hotbar'][identifier][tostring(item.slot)] = Inventories['hotbar'][identifier][tostring(slot)]
    end

    for k,v in pairs(Inventories['hotbar'][identifier]) do
        if v.name == item.name then
            Inventories['hotbar'][identifier][k] = nil
        end
    end

    Inventories['hotbar'][identifier][tostring(slot)] = {type = item.type, name = item.name, label = item.label}

    if Config.HotbarSave then
        MySQL.Async.execute("UPDATE users SET hotbar=@hotbar WHERE identifier=@id", 
        {
            ["@id"] = identifier,
            ["@hotbar"] = json.encode(Inventories['hotbar'][identifier])
        }, function() end)
    end

    TriggerClientEvent('inventory:refresh', source)
end)

RegisterNetEvent('inventory:removeItemFromHotbar', function(slot) 
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local identifier = xPlayer.getIdentifier()

    Inventories['hotbar'][identifier][tostring(slot)] = nil

    if Config.HotbarSave then
        MySQL.Async.execute("UPDATE users SET hotbar=@hotbar WHERE identifier=@id", 
        {
            ["@id"] = identifier,
            ["@hotbar"] = json.encode(Inventories['hotbar'][identifier])
        }, function() end)
    end

    TriggerClientEvent('inventory:refresh', source)
end)


RegisterNetEvent('inventory:removeItem', function(item, count, coords)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    if item.type == 'item_account' then
        if item.name == 'cash' then
            if xPlayer.getMoney() >= count then
                xPlayer.removeMoney(count)
                CreateDrop(item, count, coords)
                TriggerClientEvent('dopeNotify:Alert', src, "",  ('%sx <b>%s</b> <b>%s</b>!'):format(count, item.label, 'fallen gelassen'), 5000, 'success')
                TriggerEvent('CryptoHooker:SendDropLog', src, item, count, coords)
            end
        else 
            if xPlayer.getAccount(item.name).money >= count then
                xPlayer.removeAccountMoney(item.name, count)
                CreateDrop(item, count, coords)
                TriggerClientEvent('dopeNotify:Alert', src, "",  ('%sx <b>%s</b> <b>%s</b>!'):format(count, item.label, 'fallen gelassen'), 5000, 'success')
                TriggerEvent('CryptoHooker:SendDropLog', src, item, count, coords)
            end
        end
    elseif item.type == 'item_weapon' then
        if xPlayer.hasWeapon(item.name) then
            xPlayer.removeWeapon(item.name)
            CreateDrop(item, item.count, coords)
            TriggerClientEvent('dopeNotify:Alert', src, "", ('<b>%s</b> <b>%s</b>!'):format(item.label, 'Dropped'), 5000, 'success')
            TriggerEvent('CryptoHooker:SendDropLog', src, item, count, coords)
        end
    elseif item.type == 'item_standard' then
        if xPlayer.getInventoryItem(item.name).count >= count then
            xPlayer.removeInventoryItem(item.name, count)
            CreateDrop(item, count, coords)
            TriggerClientEvent('dopeNotify:Alert', src, "",  ('%sx <b>%s</b> <b>%s</b>!'):format(count, item.label, 'fallen gelassen'), 5000, 'success')
            TriggerEvent('CryptoHooker:SendDropLog', src, item, count, coords)
        end
    end

    TriggerClientEvent('inventory:refresh', src)
end)

RegisterNetEvent('inventory:clearHotbar', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local identifier = xPlayer.getIdentifier()

    if not Inventories['hotbar'] then
        Inventories['hotbar'] = {}
    end
        
    Inventories['hotbar'][identifier] = {}
    
    if Config.HotbarSave then
        MySQL.Async.execute("UPDATE users SET hotbar=@hotbar WHERE identifier=@id", 
        {
            ["@id"] = identifier,
            ["@hotbar"] = json.encode(Inventories['hotbar'][identifier])
        }, function() end)
    end

    TriggerClientEvent('inventory:refresh', src)
end)

RegisterNetEvent("inventory:close", function(inventory)
    if OpenInventories[inventory.type] == nil then
        OpenInventories[inventory.type] = {}
    end

    if OpenInventories[inventory.type][inventory.id] == nil then
        OpenInventories[inventory.type][inventory.id] = {}
    end

    if OpenInventories[inventory.type][inventory.id][source] then
        OpenInventories[inventory.type][inventory.id][source] = nil 
    end
end)

AddEventHandler('esx:playerLoaded', function(source)
    TriggerClientEvent('inventory:refreshDrops', source, Drops)
end)

AddEventHandler('esx:playerDropped', function(source)
    CloseAllInventoriesForPlayer(source)
end)

function GiveSocietyMoney(moneytype, amount)
    money = (amount / 100) * Config.Tax
    TriggerEvent('esx_addonaccount:giveAccountMoney', 'society_government', "society_government", money)
end