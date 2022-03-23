-- Usable Items
ESX.RegisterUsableItem('ammo_small', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:checkitem', source, 'ammo_small')
end)

ESX.RegisterUsableItem('ammo_box', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerClientEvent('esx_weapon_attachment:checkitem', source, 'ammo_box')
end)

ESX.RegisterUsableItem('ammo_pistol', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:checkitem', source, 'ammo_pistol')
end)

ESX.RegisterUsableItem('ammo_smg', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:checkitem', source, 'ammo_smg')
end)

ESX.RegisterUsableItem('ammo_shotgun', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:checkitem', source, 'ammo_shotgun')
end)

ESX.RegisterUsableItem('ammo_rifle', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:checkitem', source, 'ammo_rifle')
end)

ESX.RegisterUsableItem('ammo_mg', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:checkitem', source, 'ammo_mg')
end)

ESX.RegisterUsableItem('ammo_sniper', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:checkitem', source, 'ammo_sniper')
end)

ESX.RegisterUsableItem('ammo_throwable', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:checkitem', source, 'ammo_throwable')
end)

-- Attachments
ESX.RegisterUsableItem('att_scope', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:addattachment', source, 'att_scope')
end)

ESX.RegisterUsableItem('att_grip', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:addattachment', source, 'att_grip')
end)

ESX.RegisterUsableItem('att_flashlight', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:addattachment', source, 'att_flashlight')
end)

ESX.RegisterUsableItem('att_clip_extended', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:addattachment', source, 'att_clip_extended')
end)

ESX.RegisterUsableItem('att_suppressor', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:addattachment', source, 'att_suppressor')
end)

ESX.RegisterUsableItem('att_luxary_finish', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:addattachment', source, 'att_luxary_finish')
end)

-- Tints
ESX.RegisterUsableItem('att_tint_green', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:addtint', source, 'att_tint_green')
end)

ESX.RegisterUsableItem('att_tint_gold', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:addtint', source, 'att_tint_gold')
end)

ESX.RegisterUsableItem('att_tint_pink', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:addtint', source, 'att_tint_pink')
end)

ESX.RegisterUsableItem('att_tint_camouflag', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:addtint', source, 'att_tint_camouflag')
end)

ESX.RegisterUsableItem('att_tint_blue', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:addtint', source, 'att_tint_blue')
end)

ESX.RegisterUsableItem('att_tint_orange', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:addtint', source, 'att_tint_orange')
end)

ESX.RegisterUsableItem('att_tint_platinum', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:addtint', source, 'att_tint_platinum')
end)

-- Add Ammunition into Weapon
RegisterNetEvent('esx_weapon_attachment:addweaclip')
AddEventHandler('esx_weapon_attachment:addweaclip', function(hash)
	local xPlayer = ESX.GetPlayerFromId(source)
    local ammo = Config.WeaponAmmoClips.WeaponClip

	for k,v in pairs(Config.Weapons.AllWeapons) do
		if (v.weaponHash == hash) then
			xPlayer.addWeaponAmmo(v.weaponName, ammo)
		end
	end

	saveESXPlayer(xPlayer)
end)

RegisterNetEvent('esx_weapon_attachment:addweabox')
AddEventHandler('esx_weapon_attachment:addweabox', function(hash)
	local xPlayer = ESX.GetPlayerFromId(source)
    local ammo = Config.WeaponAmmoClips.WeaponBox

	for k,v in pairs(Config.Weapons.AllWeapons) do
		if (v.weaponHash == hash) then
			xPlayer.addWeaponAmmo(v.weaponName, ammo)
		end
	end

	saveESXPlayer(xPlayer)
end)

RegisterNetEvent('esx_weapon_attachment:addpistolammo')
AddEventHandler('esx_weapon_attachment:addpistolammo', function(hash)
	local xPlayer = ESX.GetPlayerFromId(source)
	local ammo = Config.WeaponAmmoClips.Pistols

	for k,v in pairs(Config.Weapons.Pistols) do
		if (v.weaponHash == hash) then
			xPlayer.addWeaponAmmo(v.weaponName, ammo)
		end
	end

	saveESXPlayer(xPlayer)
end)

RegisterNetEvent('esx_weapon_attachment:addsmgammo')
AddEventHandler('esx_weapon_attachment:addsmgammo', function(hash)
	local xPlayer = ESX.GetPlayerFromId(source)
	local ammo = Config.WeaponAmmoClips.SMGs

	for k,v in pairs(Config.Weapons.SMGs) do
		if (v.weaponHash == hash) then
			xPlayer.addWeaponAmmo(v.weaponName, ammo)
		end
	end

	saveESXPlayer(xPlayer)
end)

RegisterNetEvent('esx_weapon_attachment:addshotgunammo')
AddEventHandler('esx_weapon_attachment:addshotgunammo', function(hash)
	local xPlayer = ESX.GetPlayerFromId(source)
	local ammo = Config.WeaponAmmoClips.Shotguns

	for k,v in pairs(Config.Weapons.Shotguns) do
		if (v.weaponHash == hash) then
			xPlayer.addWeaponAmmo(v.weaponName, ammo)
		end
	end

	saveESXPlayer(xPlayer)
end)

RegisterNetEvent('esx_weapon_attachment:addrifleammo')
AddEventHandler('esx_weapon_attachment:addrifleammo', function(hash)
	local xPlayer = ESX.GetPlayerFromId(source)
	local ammo = Config.WeaponAmmoClips.Rifles

	for k,v in pairs(Config.Weapons.Rifles) do
		if (v.weaponHash == hash) then
			xPlayer.addWeaponAmmo(v.weaponName, ammo)
		end
	end

	saveESXPlayer(xPlayer)
end)

RegisterNetEvent('esx_weapon_attachment:addmgammo')
AddEventHandler('esx_weapon_attachment:addmgammo', function(hash)
	local xPlayer = ESX.GetPlayerFromId(source)
	local ammo = Config.WeaponAmmoClips.MGs

	for k,v in pairs(Config.Weapons.MGs) do
		if (v.weaponHash == hash) then
			xPlayer.addWeaponAmmo(v.weaponName, ammo)
		end
	end

	saveESXPlayer(xPlayer)
end)

RegisterNetEvent('esx_weapon_attachment:addsniperammo')
AddEventHandler('esx_weapon_attachment:addsniperammo', function(hash)
	local xPlayer = ESX.GetPlayerFromId(source)
	local ammo = Config.WeaponAmmoClips.Snipers

	for k,v in pairs(Config.Weapons.Snipers) do
		if (v.weaponHash == hash) then
			xPlayer.addWeaponAmmo(v.weaponName, ammo)
		end
	end

	saveESXPlayer(xPlayer)
end)

RegisterNetEvent('esx_weapon_attachment:addthrowableammo')
AddEventHandler('esx_weapon_attachment:addthrowableammo', function(hash)
	local xPlayer = ESX.GetPlayerFromId(source)
	local ammo = Config.WeaponAmmoClips.Throwables

	for k,v in pairs(Config.Weapons.Throwables) do
		if (v.weaponHash == hash) then
			xPlayer.addWeaponAmmo(v.weaponName, ammo)
		end
	end

	saveESXPlayer(xPlayer)
end)

-- Remove Clip Item
RegisterNetEvent('esx_weapon_attachment:removeweaponclip')
AddEventHandler('esx_weapon_attachment:removeweaponclip', function(type)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if type == 'ammo_small' then
		if Config.Removeables.WeaponClip then
			xPlayer.removeInventoryItem('ammo_small', 1)
		end
	elseif type == 'ammo_box' then
		if Config.Removeables.WeaponBox then
			xPlayer.removeInventoryItem('ammo_box', 1)
		end
	elseif type == 'ammo_pistol' then
		if Config.Removeables.Pistol then
			xPlayer.removeInventoryItem('ammo_pistol', 1)
		end
	elseif type == 'ammo_smg' then
		if Config.Removeables.SMG then
			xPlayer.removeInventoryItem('ammo_smg', 1)
		end
	elseif type == 'ammo_shotgun' then
		if Config.Removeables.Shotgun then
			xPlayer.removeInventoryItem('ammo_shotgun', 1)
		end
	elseif type == 'ammo_rifle' then
		if Config.Removeables.Rifle then
			xPlayer.removeInventoryItem('ammo_rifle', 1)
		end
	elseif type == 'ammo_mg' then
		if Config.Removeables.MG then
			xPlayer.removeInventoryItem('ammo_mg', 1)
		end
	elseif type == 'ammo_sniper' then
		if Config.Removeables.Sniper then
			xPlayer.removeInventoryItem('ammo_sniper', 1)
		end
	elseif type == 'ammo_throwable' then
		if Config.Removeables.Throwables then
			xPlayer.removeInventoryItem('ammo_throwable', 1)
		end
	end
end)

-- Add/Remove Weapon Component
RegisterNetEvent('esx_weapon_attachment:addweaponcomponent')
AddEventHandler('esx_weapon_attachment:addweaponcomponent', function(hash, attachment)
	local xPlayer = ESX.GetPlayerFromId(source)

	for k,v in pairs(Config.Weapons.AllWeapons) do
		if (v.weaponHash == hash) then
			xPlayer.addWeaponComponent(v.weaponName, attachment)
			xPlayer.showNotification(_U('used_attachment'))
		end
	end

	if Config.Removeables.Attachments then
		xPlayer.removeInventoryItem(attachment, 1)
	end

	saveESXPlayer(xPlayer)
end)

RegisterNetEvent('esx_weapon_attachment:removeweaponcomponent')
AddEventHandler('esx_weapon_attachment:removeweaponcomponent', function(hash, attachment)
	local xPlayer = ESX.GetPlayerFromId(source)

	for k,v in pairs(Config.Weapons.AllWeapons) do
		if (v.weaponHash == hash) then
			local hasComponent = xPlayer.hasWeaponComponent(v.weaponName, attachment)

			if hasComponent then
				xPlayer.removeWeaponComponent(v.weaponName, attachment)
				xPlayer.addInventoryItem(attachment, 1)
				
			else 
				xPlayer.showNotification(_U('no_component'))
			end
		end
	end

	saveESXPlayer(xPlayer)
end)

-- Add/Remove Weapon Tints
RegisterNetEvent('esx_weapon_attachment:addweapontint')
AddEventHandler('esx_weapon_attachment:addweapontint', function(hash, tint)
	local xPlayer = ESX.GetPlayerFromId(source)

	for k,v in pairs(Config.Weapons.AllWeapons) do
		if (v.weaponHash == hash) then
			if tint == 'att_tint_green' then
				xPlayer.setWeaponTint(v.weaponName, 1)
			elseif tint == 'att_tint_gold' then
				xPlayer.setWeaponTint(v.weaponName, 2)
			elseif tint == 'att_tint_pink' then
				xPlayer.setWeaponTint(v.weaponName, 3)
			elseif tint == 'att_tint_camouflag' then
				xPlayer.setWeaponTint(v.weaponName, 4)
			elseif tint == 'att_tint_blue' then
				xPlayer.setWeaponTint(v.weaponName, 5)
			elseif tint == 'att_tint_orange' then
				xPlayer.setWeaponTint(v.weaponName, 6)
			elseif tint == 'att_tint_platinum' then
				xPlayer.setWeaponTint(v.weaponName, 7)
			end
		end
	end

	if Config.Removeables.Color then
		xPlayer.removeInventoryItem(tint, 1)
	end
	
	saveESXPlayer(xPlayer)
end)

RegisterNetEvent('esx_weapon_attachment:removeweapontint')
AddEventHandler('esx_weapon_attachment:removeweapontint', function(hash, tint)
	local xPlayer = ESX.GetPlayerFromId(source)

	for k,v in pairs(Config.Weapons.AllWeapons) do
		if (v.weaponHash == hash) then
			if tint then
				xPlayer.addInventoryItem(tint, 1)
			end

			xPlayer.setWeaponTint(v.weaponName, 0)

		end
	end

	saveESXPlayer(xPlayer)
end)

function saveESXPlayer(xPlayer)
	if Config.SavePlayer then
		ESX.SavePlayer(xPlayer)
	end
end
