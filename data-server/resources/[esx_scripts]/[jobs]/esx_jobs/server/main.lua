local restricted_zones = {}
local handcuffed = {}

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


CreateThread(function()
	while true do
		Wait(1000)
		for k, v in pairs(handcuffed) do
			if v.timer then
				v.timer = v.timer - 1
				if v.timer < 0 then
					xPlayer = ESX.GetPlayerFromIdentifier(v.identifier)
					if xPlayer then
						TriggerClientEvent('esx_jobs:unhandcuff', xPlayer.source)
					end
					handcuffed[v.identifier] = nil
				end
			end
		end
	end
end)


RegisterServerEvent('esx_jobs:ishandcuffed')
AddEventHandler('esx_jobs:ishandcuffed', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if handcuffed[xPlayer.identifier] then
		if handcuffed[xPlayer.identifier].cuffed then
			TriggerClientEvent('esx_jobs:handcuff', xPlayer.source)
		end
	end
end)

RegisterServerEvent('esx_jobs:handcuff')
AddEventHandler('esx_jobs:handcuff', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)

	if not handcuffed[xTarget.identifier] then
		handcuffed[xTarget.identifier] = {}
	end

	if not handcuffed[xTarget.identifier].cuffed then
		if xPlayer.job.name == "police" then
			if xPlayer.getInventoryItem("use_handcuffs") and xPlayer.getInventoryItem("use_handcuffs").count >= 1 then
				xPlayer.removeInventoryItem("use_handcuffs", 1)
				handcuffed[xTarget.identifier].cuffed = true
				handcuffed[xTarget.identifier].type = "handcuffs"
				handcuffed[xTarget.identifier].identifier = xTarget.identifier
				handcuffed[xTarget.identifier].timer = 1200
				TriggerClientEvent('esx_jobs:handcuff', xTarget.source)
				TriggerClientEvent('dopeNotify:Alert', xTarget.source, "", "Dir wurden Handschellen angelegt die sich in 20 Minuten lößen", 5000, 'error')
			else
				TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", "Du hast keine Handschellen", 5000, 'error')
			end
		else
			if xPlayer.getInventoryItem("use_kabelbinder") and xPlayer.getInventoryItem("use_kabelbinder").count >= 1 then
				xPlayer.removeInventoryItem("use_kabelbinder", 1)
				handcuffed[xTarget.identifier].cuffed = true
				handcuffed[xTarget.identifier].type = "ties"
				handcuffed[xTarget.identifier].identifier = xTarget.identifier
				handcuffed[xTarget.identifier].timer = 900
				TriggerClientEvent('esx_jobs:handcuff', xTarget.source)
				TriggerClientEvent('dopeNotify:Alert', xTarget.source, "", "Dir wurden Kabelbinder angelegt die sich in 15 Minuten lößen", 5000, 'error')
			else
				TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", "Du hast keine Kabelbinder", 5000, 'error')
			end
		end
	else
		TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", "Die Person ist bereits gefesselt", 5000, 'error')
	end
end)

RegisterServerEvent('esx_jobs:uncuff')
AddEventHandler('esx_jobs:uncuff', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)

	if not handcuffed[xTarget.identifier] then
		handcuffed[xTarget.identifier] = {}
	end

	if handcuffed[xTarget.identifier].cuffed then
		if handcuffed[xTarget.identifier].type == "handcuffs" then
			if xPlayer.job.name == "police" then
				xPlayer.addInventoryItem("use_handcuffs", 1)
				handcuffed[xTarget.identifier] = nil
				TriggerClientEvent('esx_jobs:unhandcuff', xTarget.source)
			else
				if xPlayer.getInventoryItem("use_bolt_cutter") and xPlayer.getInventoryItem("use_bolt_cutter").count >= 1 then
					if math.random(1,100) <= 10 then
						xPlayer.removeInventoryItem("use_bolt_cutter", 1)
						TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", "Der Bolzenschneider ist kaputt gegangen", 5000, 'error')
					end
					handcuffed[xTarget.identifier] = nil
					TriggerClientEvent('esx_jobs:unhandcuff', xTarget.source)
				else
					TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", "Du hast keine Bolzenschneider", 5000, 'error')
				end
			end
		elseif handcuffed[xTarget.identifier].type == "ties" then
			if xPlayer.getInventoryItem("use_schere") and xPlayer.getInventoryItem("use_schere").count >= 1 then
				if math.random(1,100) <= 20 then
					xPlayer.removeInventoryItem("use_schere", 1)
					TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", "Die Schere ist kaputt gegangen", 5000, 'error')
				end
				handcuffed[xTarget.identifier] = nil
				TriggerClientEvent('esx_jobs:unhandcuff', xTarget.source)
			else
				TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", "Du benötigst eine Schere", 5000, 'error')
			end
		end
	else
		TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", "Die Person ist nicht gefesselt", 5000, 'error')
	end
end)

RegisterServerEvent('esx_jobs:drag')
AddEventHandler('esx_jobs:drag', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	for k, v in pairs (jobs) do
		if v.job ~= nil and v.job == xPlayer.job.name then
			TriggerClientEvent('esx_jobs:drag', target, source)
		end
	end
end)

RegisterServerEvent('esx_jobs:putInVehicle')
AddEventHandler('esx_jobs:putInVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	for k, v in pairs (jobs) do
		if v.job ~= nil and v.job == xPlayer.job.name then
			TriggerClientEvent('esx_jobs:putInVehicle', target)
		end
	end
end)

RegisterServerEvent('esx_jobs:OutVehicle')
AddEventHandler('esx_jobs:OutVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	for k, v in pairs (jobs) do
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
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', count, inventoryItem.label))
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
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

RegisterNetEvent('esx_jobs:confiscatePlayerItem')
AddEventHandler('esx_jobs:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)



	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)

		if targetItem.count > 0 and targetItem.count >= amount then
			if sourceXPlayer.canCarryItem(itemName, sourceItem.count) then
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
			cb(nil)
		end
	end)
end)
