ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'grove', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'grove', _U('alert_grove'), true, true)
TriggerEvent('esx_society:registerSociety', 'grove', 'Grove', 'society_grove', 'society_grove', 'society_grove', {type = 'public'})

RegisterServerEvent('esx_grovejob:confiscatePlayerItem')
AddEventHandler('esx_grovejob:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if sourceXPlayer.job.name ~= 'grove' then
		print(('esx_grovejob: %s attempted to confiscate!'):format(xPlayer.identifier))
		return
	end

	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)

		-- does the target player have enough in their inventory?
		if targetItem.count > 0 and targetItem.count <= amount then

			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then
				TriggerClientEvent('dopeNotify:Alert', _source, "", _U("quantity_invalid"), 5000, 'error')
			else
				targetXPlayer.removeInventoryItem(itemName, amount)
				sourceXPlayer.addInventoryItem   (itemName, amount)
				TriggerClientEvent('dopeNotify:Alert', _source, "", _U('you_confiscated', amount, sourceItem.label, targetXPlayer.name), 5000, 'info')
				TriggerClientEvent('dopeNotify:Alert', target, "", _U('got_confiscated', amount, sourceItem.label, sourceXPlayer.name), 5000, 'info')
			end
		else
			TriggerClientEvent('dopeNotify:Alert', _source, "", _U('quantity_invalid'), 5000, 'error')
		end

	elseif itemType == 'item_account' then
		targetXPlayer.removeAccountMoney(itemName, amount)
		sourceXPlayer.addAccountMoney   (itemName, amount)

		TriggerClientEvent('dopeNotify:Alert', _source, "", _U('you_confiscated_account', amount, itemName, targetXPlayer.name), 5000, 'info')
		TriggerClientEvent('dopeNotify:Alert', target, "", _U('got_confiscated_account', amount, itemName, sourceXPlayer.name), 5000, 'info')

	elseif itemType == 'item_weapon' then
		if amount == nil then amount = 0 end
		targetXPlayer.removeWeapon(itemName, amount)
		sourceXPlayer.addWeapon   (itemName, amount)

		TriggerClientEvent('dopeNotify:Alert', _source, "", _U('you_confiscated_weapon', ESX.GetWeaponLabel(itemName), targetXPlayer.name, amount), 5000, 'info')
		TriggerClientEvent('dopeNotify:Alert', target, "", _U('got_confiscated_weapon', ESX.GetWeaponLabel(itemName), amount, sourceXPlayer.name), 5000, 'info')
	end
end)

RegisterServerEvent('esx_grovejob:handcuff')
AddEventHandler('esx_grovejob:handcuff', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'grove' then
		TriggerClientEvent('esx_grovejob:handcuff', target)
	else
		print(('esx_grovejob: %s attempted to handcuff a player (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_grovejob:drag')
AddEventHandler('esx_grovejob:drag', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'grove' then
		TriggerClientEvent('esx_grovejob:drag', target, source)
	else
		print(('esx_grovejob: %s attempted to drag (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_grovejob:putInVehicle')
AddEventHandler('esx_grovejob:putInVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'grove' then
		TriggerClientEvent('esx_grovejob:putInVehicle', target)
	else
		print(('esx_grovejob: %s attempted to put in vehicle (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_grovejob:OutVehicle')
AddEventHandler('esx_grovejob:OutVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'grove' then
		TriggerClientEvent('esx_grovejob:OutVehicle', target)
	else
		print(('esx_grovejob: %s attempted to drag out from vehicle (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_grovejob:getStockItem')
AddEventHandler('esx_grovejob:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_grove', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		if count > 0 and inventoryItem.count >= count then
			inventory.removeItem(itemName, count)
			xPlayer.addInventoryItem(itemName, count)
			TriggerClientEvent('dopeNotify:Alert', _source, "", _U('have_withdrawn', count, inventoryItem.label), 5000, 'info')
		else
			TriggerClientEvent('dopeNotify:Alert', _source, "", _U('quantity_invalid'), 5000, 'error')
		end

	end)
end)

RegisterServerEvent('esx_grovejob:putStockItems')
AddEventHandler('esx_grovejob:putStockItems', function(itemName, count)
	print(itemName)
	print(count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_grove', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", _U('have_deposited', count, inventoryItem.label), 5000, 'info')
		else
			TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", _U('quantity_invalid'), 5000, 'error')
		end
	end)
end)

ESX.RegisterServerCallback('esx_grovejob:getOtherPlayerData', function(source, cb, target)
	if Config.EnableESXIdentity then
		local xPlayer = ESX.GetPlayerFromId(target)
		local result = MySQL.Sync.fetchAll('SELECT firstname, lastname, sex, dateofbirth, height FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		})

		local firstname = result[1].firstname
		local lastname  = result[1].lastname
		local sex       = result[1].sex
		local dob       = result[1].dateofbirth
		local height    = result[1].height

		local data = {
			name      = GetPlayerName(target),
			job       = xPlayer.job,
			inventory = xPlayer.inventory,
			accounts  = xPlayer.accounts,
			weapons   = xPlayer.loadout,
			firstname = firstname,
			lastname  = lastname,
			sex       = sex,
			dob       = dob,
			height    = height
		}

		TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
			if status ~= nil then
				data.drunk = math.floor(status.percent)
			end
		end)

		if Config.EnableLicenses then
			TriggerEvent('esx_license:getLicenses', target, function(licenses)
				data.licenses = licenses
				cb(data)
			end)
		else
			cb(data)
		end
	else
		local xPlayer = ESX.GetPlayerFromId(target)

		local data = {
			name       = GetPlayerName(target),
			job        = xPlayer.job,
			inventory  = xPlayer.inventory,
			accounts   = xPlayer.accounts,
			weapons    = xPlayer.loadout
		}

		TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
			if status then
				data.drunk = math.floor(status.percent)
			end
		end)

		TriggerEvent('esx_license:getLicenses', target, function(licenses)
			data.licenses = licenses
		end)

		cb(data)
	end
end)


ESX.RegisterServerCallback('esx_grovejob:getArmoryWeapons', function(source, cb)
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_grove', function(store)
		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		cb(weapons)
	end)
end)

ESX.RegisterServerCallback('esx_grovejob:addArmoryWeapon', function(source, cb, weaponName, removeWeapon)
	local xPlayer = ESX.GetPlayerFromId(source)

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
	end

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_grove', function(store)
		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = weapons[i].count + 1
				foundWeapon = true
				break
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name  = weaponName,
				count = 1
			})
		end

		store.set('weapons', weapons)
		cb()
	end)
end)

ESX.RegisterServerCallback('esx_grovejob:removeArmoryWeapon', function(source, cb, weaponName)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addWeapon(weaponName, 500)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_grove', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
				foundWeapon = true
				break
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name  = weaponName,
				count = 0
			})
		end

		store.set('weapons', weapons)
		cb()
	end)
end)



ESX.RegisterServerCallback('esx_grovejob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_grove', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('esx_grovejob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)

AddEventHandler('playerDropped', function()
	-- Save the source in case we lose it (which happens a lot)
	local _source = source

	-- Did the player ever join?
	if _source ~= nil then
		local xPlayer = ESX.GetPlayerFromId(_source)

		-- Is it worth telling all clients to refresh?
		if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'grove' then
			Citizen.Wait(5000)
			TriggerClientEvent('esx_grovejob:updateBlip', -1)
		end
	end
end)

RegisterServerEvent('esx_grovejob:spawned')
AddEventHandler('esx_grovejob:spawned', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'grove' then
		Citizen.Wait(5000)
		TriggerClientEvent('esx_grovejob:updateBlip', -1)
	end
end)

RegisterServerEvent('esx_grovejob:forceBlip')
AddEventHandler('esx_grovejob:forceBlip', function()
	TriggerClientEvent('esx_grovejob:updateBlip', -1)
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(5000)
		TriggerClientEvent('esx_grovejob:updateBlip', -1)
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_phone:removeNumber', 'grove')
	end
end)

RegisterServerEvent('esx_grovejob:message')
AddEventHandler('esx_grovejob:message', function(target, msg)
	TriggerClientEvent('dopeNotify:Alert', target, "", msg, 5000, 'info')
end)