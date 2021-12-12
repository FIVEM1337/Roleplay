ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_gangjobs:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)


RegisterServerEvent('esx_gangjobs:handcuff')
AddEventHandler('esx_gangjobs:handcuff', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	for k, v in pairs (gangs) do
		if v.job ~= nil and v.job == xPlayer.job.name then
			TriggerClientEvent('esx_gangjobs:handcuff', target)
		end
	end
end)

RegisterServerEvent('esx_gangjobs:drag')
AddEventHandler('esx_gangjobs:drag', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	for k, v in pairs (gangs) do
		if v.job ~= nil and v.job == xPlayer.job.name then
			TriggerClientEvent('esx_gangjobs:drag', target, source)
		end
	end
end)

RegisterServerEvent('esx_gangjobs:putInVehicle')
AddEventHandler('esx_gangjobs:putInVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	for k, v in pairs (gangs) do
		if v.job ~= nil and v.job == xPlayer.job.name then
			TriggerClientEvent('esx_gangjobs:putInVehicle', target)
		end
	end
end)

RegisterServerEvent('esx_gangjobs:OutVehicle')
AddEventHandler('esx_gangjobs:OutVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	for k, v in pairs (gangs) do
		if v.job ~= nil and v.job == xPlayer.job.name then
			TriggerClientEvent('esx_gangjobs:OutVehicle', target)
		end
	end
end)


ESX.RegisterServerCallback('esx_gangjobs:getArmoryWeapons', function(source, cb, station)
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..station, function(store)
		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		cb(weapons)
	end)
end)

ESX.RegisterServerCallback('esx_gangjobs:addArmoryWeapon', function(source, cb, weaponName, removeWeapon, station)
	local xPlayer = ESX.GetPlayerFromId(source)

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
	end

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..station, function(store)
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

ESX.RegisterServerCallback('esx_gangjobs:removeArmoryWeapon', function(source, cb, weaponName, station)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addWeapon(weaponName, 500)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..station, function(store)

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

ESX.RegisterServerCallback('esx_gangjobs:getStockItems', function(source, cb, station)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'..station, function(inventory)
		cb(inventory.items)
	end)
end)