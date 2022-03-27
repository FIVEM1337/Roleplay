ESX = nil
CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(0)
	end
end)

-- Check Item for Weapon
RegisterNetEvent('esx_weapon_attachment:checkitem')
AddEventHandler('esx_weapon_attachment:checkitem', function(type)
    local playerPed = PlayerPedId()
	local hash = GetSelectedPedWeapon(playerPed)

	if IsPedArmed(playerPed, 4) then
		if hash ~= nil then
			if Config.CheckMaxAmmo then
				local currentAmmo = GetAmmoInPedWeapon(playerPed, hash)
				
				if type == 'ammo_small' then
            		if currentAmmo + Config.WeaponAmmoClips.WeaponClip <= Config.MaxAmmo then
			    		TriggerServerEvent('esx_weapon_attachment:addweaclip', hash)
			    		TriggerServerEvent('esx_weapon_attachment:removeweaponclip', 'ammo_small')
						ESX.ShowNotification(_U('used_weaclip'))
            		else
                		ESX.ShowNotification(_U('check_maxammo'))
            		end
				elseif type == 'ammo_box' then
					if currentAmmo + Config.WeaponAmmoClips.WeaponBox <= Config.MaxAmmo then
						TriggerServerEvent('esx_weapon_attachment:addweabox', hash)
						TriggerServerEvent('esx_weapon_attachment:removeweaponclip', 'ammo_box')
						ESX.ShowNotification(_U('used_weabox'))
					else
						ESX.ShowNotification(_U('check_maxammo'))
					end
				elseif type == 'ammo_pistol' then
					if currentAmmo + Config.WeaponAmmoClips.Pistols <= Config.MaxAmmo then
						if isPistol(hash) then
							TriggerServerEvent('esx_weapon_attachment:addpistolammo', hash)
							TriggerServerEvent('esx_weapon_attachment:removeweaponclip', 'ammo_pistol')
							ESX.ShowNotification(_U('used_pistol_clip'))
						else
							ESX.ShowNotification(_U('not_correct_weapon'))
						end
					else
						ESX.ShowNotification(_U('check_maxammo'))
					end
				elseif type == 'ammo_smg' then
					if currentAmmo + Config.WeaponAmmoClips.SMGs <= Config.MaxAmmo then
						if isSMG(hash) then
							TriggerServerEvent('esx_weapon_attachment:addsmgammo', hash)
							TriggerServerEvent('esx_weapon_attachment:removeweaponclip', 'ammo_smg')
							ESX.ShowNotification(_U('used_smg_clip'))
						else
							ESX.ShowNotification(_U('not_correct_weapon'))
						end
					else
						ESX.ShowNotification(_U('check_maxammo'))
					end
				elseif type == 'ammo_shotgun' then
					if currentAmmo + Config.WeaponAmmoClips.Shotguns <= Config.MaxAmmo then
						if isShotgun(hash) then
							TriggerServerEvent('esx_weapon_attachment:addshotgunammo', hash)
							TriggerServerEvent('esx_weapon_attachment:removeweaponclip', 'ammo_shotgun')
							ESX.ShowNotification(_U('used_shotgun_clip'))
						else
							ESX.ShowNotification(_U('not_correct_weapon'))
						end
					else
						ESX.ShowNotification(_U('check_maxammo'))
					end
				elseif type == 'ammo_rifle' then
					if currentAmmo + Config.WeaponAmmoClips.Rifles <= Config.MaxAmmo then
						if isRifle(hash) then
							TriggerServerEvent('esx_weapon_attachment:addrifleammo', hash)
							TriggerServerEvent('esx_weapon_attachment:removeweaponclip', 'ammo_rifle')
							ESX.ShowNotification(_U('used_rifle_clip'))
						else
							ESX.ShowNotification(_U('not_correct_weapon'))
						end
					else
						ESX.ShowNotification(_U('check_maxammo'))
					end
				elseif type == 'ammo_mg' then
					if currentAmmo + Config.WeaponAmmoClips.MGs <= Config.MaxAmmo then
						if isMG(hash) then
							TriggerServerEvent('esx_weapon_attachment:addmgammo', hash)
							TriggerServerEvent('esx_weapon_attachment:removeweaponclip', 'ammo_mg')
							ESX.ShowNotification(_U('used_mg_clip'))
						else
							ESX.ShowNotification(_U('not_correct_weapon'))
						end
					else
						ESX.ShowNotification(_U('check_maxammo'))
					end
				elseif type == 'ammo_sniper' then
					if currentAmmo + Config.WeaponAmmoClips.Snipers <= Config.MaxAmmo then
						if isSniper(hash) then
							TriggerServerEvent('esx_weapon_attachment:addsniperammo', hash)
							TriggerServerEvent('esx_weapon_attachment:removeweaponclip', 'ammo_sniper')
							ESX.ShowNotification(_U('used_sniper_clip'))
						else
							ESX.ShowNotification(_U('not_correct_weapon'))
						end
					else
						ESX.ShowNotification(_U('check_maxammo'))
					end
				elseif type == 'ammo_throwable' then
					if currentAmmo + Config.WeaponAmmoClips.Throwables <= Config.MaxAmmo then
						if isThrowable(hash) then
							TriggerServerEvent('esx_weapon_attachment:addthrowableammo', hash)
							TriggerServerEvent('esx_weapon_attachment:removeweaponclip', 'ammo_throwable')
							ESX.ShowNotification(_U('used_throwables_clip'))
						else
							ESX.ShowNotification(_U('not_correct_weapon'))
						end
					else
						ESX.ShowNotification(_U('check_maxammo'))
					end
				end
			else
				if type == 'ammo_small' then
			    	TriggerServerEvent('esx_weapon_attachment:addweaclip', hash)
			    	TriggerServerEvent('esx_weapon_attachment:removeweaponclip', 'ammo_small')
					ESX.ShowNotification(_U('used_weaclip'))
				elseif type == 'ammo_box' then
					TriggerServerEvent('esx_weapon_attachment:addweabox', hash)
					TriggerServerEvent('esx_weapon_attachment:removeweaponclip', 'ammo_box')
					ESX.ShowNotification(_U('used_weabox'))
				elseif type == 'ammo_pistol' then
					if isPistol(hash) then
						TriggerServerEvent('esx_weapon_attachment:addpistolammo', hash)
						TriggerServerEvent('esx_weapon_attachment:removeweaponclip', 'ammo_pistol')
						ESX.ShowNotification(_U('used_pistol_clip'))
					else
						ESX.ShowNotification(_U('not_correct_weapon'))
					end
				elseif type == 'ammo_smg' then
					if isSMG(hash) then
						TriggerServerEvent('esx_weapon_attachment:addsmgammo', hash)
						TriggerServerEvent('esx_weapon_attachment:removeweaponclip', 'ammo_smg')
						ESX.ShowNotification(_U('used_smg_clip'))
					else
						ESX.ShowNotification(_U('not_correct_weapon'))
					end
				elseif type == 'ammo_shotgun' then
					if isShotgun(hash) then
						TriggerServerEvent('esx_weapon_attachment:addshotgunammo', hash)
						TriggerServerEvent('esx_weapon_attachment:removeweaponclip', 'ammo_shotgun')
						ESX.ShowNotification(_U('used_shotgun_clip'))
					else
						ESX.ShowNotification(_U('not_correct_weapon'))
					end
				elseif type == 'ammo_rifle' then
					if isRifle(hash) then
						TriggerServerEvent('esx_weapon_attachment:addrifleammo', hash)
						TriggerServerEvent('esx_weapon_attachment:removeweaponclip', 'ammo_rifle')
						ESX.ShowNotification(_U('used_rifle_clip'))
					else
						ESX.ShowNotification(_U('not_correct_weapon'))
					end
				elseif type == 'ammo_mg' then
					if isMG(hash) then
						TriggerServerEvent('esx_weapon_attachment:addmgammo', hash)
						TriggerServerEvent('esx_weapon_attachment:removeweaponclip', 'ammo_mg')
						ESX.ShowNotification(_U('used_mg_clip'))
					else
						ESX.ShowNotification(_U('not_correct_weapon'))
					end
				elseif type == 'ammo_sniper' then
					if isSniper(hash) then
						TriggerServerEvent('esx_weapon_attachment:addsniperammo', hash)
						TriggerServerEvent('esx_weapon_attachment:removeweaponclip', 'ammo_sniper')
						ESX.ShowNotification(_U('used_sniper_clip'))
					else
						ESX.ShowNotification(_U('not_correct_weapon'))
					end
				elseif type == 'ammo_throwable' then
					if isThrowable(hash) then
						TriggerServerEvent('esx_weapon_attachment:addthrowableammo', hash)
						TriggerServerEvent('esx_weapon_attachment:removeweaponclip', 'ammo_throwable')
						ESX.ShowNotification(_U('used_throwables_clip'))
					else
						ESX.ShowNotification(_U('not_correct_weapon'))
					end
				end
			end
		else
			ESX.ShowNotification(_U('no_weapon'))
		end
	else
		ESX.ShowNotification(_U('not_correct_weapon'))
	end
end)

RegisterNetEvent('esx_weapon_attachment:addattachment')
AddEventHandler('esx_weapon_attachment:addattachment', function(attachment)
	local playerPed = PlayerPedId()
	local hash = GetSelectedPedWeapon(playerPed)
	
	if IsPedArmed(playerPed, 4) then
		if hash ~= nil then
			for k,v in pairs(Config.Weapons.AllWeapons) do
				if (v.weaponHash == hash) then
					local weaponComponent = ESX.GetWeaponComponent(v.weaponName, attachment)
					debug(weaponComponent)
					if weaponComponent == nil then
						debug('Can not take component')

						ESX.ShowNotification(_U('not_correct_component'))
					else
						local componentHash = weaponComponent.hash
						debug('WeaponHash: ' .. componentHash)
						debug('ComponentHash: '.. componentHash)
						debug('Can take component: '.. componentHash)

						if HasPedGotWeaponComponent(playerPed, hash, componentHash) then
							ESX.ShowNotification(_U('component_already_equipped'))
							return
						end

						TriggerServerEvent('esx_weapon_attachment:addweaponcomponent', hash, attachment)
					end
				end
			end
		else
			ESX.ShowNotification(_U('no_weapon'))
		end
	end
end)

RegisterNetEvent('esx_weapon_attachment:addtint')
AddEventHandler('esx_weapon_attachment:addtint', function(tint)
	local playerPed = PlayerPedId()
	local hash = GetSelectedPedWeapon(playerPed)
	
	if IsPedArmed(playerPed, 4) then
		if hash ~= nil then
			local newtintindex
			if tint == 'att_tint_green' then
				newtintindex = 1
			elseif tint == 'att_tint_gold' then
				newtintindex = 2
			elseif tint == 'att_tint_pink' then
				newtintindex = 3
			elseif tint == 'att_tint_camouflag' then
				newtintindex = 4
			elseif tint == 'att_tint_blue' then
				newtintindex = 5
			elseif tint == 'att_tint_orange' then
				newtintindex = 6
			elseif tint == 'att_tint_platinum' then
				newtintindex = 7
			end

			if newtintindex == GetPedWeaponTintIndex(playerPed, hash) then
				ESX.ShowNotification(_U('tint_already_equipped'))
			else
				TriggerServerEvent('esx_weapon_attachment:addweapontint', hash, tint)
			end
		else
			ESX.ShowNotification(_U('no_weapon'))
		end
	end
end)

function debug(msg)
	if Config.Debug then
		print(msg)
	end
end

function isPistol()
	local playerPed = PlayerPedId()
    for _,Pistol in pairs(Config.Weapons.Pistols) do
        if (Pistol.weaponHash == GetSelectedPedWeapon(playerPed)) then
            return true
        end
    end
    return false
end

function isSMG()
	local playerPed = PlayerPedId()
	for _,SMG in pairs(Config.Weapons.SMGs) do
		if (SMG.weaponHash == GetSelectedPedWeapon(playerPed)) then
			return true
		end
	end
	return false
end

function isShotgun()
	local playerPed = PlayerPedId()
	for _,Shotgun in pairs(Config.Weapons.Shotguns) do
		if (Shotgun.weaponHash == GetSelectedPedWeapon(playerPed)) then
			return true
		end
	end
	return false
end

function isRifle()
	local playerPed = PlayerPedId()
	for _,Rifle in pairs(Config.Weapons.Rifles) do
		if (Rifle.weaponHash == GetSelectedPedWeapon(playerPed)) then
			return true
		end
	end
	return false
end

function isMG()
	local playerPed = PlayerPedId()
	for _,MG in pairs(Config.Weapons.MGs) do
		if (MG.weaponHash == GetSelectedPedWeapon(playerPed)) then
			return true
		end
	end
	return false
end

function isSniper()
	local playerPed = PlayerPedId()
	for _,Sniper in pairs(Config.Weapons.Snipers) do
		if (Sniper.weaponHash == GetSelectedPedWeapon(playerPed)) then
			return true
		end
	end
	return false
end

function isThrowable()
	local playerPed = PlayerPedId()
	for _,Throwable in pairs(Config.Weapons.Flares) do
		if (Throwable.weaponHash == GetSelectedPedWeapon(playerPed)) then
			return true
		end
	end
	return false
end