ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_jobs:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)


RegisterServerEvent('esx_jobs:handcuff')
AddEventHandler('esx_jobs:handcuff', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	for k, v in pairs (gangs) do
		if v.job ~= nil and v.job == xPlayer.job.name then
			TriggerClientEvent('esx_jobs:handcuff', target)
		end
	end
end)

RegisterServerEvent('esx_jobs:drag')
AddEventHandler('esx_jobs:drag', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	for k, v in pairs (gangs) do
		if v.job ~= nil and v.job == xPlayer.job.name then
			TriggerClientEvent('esx_jobs:drag', target, source)
		end
	end
end)

RegisterServerEvent('esx_jobs:putInVehicle')
AddEventHandler('esx_jobs:putInVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	for k, v in pairs (gangs) do
		if v.job ~= nil and v.job == xPlayer.job.name then
			TriggerClientEvent('esx_jobs:putInVehicle', target)
		end
	end
end)

RegisterServerEvent('esx_jobs:OutVehicle')
AddEventHandler('esx_jobs:OutVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	for k, v in pairs (gangs) do
		if v.job ~= nil and v.job == xPlayer.job.name then
			TriggerClientEvent('esx_jobs:OutVehicle', target)
		end
	end
end)


ESX.RegisterServerCallback('esx_jobs:getArmoryWeapons', function(source, cb, station)
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..station, function(store)
		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		cb(weapons)
	end)
end)

ESX.RegisterServerCallback('esx_jobs:addArmoryWeapon', function(source, cb, weaponName, removeWeapon, station)
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

ESX.RegisterServerCallback('esx_jobs:removeArmoryWeapon', function(source, cb, weaponName, station)
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

ESX.RegisterServerCallback('esx_jobs:getStockItems', function(source, cb, station)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'..station, function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('esx_jobs:getjobskin', function(source, cb, sex)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.fetchAll('SELECT skin_male, skin_female FROM job_grades WHERE job_name = @job_name and grade = @grade', {
		['@job_name'] = xPlayer.job.name,
		['@grade'] = xPlayer.job.grade,
	}, function(result)
		if result[1] then
			if sex == 0 then
				cb(result[1].skin_male)
			else
				cb(result[1].skin_female)
			end
		end
	end)
end)

ESX.RegisterServerCallback('esx_jobs:getOtherPlayerData', function(source, cb, target, notify)
	local xPlayer = ESX.GetPlayerFromId(target)
	if notify then
		xPlayer.showNotification(_U('being_searched'))
	end

	if xPlayer then
		local data = {
			name = xPlayer.getName(),
			job = xPlayer.job.label,
			grade = xPlayer.job.grade_label,
			inventory = xPlayer.getInventory(),
			accounts = xPlayer.getAccounts(),
			weapons = xPlayer.getLoadout()
		}

		if Config.EnableESXIdentity then
			data.dob = xPlayer.get('dateofbirth')
			data.height = xPlayer.get('height')

			if xPlayer.get('sex') == 'm' then 
				data.sex = 'male' 
			else 
				data.sex = 'female' 
			end
		end

		TriggerEvent('esx_status:getStatus', 1, 'drunk', function(status)
			if status then
				data.drunk = ESX.Math.Round(status.percent)
			end
		end)


		TriggerEvent('esx_license:getLicenses', 1, function(licenses)
			data.licenses = licenses
			cb(data)
		end)
	end
end)

RegisterNetEvent('esx_jobs:confiscatePlayerItem')
AddEventHandler('esx_jobs:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if sourceXPlayer.job then
		if gangs[sourceXPlayer.job.name] then
			v = gangs[sourceXPlayer.job.name]
			if v.body_search == false or v.body_search == nil then
				print(('esx_jobs: %s attempted to confiscate!'):format(sourceXPlayer.identifier))
				return
			end
		end
	end


	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)

		if targetItem.count > 0 and targetItem.count >= amount then
			if not sourceXPlayer.canCarryItem(itemName, sourceItem.count) then
				targetXPlayer.removeInventoryItem(itemName, amount)
				sourceXPlayer.addInventoryItem(itemName, amount)
				sourceXPlayer.showNotification(_U('you_confiscated', amount, sourceItem.label, targetXPlayer.name))
				targetXPlayer.showNotification(_U('got_confiscated', amount, sourceItem.label, sourceXPlayer.name))
			else
				sourceXPlayer.showNotification(_U('you_cant_carry'))
			end
		else
			sourceXPlayer.showNotification(_U('quantity_invalid'))
		end

	elseif itemType == 'item_account' then
		local targetAccount = targetXPlayer.getAccount(itemName)

		if targetAccount.money >= amount then
			targetXPlayer.removeAccountMoney(itemName, amount)
			sourceXPlayer.addAccountMoney(itemName, amount)
			sourceXPlayer.showNotification(_U('you_confiscated_account', amount, itemName, targetXPlayer.name))
			targetXPlayer.showNotification(_U('got_confiscated_account', amount, itemName, sourceXPlayer.name))
		else
			sourceXPlayer.showNotification(_U('quantity_invalid'))
		end

	elseif itemType == 'item_weapon' then
		if targetXPlayer.hasWeapon(itemName) then
			local loadoutNum, weapon = targetXPlayer.getWeapon(itemName)
			if weapon.ammo > 0 and weapon.ammo >= amount then
				if weapon.ammo > amount then
					targetXPlayer.setWeaponAmmo(itemName, weapon.ammo - amount)
				else
					targetXPlayer.removeWeapon(itemName, weapon.ammo)
				end

				if sourceXPlayer.hasWeapon(itemName) then
					sourceXPlayer.addWeaponAmmo(itemName, amount)
				else
					sourceXPlayer.addWeapon(itemName, amount)
				end

				sourceXPlayer.showNotification(_U('you_confiscated_weapon', ESX.GetWeaponLabel(itemName), amount, targetXPlayer.name))
				targetXPlayer.showNotification(_U('got_confiscated_weapon', ESX.GetWeaponLabel(itemName), amount, sourceXPlayer.name))
			else
				sourceXPlayer.showNotification(_U('quantity_invalid'))
			end
		else
			sourceXPlayer.showNotification(_U('quantity_invalid'))
		end
	end
end)

ESX.RegisterServerCallback('esx_jobs:getVehicleInfos', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		local retrivedInfo = {plate = plate}
		if result[1] then
			local xPlayer = ESX.GetPlayerFromIdentifier(result[1].owner)

			-- is the owner online?
			if xPlayer then
				retrivedInfo.owner = xPlayer.getName()
				cb(retrivedInfo)
			elseif Config.EnableESXIdentity then
				MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier',  {
					['@identifier'] = result[1].owner
				}, function(result2)
					if result2[1] then
						retrivedInfo.owner = ('%s %s'):format(result2[1].firstname, result2[1].lastname)
						cb(retrivedInfo)
					else
						cb(retrivedInfo)
					end
				end)
			else
				cb(retrivedInfo)
			end
		else
			MySQL.Async.fetchAll('SELECT job FROM job_vehicles WHERE plate = @plate', {
				['@plate'] = plate
			}, function(result)
				local retrivedInfo = {plate = plate}
		
				if result[1] then
					retrivedInfo.owner = result[1].job
					cb(retrivedInfo)
				else
					cb(retrivedInfo)
				end
			end)
		end
	end)
end)

ESX.RegisterServerCallback('esx_jobs:getFineList', function(source, cb, category)
	MySQL.Async.fetchAll('SELECT * FROM fine_types WHERE category = @category', {
		['@category'] = category
	}, function(fines)
		cb(fines)
	end)
end)

ESX.RegisterServerCallback('esx_jobs:impound', function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored, impound = @impound WHERE TRIM(UPPER(plate)) = @plate', {
		['@plate'] = plate,
		['@stored'] = true,
		['@impound'] = true
	}, function(rowsChanged)
		if rowsChanged > 0 then
			cb(true)
		else
			MySQL.Async.execute('UPDATE job_vehicles SET `stored` = @stored, impound = @impound WHERE TRIM(UPPER(plate)) = @plate', {
				['@plate'] = plate,
				['@stored'] = true,
				['@impound'] = true
			}, function(rowsChanged)
				if rowsChanged > 0 then
					cb(true)
				else
					cb(false)
				end	
			end)
		end
	end)
end)
