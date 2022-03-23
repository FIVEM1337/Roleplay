-- Usable Items
ESX.RegisterUsableItem('weaclip', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:checkitem', source, 'weaclip')
end)

ESX.RegisterUsableItem('weabox', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerClientEvent('esx_weapon_attachment:checkitem', source, 'weabox')
end)

ESX.RegisterUsableItem('pistolclip', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:checkitem', source, 'pistolclip')
end)

ESX.RegisterUsableItem('smgclip', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:checkitem', source, 'smgclip')
end)

ESX.RegisterUsableItem('shotgunclip', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:checkitem', source, 'shotgunclip')
end)

ESX.RegisterUsableItem('rifleclip', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:checkitem', source, 'rifleclip')
end)

ESX.RegisterUsableItem('mgclip', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:checkitem', source, 'mgclip')
end)

ESX.RegisterUsableItem('sniperclip', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:checkitem', source, 'sniperclip')
end)

ESX.RegisterUsableItem('throwableclip', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:checkitem', source, 'throwableclip')
end)

-- Attachments
ESX.RegisterUsableItem('scope', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:addattachment', source, 'scope')
end)

ESX.RegisterUsableItem('grip', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:addattachment', source, 'grip')
end)

ESX.RegisterUsableItem('flashlight', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:addattachment', source, 'flashlight')
end)

ESX.RegisterUsableItem('clip_extended', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:addattachment', source, 'clip_extended')
end)

ESX.RegisterUsableItem('suppressor', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:addattachment', source, 'suppressor')
end)

ESX.RegisterUsableItem('luxary_finish', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:addattachment', source, 'luxary_finish')
end)

-- Tints
ESX.RegisterUsableItem('tint_green', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:addtint', source, 'tint_green')
end)

ESX.RegisterUsableItem('tint_gold', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:addtint', source, 'tint_gold')
end)

ESX.RegisterUsableItem('tint_pink', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:addtint', source, 'tint_pink')
end)

ESX.RegisterUsableItem('tint_army', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:addtint', source, 'tint_army')
end)

ESX.RegisterUsableItem('tint_lspd', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:addtint', source, 'tint_lspd')
end)

ESX.RegisterUsableItem('tint_orange', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:addtint', source, 'tint_orange')
end)

ESX.RegisterUsableItem('tint_platinum', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerClientEvent('esx_weapon_attachment:addtint', source, 'tint_platinum')
end)

-- Remover
ESX.RegisterUsableItem('attachment_remover', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerClientEvent('esx_weapon_attachment:OpenAttachmentMenu', source)
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

	if type == 'weaclip' then
		if Config.Removeables.WeaponClip then
			xPlayer.removeInventoryItem('weaclip', 1)
		end
	elseif type == 'weabox' then
		if Config.Removeables.WeaponBox then
			xPlayer.removeInventoryItem('weabox', 1)
		end
	elseif type == 'pistolclip' then
		if Config.Removeables.Pistol then
			xPlayer.removeInventoryItem('pistolclip', 1)
		end
	elseif type == 'smgclip' then
		if Config.Removeables.SMG then
			xPlayer.removeInventoryItem('smgclip', 1)
		end
	elseif type == 'shotgunclip' then
		if Config.Removeables.Shotgun then
			xPlayer.removeInventoryItem('shotgunclip', 1)
		end
	elseif type == 'rifleclip' then
		if Config.Removeables.Rifle then
			xPlayer.removeInventoryItem('rifleclip', 1)
		end
	elseif type == 'mgclip' then
		if Config.Removeables.MG then
			xPlayer.removeInventoryItem('mgclip', 1)
		end
	elseif type == 'sniperclip' then
		if Config.Removeables.Sniper then
			xPlayer.removeInventoryItem('sniperclip', 1)
		end
	elseif type == 'throwableclip' then
		if Config.Removeables.Throwables then
			xPlayer.removeInventoryItem('throwableclip', 1)
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
				xPlayer.showNotification(_U('used_attachment_remover'))
				xPlayer.addInventoryItem(attachment, 1)
				
				if Config.Removeables.Attachment_Remover then
					xPlayer.removeInventoryItem('attachment_remover', 1)
				end
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
			if tint == 'tint_green' then
				xPlayer.setWeaponTint(v.weaponName, 1)
			elseif tint == 'tint_gold' then
				xPlayer.setWeaponTint(v.weaponName, 2)
			elseif tint == 'tint_pink' then
				xPlayer.setWeaponTint(v.weaponName, 3)
			elseif tint == 'tint_army' then
				xPlayer.setWeaponTint(v.weaponName, 4)
			elseif tint == 'tint_lspd' then
				xPlayer.setWeaponTint(v.weaponName, 5)
			elseif tint == 'tint_orange' then
				xPlayer.setWeaponTint(v.weaponName, 6)
			elseif tint == 'tint_platinum' then
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
			xPlayer.showNotification(_U('used_attachment_remover'))

			if Config.Removeables.Attachment_Remover then
				xPlayer.removeInventoryItem('attachment_remover', 1)
			end
		end
	end

	saveESXPlayer(xPlayer)
end)

function saveESXPlayer(xPlayer)
	if Config.SavePlayer then
		ESX.SavePlayer(xPlayer)
	end
end
