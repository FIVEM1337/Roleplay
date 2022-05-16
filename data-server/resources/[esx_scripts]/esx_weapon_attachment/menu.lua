ESX = nil
CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(0)
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

RegisterCommand('OpenAttachmentMenu', function()
	TriggerEvent('esx_weapon_attachment:OpenAttachmentMenu')
end)
RegisterKeyMapping('OpenAttachmentMenu', Config.Keymapping_desc, 'keyboard', Config.DefaultOpenKey)

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
				{label = _U('att_scope'), value = 'att_scope'},
				{label = _U('att_grip'), value = 'att_grip'},
				{label = _U('att_flashlight'), value = 'att_flashlight'},
				{label = _U('att_clip_extended'), value = 'att_clip_extended'},
				{label = _U('att_suppressor'), value = 'att_suppressor'},
				{label = _U('att_luxary_finish'), value = 'att_luxary_finish'},
				{label = _U('tint'), value = 'tint'},
			}
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'weapon_attachments', {
				title    = _U('weapon_components'),
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local action = data2.current.value

				if action == 'att_scope' then
					TriggerServerEvent('esx_weapon_attachment:removeweaponcomponent', hash, 'att_scope')
				elseif action == 'att_grip' then
					TriggerServerEvent('esx_weapon_attachment:removeweaponcomponent', hash, 'att_grip')
				elseif action == 'att_flashlight' then
					TriggerServerEvent('esx_weapon_attachment:removeweaponcomponent', hash, 'att_flashlight')
				elseif action == 'att_clip_extended' then
					TriggerServerEvent('esx_weapon_attachment:removeweaponcomponent', hash, 'att_clip_extended')
				elseif action == 'att_suppressor' then
					TriggerServerEvent('esx_weapon_attachment:removeweaponcomponent', hash, 'att_suppressor')
				elseif action == 'att_luxary_finish' then
					TriggerServerEvent('esx_weapon_attachment:removeweaponcomponent', hash, 'att_luxary_finish')
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

CreateThread(function()
	while true do
		if _menuPool:IsAnyMenuOpen() then 
			_menuPool:ProcessMenus()
		else
			_menuPool:CloseAllMenus()
		end
		Wait(1)
	end
end)

local Items = {
	{name = _U('att_scope'), desc = _U('remove_scope'), comtype = 'att_scope', type = 'component'},
	{name = _U('att_grip'), desc = _U('remove_grip'), comtype = 'att_grip', type = 'component'},
	{name = _U('att_flashlight'), desc = _U('remove_flashlight'), comtype = 'att_flashlight', type = 'component'},
	{name = _U('att_clip_extended'), desc = _U('remove_clip_extended'), comtype = 'att_clip_extended', type = 'component'},
	{name = _U('att_suppressor'), desc = _U('remove_suppressor'), comtype = 'att_suppressor', type = 'component'},
	{name = _U('att_luxary_finish'), desc = _U('remove_luxary_finish'), comtype = 'att_luxary_finish', type = 'component'},
	{name = _U('tint'), desc = _U('remove_tint'), type = 'tint'},
}

function OpenAttachmentMenuNativeUI()
	if _menuPool:IsAnyMenuOpen() then
        _menuPool:CloseAllMenus()
        return
    end
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
								tint = 'att_tint_green'
							elseif CurrentTint == 2 then
								tint = 'att_tint_gold'
							elseif CurrentTint == 3 then
								tint = 'att_tint_pink'
							elseif CurrentTint == 4 then
								tint = 'att_tint_camouflag'
							elseif CurrentTint == 5 then
								tint = 'att_tint_blue'
							elseif CurrentTint == 6 then
								tint = 'att_tint_orange'
							elseif CurrentTint == 7 then
								tint = 'att_tint_platinum'
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