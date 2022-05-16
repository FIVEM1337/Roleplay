local restricted_zones = {}

CreateThread(function()
	while true do
		Wait(1000)
		local xPlayers  = ESX.GetPlayers()
		for k, v in pairs(restricted_zones) do
			v.duration = v.duration - 1
			if v.duration < 0 then
				for k2, v2 in pairs(xPlayers) do
					local xPlayer = ESX.GetPlayerFromId(v2)
					TriggerClientEvent('esx_jobs:removerestictedzone', xPlayer.source, v.coords)
				end
				restricted_zones[k] = nil
			end
		end
	end
end)

ESX.RegisterServerCallback('esx_jobs:GetRestirctedZones', function(source, cb)
	cb(restricted_zones)
end)


ESX.RegisterServerCallback('esx_jobs:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)


CreateThread(function()
	for k, v in pairs (jobs) do
		if v.society then
			TriggerEvent('esx_society:registerSociety', v.job, v.job, 'society_'..v.job, 'society_'..v.job, 'society_'..v.job, {type = 'public'})
		end
	end
end)

RegisterServerEvent('esx_jobs:removeRestrictedZone')
AddEventHandler('esx_jobs:removeRestrictedZone', function(remove_coords)
	if not rawequal(next(restricted_zones), nil) then
		for k, v in pairs(restricted_zones) do
			if #(v.coords - remove_coords) < 150.0 then
				restricted_zones[k] = nil
			end
		end
		SendData()
	end
end)

RegisterServerEvent('esx_jobs:createRestrictedZone')
AddEventHandler('esx_jobs:createRestrictedZone', function(data)
	if not rawequal(next(restricted_zones), nil) then
		for k, v in pairs(restricted_zones) do
			if #(v.coords - data.coords) < 150.0 then
				restricted_zones[k] = nil
				table.insert(restricted_zones, data)
			end
		end
		SendData()
	else
		table.insert(restricted_zones, data)
		SendData()
	end
end)

function SendData()
	local xPlayers  = ESX.GetPlayers()
	for k, v in pairs(xPlayers) do
		local xPlayer = ESX.GetPlayerFromId(v)
		TriggerClientEvent('esx_jobs:createRestrictedZone', xPlayer.source, restricted_zones)
	end
end

ESX.RegisterServerCallback('esx_jobs:getArmoryWeapons', function(source, cb, station)
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..station, function(store)
		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		cb(weapons)
	end)
end)

RegisterServerEvent('esx_jobs:withdraw_society_money')
AddEventHandler('esx_jobs:withdraw_society_money', function(societyName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	amount = ESX.Math.Round(tonumber(amount))

	if amount > 0 then
		TriggerEvent('esx_addonaccount:getSharedAccount', societyName, function(account)
			if account.money >= amount then
				account.removeMoney(amount)
				xPlayer.addMoney(amount)
				TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", "Du hast ".. ESX.Math.GroupDigits(amount).. "$ von deinem Job Konto abgebucht", 5000, 'info')
			else
				TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", _U('society_not_enought_money'), 5000, 'error')
			end
		end)
	else
		TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", _U('quantity_invalid'), 5000, 'error')
	end
end)

RegisterServerEvent('esx_jobs:deposit_society_money')
AddEventHandler('esx_jobs:deposit_society_money', function(societyName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	amount = ESX.Math.Round(tonumber(amount))


	if amount > 0 then
		if xPlayer.getMoney() >= amount then
			TriggerEvent('esx_addonaccount:getSharedAccount', societyName, function(account)
				xPlayer.removeMoney(amount)
				account.addMoney(amount)
				TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", "Du hast ".. ESX.Math.GroupDigits(amount).. "$ in deinem Job Konto eingezahlt", 5000, 'info')
			end)
		else
			TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", _U('not_enought_money'), 5000, 'error')
		end
	else
		TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", _U('quantity_invalid'), 5000, 'error')
	end
end)

ESX.RegisterServerCallback('esx_jobs:addArmoryWeapon', function(source, cb, weaponName, components, station)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..station, function(store)
		local weapons = store.get('weapons')
		local uid

		if weapons == nil then
			weapons = {}
		end

		while uid == nil do
			local tempid = math.random(1000000000000, 9999999999999)
			local found = false
			for k, v in pairs (weapons) do
				if tempid == v.uid then
					found = true
				end
			end

			if not found then
				local loadoutNum, weapon = xPlayer.getWeapon(weaponName)
				if weapon then
					xPlayer.removeWeapon(weaponName)
	
					uid = tempid
					table.insert(weapons, {
						name  = weaponName,
						ammo = weapon.ammo,
						components = components,
						uid = uid
					})
	
					store.set('weapons', weapons)
					cb()
				end
				break
			end
			Wait(1)
		end
	end)
end)


ESX.RegisterServerCallback('esx_jobs:removeArmoryWeapon', function(source, cb, weaponName, uid, station)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.hasWeapon(weaponName) then
		TriggerClientEvent('dopeNotify:Alert', source, "", "Du hast bereits diese Waffe", 2000, 'error')
		return
	end

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..station, function(store)
		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		local foundWeapon
		for k, v in pairs (weapons) do
			if v.uid == uid then
				foundWeapon = v
				table.remove(weapons, k)
				break
			end
		end

		if foundWeapon then
			xPlayer.addWeapon(foundWeapon.name, foundWeapon.ammo)
			for k,v in pairs(foundWeapon.components) do
				xPlayer.addWeaponComponent(foundWeapon.name, v)
			end
		else
			TriggerClientEvent('dopeNotify:Alert', source, "", "fehler", 2000, 'error')
			return
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

RegisterServerEvent('esx_jobs:putStockItems')
AddEventHandler('esx_jobs:putStockItems', function(itemName, count, station)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'..station, function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", "Du hast "..count.."x "..inventoryItem.label.." eingelagert", 5000, 'error')
		else
			TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", _U('quantity_invalid'), 5000, 'error')
		end
	end)
end)

ESX.RegisterServerCallback('esx_jobs:getjobskinwithgrade', function(source, cb, sex, outfittype, grade)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local result = nil


	MySQL.Async.fetchAll('SELECT skin_male1, skin_male2, skin_male3, skin_female1, skin_female2, skin_female3 FROM job_grades WHERE job_name = @job_name and label = @label', {
		['@job_name'] = xPlayer.job.name,
		['@label'] = grade,
	}, function(result)
		if result[1] then
			if sex == "male" then
				if outfittype == 1 then
					result = result[1].skin_male1
				elseif outfittype == 2 then
					result = result[1].skin_male2
				elseif outfittype == 3 then
					result = result[1].skin_male3
				end
			else
				if outfittype == 1 then
					result = result[1].skin_female1
				elseif outfittype == 2 then
					result = result[1].skin_female2
				elseif outfittype == 3 then
					result = result[1].skin_female3
				end
			end

			if result then
				if result == "{}" then
					cb(nil)
				else
					cb(result)
				end
			else
				cb(nil)
			end
		end
	end)
end)


ESX.RegisterServerCallback('esx_jobs:getjobskin', function(source, cb, sex, outfittype)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)


	MySQL.Async.fetchAll('SELECT skin_male1, skin_male2, skin_male3, skin_female1, skin_female2, skin_female3 FROM job_grades WHERE job_name = @job_name and grade = @grade', {
		['@job_name'] = xPlayer.job.name,
		['@grade'] = xPlayer.job.grade,
	}, function(result)
		if result[1] then
			if sex == 0 then
				if outfittype == 1 then
					cb(result[1].skin_male1)
				elseif outfittype == 2 then
					cb(result[1].skin_male2)
				elseif outfittype == 3 then
					cb(result[1].skin_male3)
				end
			else
				if outfittype == 1 then
					cb(result[1].skin_female1)
				elseif outfittype == 2 then
					cb(result[1].skin_female2)
				elseif outfittype == 3 then
					cb(result[1].skin_female3)
				end
			end
		end
	end)
end)

ESX.RegisterServerCallback('esx_jobs:getOtherPlayerData', function(source, cb, target, notify)
	local xPlayer = ESX.GetPlayerFromId(target)

	TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", _U('being_searched'), 5000, 'info')

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

		TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
			if status then
				data.drunk = ESX.Math.Round(status.percent)
			end
		end)


		TriggerEvent('esx_license:getLicenses', target, function(licenses)
			data.licenses = licenses
			cb(data)
		end)
	else
		cb(data)
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
			cb(nil)
		end
	end)
end)
