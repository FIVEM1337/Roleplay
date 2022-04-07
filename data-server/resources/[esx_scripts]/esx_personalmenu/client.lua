local _menuPool                 = NativeUI.CreatePool()
local PlayerUI                  = nil


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

RegisterCommand('OpenPlayerMenu', function()
    RenderMenu()
end, false)


function RenderMenu()
    _menuPool:CloseAllMenus()
	if PlayerUI ~= nil and PlayerUI:Visible() then
		PlayerUI:Visible(false)
	end


    PlayerUI = NativeUI.CreateMenu(_U('menu_title'), "", Config.MenuPosition, Config.MenuPosition)
    _menuPool:Add(PlayerUI)

	if not rawequal(next(Config.Wallet), nil) then
        wallet = _menuPool:AddSubMenu(PlayerUI, _U('wallet_title'), "")
        for k, v in pairs(Config.Wallet) do
            Item = CreateItem(v)
			wallet.SubMenu:AddItem(Item)
            _menuPool:RefreshIndex()

            Item.OnListSelected = function(menu, item, newindex)
                v.command(menu, item, newindex)
            end

            Item.Activated = function(sender, index)
                v.command(sender, index)
            end
        end
    end

    billing = _menuPool:AddSubMenu(PlayerUI, _U('bills_title'), "")
    ESX.TriggerServerCallback('esx_personalmenu:getBills', function(bills)
        for k, v in pairs(bills) do
            Item = NativeUI.CreateItem(v.label.." ~r~$"..ESX.Math.GroupDigits(v.amount).."~s~", "")
            billing.SubMenu:AddItem(Item)
            _menuPool:RefreshIndex()

            Item.Activated = function(sender, index)
                ESX.TriggerServerCallback('esx_billing:payBill', function()
                    RenderMenu()
                end, v.id)
            end
        end
    end)

	if not rawequal(next(Config.Vehicle), nil) then
        vehicle = _menuPool:AddSubMenu(PlayerUI, _U('vehicle_title'), "")
        for k, v in pairs(Config.Vehicle) do
            Item = CreateItem(v)
			vehicle.SubMenu:AddItem(Item)
            _menuPool:RefreshIndex()

            Item.OnListSelected = function(menu, item, newindex)
                v.command(menu, item, newindex)
            end

            Item.Activated = function(sender, index)
                v.command(sender, index)
            end
        end
    end


    ESX.TriggerServerCallback('esx_personalmenu:getUserGroup', function(plyGroup)
        if plyGroup ~= nil and (plyGroup == 'mod' or plyGroup == 'admin' or plyGroup == 'superadmin' or plyGroup == 'owner' or plyGroup == '_dev') then
            if not rawequal(next(Config.Admin), nil) then
                admin = _menuPool:AddSubMenu(PlayerUI, _U('admin_title'), "")
                for k, v in pairs(Config.Admin) do
                    local authorized = false
                    for k, v in pairs(v.groups) do
                        if v == plyGroup then
                            authorized = true
                            break
                        end
                    end

                    if authorized then
                        Item = CreateItem(v)
                        admin.SubMenu:AddItem(Item)
                        _menuPool:RefreshIndex()
            
                        Item.OnListSelected = function(menu, item, newindex)
                            v.command(menu, item, newindex)
                        end
            
                        Item.Activated = function(sender, index)
                            v.command(sender, index)
                        end
                        _menuPool:RefreshIndex()
                        _menuPool:MouseControlsEnabled(false)
                        _menuPool:MouseEdgeEnabled(false)
                        _menuPool:ControlDisablingEnabled(false)
                    end
                end
            end
        end
    end)

    PlayerUI:Visible(true)
	_menuPool:RefreshIndex()
	_menuPool:MouseControlsEnabled(false)
	_menuPool:MouseEdgeEnabled(false)
	_menuPool:ControlDisablingEnabled(false)
end
RegisterKeyMapping('OpenPlayerMenu', _U('control_label'), 'keyboard', Config.OpenKey)


function CreateItem(config)
    local item
    if config.list then
        item = NativeUI.CreateListItem(_U(config.label), config.list, 0)
    else
        item = NativeUI.CreateItem(_U(config.label), "")
    end
    return item
end


CreateThread(function()
	while true do
		plyPed = PlayerPedId()

		if Player.noclip then
			local plyCoords = GetEntityCoords(plyPed, false)
			local camCoords = getCamDirection()
			SetEntityVelocity(plyPed, 0.01, 0.01, 0.01)

			if IsControlPressed(0, 32) then
				plyCoords = plyCoords + (Config.NoclipSpeed * camCoords)
			end

			if IsControlPressed(0, 269) then
				plyCoords = plyCoords - (Config.NoclipSpeed * camCoords)
			end

            if IsControlPressed(0, 172) or IsControlPressed(0, 15) then
                if Config.NoclipSpeed <= 5.0 then
                else
                    Config.NoclipSpeed = Config.NoclipSpeed + 0.05
                end
			end
            
            if IsControlPressed(0, 173) or IsControlPressed(0, 14) then
                if Config.NoclipSpeed <= 0.5 then
                else
                    Config.NoclipSpeed = Config.NoclipSpeed - 0.05
                end
			end
            
			SetEntityCoordsNoOffset(plyPed, plyCoords, true, true, true)
		end

		Wait(0)
	end
end)

-- Admin Menu --
RegisterNetEvent('esx_personalmen2u:BringPlayer')
AddEventHandler('esx_personalmenu:BringPlayer', function(plyCoords)
	SetEntityCoords(plyPed, plyCoords)
end)


function getCamDirection()
	local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(plyPed)
	local pitch = GetGameplayCamRelativePitch()
	local coords = vector3(-math.sin(heading * math.pi / 180.0), math.cos(heading * math.pi / 180.0), math.sin(pitch * math.pi / 180.0))
	local len = math.sqrt((coords.x * coords.x) + (coords.y * coords.y) + (coords.z * coords.z))

	if len ~= 0 then
		coords = coords / len
	end

	return coords
end


function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
	AddTextEntry(entryTitle, textEntry)
	DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Wait(500)
		blockinput = false
		return result
	else
		Wait(500)
		blockinput = false
		return nil
	end
end

AddEventHandler('esx:onPlayerDeath', function()
	Player.isDead = true
    _menuPool:CloseAllMenus()
end)

AddEventHandler('playerSpawned', function()
	Player.isDead = false
end)