ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx_weapon_attachment:OpenAttachmentMenu')
AddEventHandler('esx_weapon_attachment:OpenAttachmentMenu', function()
	if Config.Menu:match('ESX') then
		OpenAttachmentMenuESX() -- ESX Menu
	elseif Config.Menu:match('NativeUI') then
		OpenAttachmentMenuNativeUI() -- NativeUI
	end
end)

function OpenAttachmentMenuESX()
	local playerPed = PlayerPedId()
	local hash = GetSelectedPedWeapon(playerPed)

	local elements = {
		{label = _U('weapon_components'), value = 'components'},
	}
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'components', {
		title    = _U('weapon_components'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'components' then
			local elements = {
				{label = _U('scope'), value = 'scope'},
				{label = _U('grip'), value = 'grip'},
				{label = _U('flashlight'), value = 'flashlight'},
				{label = _U('clip_extended'), value = 'clip_extended'},
				{label = _U('suppressor'), value = 'suppressor'},
				{label = _U('luxary_finish'), value = 'luxary_finish'},
				{label = _U('tint'), value = 'tint'},
			}
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'weapon_attachments', {
				title    = _U('weapon_components'),
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local action = data2.current.value

				if action == 'scope' then
					TriggerServerEvent('esx_weapon_attachment:removeweaponcomponent', hash, 'scope')
				elseif action == 'grip' then
					TriggerServerEvent('esx_weapon_attachment:removeweaponcomponent', hash, 'grip')
				elseif action == 'flashlight' then
					TriggerServerEvent('esx_weapon_attachment:removeweaponcomponent', hash, 'flashlight')
				elseif action == 'clip_extended' then
					TriggerServerEvent('esx_weapon_attachment:removeweaponcomponent', hash, 'clip_extended')
				elseif action == 'suppressor' then
					TriggerServerEvent('esx_weapon_attachment:removeweaponcomponent', hash, 'suppressor')
				elseif action == 'luxary_finish' then
					TriggerServerEvent('esx_weapon_attachment:removeweaponcomponent', hash, 'luxary_finish')
				elseif action == 'tint' then
					TriggerServerEvent('esx_weapon_attachment:removeweapontint', hash)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

-- NativeUI
_menuPool = NativeUI.CreatePool()
local mainMenu

Citizen.CreateThread(function()
	while true do
		if _menuPool:IsAnyMenuOpen() then 
			_menuPool:ProcessMenus()
		else
			_menuPool:CloseAllMenus()
		end
		Citizen.Wait(1)
	end
end)

local Items = {
	{name = _U('scope'), desc = _U('remove_scope'), comtype = 'scope', type = 'component'},
	{name = _U('grip'), desc = _U('remove_grip'), comtype = 'grip', type = 'component'},
	{name = _U('flashlight'), desc = _U('remove_flashlight'), comtype = 'flashlight', type = 'component'},
	{name = _U('clip_extended'), desc = _U('remove_clip_extended'), comtype = 'clip_extended', type = 'component'},
	{name = _U('suppressor'), desc = _U('remove_suppressor'), comtype = 'suppressor', type = 'component'},
	{name = _U('luxary_finish'), desc = _U('remove_luxary_finish'), comtype = 'luxary_finish', type = 'component'},
	{name = _U('tint'), desc = _U('remove_tint'), type = 'tint'},
}

function OpenAttachmentMenuNativeUI()
	local playerPed = PlayerPedId()
	local hash = GetSelectedPedWeapon(playerPed)

	if mainMenu ~= nil and mainMenu:Visible() then
		mainMenu:Visible(false)
	end

	_menuPool:Remove()


	mainMenu = NativeUI.CreateMenu(_U('weapon_components'), '~b~'.. _U('remove_components'))
	_menuPool:Add(mainMenu)

	for k,v in pairs(Items) do
		for k,v2 in pairs(Config.Weapons.AllWeapons) do
			if (v2.weaponHash == hash) then
				local CurrentTint = GetPedWeaponTintIndex(playerPed, hash)
				local weaponComponent = ESX.GetWeaponComponent(v2.weaponName, v.comtype)
				local hasComponent
				
				if weaponComponent then
					hasComponent = HasPedGotWeaponComponent(playerPed, hash, weaponComponent.hash)
				end
				
				if v.type == 'tint' and CurrentTint ~= 0 or hasComponent then
					local ComponentList = NativeUI.CreateItem(v.name, '~b~'.. v.desc)
					mainMenu:AddItem(ComponentList)
					added = true
					ComponentList.Activated = function(sender, index)
						if v.type == 'component' then
							TriggerServerEvent('esx_weapon_attachment:removeweaponcomponent', hash, v.comtype)
							mainMenu:Visible(false)
							Wait(100)
							TriggerEvent('esx_weapon_attachment:OpenAttachmentMenu')
						elseif v.type == 'tint' then
							local CurrentTint = GetPedWeaponTintIndex(playerPed, hash)

							local tint = nil
							if CurrentTint == 1 then
								tint = 'tint_green'
							elseif CurrentTint == 2 then
								tint = 'tint_gold'
							elseif CurrentTint == 3 then
								tint = 'tint_pink'
							elseif CurrentTint == 4 then
								tint = 'tint_army'
							elseif CurrentTint == 5 then
								tint = 'tint_lspd'
							elseif CurrentTint == 6 then
								tint = 'tint_orange'
							elseif CurrentTint == 7 then
								tint = 'tint_platinum'
							end

							TriggerServerEvent('esx_weapon_attachment:removeweapontint', hash, tint)
							mainMenu:Visible(false)
							Wait(100)
							TriggerEvent('esx_weapon_attachment:OpenAttachmentMenu')
						end
					end
				end
			end
		end
	end



	mainMenu:Visible(true)
	_menuPool:RefreshIndex()
	_menuPool:MouseControlsEnabled(false)
	_menuPool:MouseEdgeEnabled(false)
	_menuPool:ControlDisablingEnabled(false)
end