local handcuffed = {}

ESX.RegisterServerCallback('esx_playerradialmenu:getOtherPlayerData', function(source, cb, target, notify)
	local xPlayer = ESX.GetPlayerFromId(target)
	if notify then
		TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", _U('being_searched'), 5000, 'info')
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

RegisterNetEvent('esx_playerradialmenu:confiscatePlayerItem')
AddEventHandler('esx_playerradialmenu:confiscatePlayerItem', function(target, itemType, itemName, amount)
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
				TriggerClientEvent('dopeNotify:Alert', sourceXPlayer.source, "", _U('you_confiscated', amount, sourceItem.label, targetXPlayer.name), 5000, 'info')
				TriggerClientEvent('dopeNotify:Alert', targetXPlayer.source, "", _U('got_confiscated', amount, sourceItem.label, targetXPlayer.name), 5000, 'info')
			else
				TriggerClientEvent('dopeNotify:Alert', sourceXPlayer.source, "", _U('you_cant_carry'), 5000, 'info')
			end
		else
			TriggerClientEvent('dopeNotify:Alert', sourceXPlayer.source, "", _U('quantity_invalid'), 5000, 'info')
		end

	elseif itemType == 'item_account' then
		local targetAccount = targetXPlayer.getAccount(itemName)

		if targetAccount.money >= amount then
			targetXPlayer.removeAccountMoney(itemName, amount)
			sourceXPlayer.addAccountMoney(itemName, amount)
			TriggerClientEvent('dopeNotify:Alert', sourceXPlayer.source, "", _U('you_confiscated_account', amount, itemName, sourceXPlayer.name), 5000, 'info')
			TriggerClientEvent('dopeNotify:Alert', targetXPlayer.source, "", _U('got_confiscated_account', amount, itemName, sourceXPlayer.name), 5000, 'info')
		else
			TriggerClientEvent('dopeNotify:Alert', sourceXPlayer.source, "", _U('quantity_invalid'), 5000, 'info')
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

				TriggerClientEvent('dopeNotify:Alert', sourceXPlayer.source, "", _U('you_confiscated_weapon', ESX.GetWeaponLabel(itemName), amount, targetXPlayer.name), 5000, 'info')
				TriggerClientEvent('dopeNotify:Alert', targetXPlayer.source, "", _U('got_confiscated_weapon', ESX.GetWeaponLabel(itemName), amount, targetXPlayer.name), 5000, 'info')

			else
				TriggerClientEvent('dopeNotify:Alert', sourceXPlayer.source, "",_U('quantity_invalid'), 5000, 'info')
			end
		else
			TriggerClientEvent('dopeNotify:Alert', sourceXPlayer.source, "",_U('quantity_invalid'), 5000, 'info')
		end
	end
end)

RegisterServerEvent('esx_playerradialmenu:drag')
AddEventHandler('esx_playerradialmenu:drag', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

    TriggerClientEvent('esx_playerradialmenu:drag', target, source)
end)

RegisterServerEvent('esx_playerradialmenu:putInVehicle')
AddEventHandler('esx_playerradialmenu:putInVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

    TriggerClientEvent('esx_playerradialmenu:putInVehicle', target)
end)

RegisterServerEvent('esx_playerradialmenu:OutVehicle')
AddEventHandler('esx_playerradialmenu:OutVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

    TriggerClientEvent('esx_playerradialmenu:OutVehicle', target)
end)

RegisterServerEvent('esx_playerradialmenu:ishandcuffed')
AddEventHandler('esx_playerradialmenu:ishandcuffed', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if handcuffed[xPlayer.identifier] then
		if handcuffed[xPlayer.identifier].cuffed then
			TriggerClientEvent('esx_playerradialmenu:handcuff', xPlayer.source)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(1000)
		for k, v in pairs(handcuffed) do
			if v.timer then
				v.timer = v.timer - 1
				if v.timer < 0 then
					xPlayer = ESX.GetPlayerFromIdentifier(v.identifier)
					if xPlayer then
						TriggerClientEvent('esx_playerradialmenu:unhandcuff', xPlayer.source)
						TriggerEvent("CryptoHooker:auto_unhandcuff", xPlayer.source)
					end
					handcuffed[v.identifier] = nil
				end
			end
		end
	end
end)

RegisterServerEvent('esx_playerradialmenu:handcuff')
AddEventHandler('esx_playerradialmenu:handcuff', function(target)
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
				TriggerClientEvent('esx_playerradialmenu:handcuff', xTarget.source)
				TriggerClientEvent('dopeNotify:Alert', xTarget.source, "", "Dir wurden Handschellen angelegt die sich in 20 Minuten lößen", 5000, 'error')
				TriggerEvent("CryptoHooker:handcuff", xPlayer.source, xTarget.source)
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
				TriggerClientEvent('esx_playerradialmenu:handcuff', xTarget.source)
				TriggerClientEvent('dopeNotify:Alert', xTarget.source, "", "Dir wurden Kabelbinder angelegt die sich in 15 Minuten lößen", 5000, 'error')
				TriggerEvent("CryptoHooker:handcuff", source, xPlayer.source, xTarget.source)
			else
				TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", "Du hast keine Kabelbinder", 5000, 'error')
			end
		end
	else
		TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", "Die Person ist bereits gefesselt", 5000, 'error')
	end
end)

RegisterServerEvent('esx_playerradialmenu:uncuff')
AddEventHandler('esx_playerradialmenu:uncuff', function(target)
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
				TriggerClientEvent('esx_playerradialmenu:unhandcuff', xTarget.source)
				TriggerEvent("CryptoHooker:unhandcuff", xPlayer.source, xTarget.source)
			else
				if xPlayer.getInventoryItem("use_bolt_cutter") and xPlayer.getInventoryItem("use_bolt_cutter").count >= 1 then
					if math.random(1,100) <= 10 then
						xPlayer.removeInventoryItem("use_bolt_cutter", 1)
						TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", "Der Bolzenschneider ist kaputt gegangen", 5000, 'error')
					end
					handcuffed[xTarget.identifier] = nil
					TriggerClientEvent('esx_playerradialmenu:unhandcuff', xTarget.source)
					TriggerEvent("CryptoHooker:unhandcuff", xPlayer.source, xTarget.source)
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
				TriggerClientEvent('esx_playerradialmenu:unhandcuff', xTarget.source)
				TriggerEvent("CryptoHooker:unhandcuff", xPlayer.source, xTarget.source)
			else
				TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", "Du benötigst eine Schere", 5000, 'error')
			end
		end
	else
		TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", "Die Person ist nicht gefesselt", 5000, 'error')
	end
end)


RegisterNetEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	local xPlayer = ESX.GetPlayerFromId(source)
	if handcuffed[xPlayer.identifier] and handcuffed[xPlayer.identifier].cuffed then
		handcuffed[xPlayer.identifier] = nil
		TriggerClientEvent('esx_playerradialmenu:unhandcuff', xPlayer.source)
	end
end)
