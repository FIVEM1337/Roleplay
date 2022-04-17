local _menuPool                 = NativeUI.CreatePool()
local PlayerUI                  = nil
local handsup = false
local mp_pointing = false
local keyPressed = false


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


RegisterCommand('handsup', function()
    local ped = PlayerPedId()
    if IsEntityDead(ped) then 
        return
    end

    if IsPedInAnyVehicle(ped, false) then 
        return
    end 

    if not handsup then
        handsup = true

        LoadAnimDict('missminuteman_1ig_2')
        TaskPlayAnim(ped, "missminuteman_1ig_2", "handsup_enter", 8.0, 8.0, -1, 50, 0, false, false, false)
    else 
        ClearPedTasks(ped)
        handsup = false
    end
end)
RegisterKeyMapping('handsup', 'Hände hoch/runter', 'keyboard', Config.HandsupKey)


function LoadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(0)
	end
end

local function startPointing()
    local ped = GetPlayerPed(-1)
    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do
        Wait(0)
    end
    SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
    SetPedConfigFlag(ped, 36, 1)
    Citizen.InvokeNative(0x2D537BA194896636, ped, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
    RemoveAnimDict("anim@mp_point")
end

local function stopPointing()
    local ped = GetPlayerPed(-1)
    Citizen.InvokeNative(0xD01015C7316AE176, ped, "Stop")
    if not IsPedInjured(ped) then
        ClearPedSecondaryTask(ped)
    end
    if not IsPedInAnyVehicle(ped, 1) then
        SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
    end
    SetPedConfigFlag(ped, 36, 0)
    ClearPedSecondaryTask(PlayerPedId())
end

local once = true
local oldval = false
local oldvalped = false

Citizen.CreateThread(function()
    while true do
        Wait(0)

        if once then
            once = false
        end

        if not keyPressed then
            if IsControlPressed(0, 29) and not mp_pointing and IsPedOnFoot(PlayerPedId()) then
                Wait(200)
                if not IsControlPressed(0, 29) then
                    keyPressed = true
                    startPointing()
                    mp_pointing = true
                else
                    keyPressed = true
                    while IsControlPressed(0, 29) do
                        Wait(50)
                    end
                end
            elseif (IsControlPressed(0, 29) and mp_pointing) or (not IsPedOnFoot(PlayerPedId()) and mp_pointing) then
                keyPressed = true
                mp_pointing = false
                stopPointing()
            end
        end

        if keyPressed then
            if not IsControlPressed(0, 29) then
                keyPressed = false
            end
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) and not mp_pointing then
            stopPointing()
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) then
            if not IsPedOnFoot(PlayerPedId()) then
                stopPointing()
            else
                local ped = GetPlayerPed(-1)
                local camPitch = GetGameplayCamRelativePitch()
                if camPitch < -70.0 then
                    camPitch = -70.0
                elseif camPitch > 42.0 then
                    camPitch = 42.0
                end
                camPitch = (camPitch + 70.0) / 112.0

                local camHeading = GetGameplayCamRelativeHeading()
                local cosCamHeading = Cos(camHeading)
                local sinCamHeading = Sin(camHeading)
                if camHeading < -180.0 then
                    camHeading = -180.0
                elseif camHeading > 180.0 then
                    camHeading = 180.0
                end
                camHeading = (camHeading + 180.0) / 360.0

                local blocked = 0
                local nn = 0

                local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
                local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7);
                nn,blocked,coords,coords = GetRaycastResult(ray)

                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Pitch", camPitch)
                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Heading", camHeading * -1.0 + 1.0)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isBlocked", blocked)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)

            end
        end
    end
end)