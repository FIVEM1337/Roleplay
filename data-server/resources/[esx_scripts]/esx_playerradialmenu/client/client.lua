local _menuPool = NativeUI.CreatePool()
local BodySearchMenu = nil
local inRadialMenu = false
local PlayerData = {}
local jobIndex = nil
local vehicleIndex = nil
local citzenIndex = nil

local DynamicMenuItems = {}
local FinalMenuItems = {}


local dragStatus = {}
local isHandcuffed = false

local vehicle_windows = {{window_index = 0, status = true}, {window_index = 1, status = true}, {window_index = 2, status = true}, {window_index = 3, status = true}, {window_index = 4, status = true}, {window_index = 5, status = true}, {window_index = 6, status = true}, {window_index = 7, status = true},}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = ESX.GetPlayerData()
    TriggerServerEvent('esx_playerradialmenu:ishandcuffed')
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData = ESX.GetPlayerData()
end)

CreateThread(function()
    Wait(1)
	while PlayerData.job == nil do
		PlayerData = ESX.GetPlayerData()
		Wait(100)
	end
end)

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

local function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if not orig.canOpen or orig.canOpen() then
            local toRemove = {}
            copy = {}
            for orig_key, orig_value in next, orig, nil do
                if type(orig_value) == 'table' then
                    if not orig_value.canOpen or orig_value.canOpen() then
                        copy[deepcopy(orig_key)] = deepcopy(orig_value)
                    else
                        toRemove[orig_key] = true
                    end
                else
                    copy[deepcopy(orig_key)] = deepcopy(orig_value)
                end
            end
            for i=1, #toRemove do table.remove(copy, i) --[[ Using this to make sure all indexes get re-indexed and no empty spaces are in the radialmenu ]] end
            if copy and next(copy) then setmetatable(copy, deepcopy(getmetatable(orig))) end
        end
    elseif orig_type ~= 'function' then
        copy = orig
    end
    return copy
end

local function AddOption(data, id)
    local menuID = id ~= nil and id or (#DynamicMenuItems + 1)
    DynamicMenuItems[menuID] = deepcopy(data)
    return menuID
end

local function RemoveOption(id)
    DynamicMenuItems[id] = nil
end

local function SetupJobMenu()
    local JobMenu = {
        id = 'jobinteractions',
        title = 'Arbeit',
        icon = 'briefcase',
        items = {}
    }
    if Config.JobInteractions[PlayerData.job.name] and next(Config.JobInteractions[PlayerData.job.name]) then
        JobMenu.items = Config.JobInteractions[PlayerData.job.name]
    end

    if #JobMenu.items == 0 then
        if jobIndex then
            RemoveOption(jobIndex)
            jobIndex = nil
        end
    else
        jobIndex = AddOption(JobMenu, jobIndex)
    end
end

local function SetupVehicleMenu()
    local VehicleMenu = {
        id = 'vehicle',
        title = 'Fahrzeug',
        icon = 'car',
        items = {}
    }

    local ped = PlayerPedId()
    local Vehicle = GetVehiclePedIsIn(ped)
    if Vehicle ~= 0 then
        VehicleMenu.items = Config.Vehicle
    end

    if #VehicleMenu.items == 0 then
        if vehicleIndex then
            RemoveOption(vehicleIndex)
            vehicleIndex = nil
        end
    else
        vehicleIndex = AddOption(VehicleMenu, vehicleIndex)
    end
end

local function SetupCizesMenu()
    local CitzenMenu = {
        id = 'vehicle',
        title = 'Personen Interaktionen',
        icon = 'person',
        items = {}
    }

    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        CitzenMenu.items = Config.Citzen
    end

    if #CitzenMenu.items == 0 then
        if citzenIndex then
            RemoveOption(citzenIndex)
            citzenIndex = nil
        end
    else
        citzenIndex = AddOption(CitzenMenu, citzenIndex)
    end
end

local function SetupSubItems()
    if PlayerData and PlayerData.job then
    --    SetupJobMenu()
        SetupVehicleMenu()
        SetupCizesMenu()
    end
end

local function selectOption(t, t2)
    for k, v in pairs(t) do
        if v.items then
            local found, hasAction, val = selectOption(v.items, t2)
            if found then return true, hasAction, val end
        else
            if v.id == t2.id and ((v.event and v.event == t2.event) or v.action) and (not v.canOpen or v.canOpen()) then
                return true, v.action, v
            end
        end
    end
    return false
end

local function SetupRadialMenu()
    FinalMenuItems = {}
    SetupSubItems()
    FinalMenuItems = deepcopy(Config.MenuItems)
    for _, v in pairs(DynamicMenuItems) do
        FinalMenuItems[#FinalMenuItems+1] = v
    end
end

local function setRadialState(state, sendMessage, delay)
    if state then
        SetupRadialMenu()
    end

    SetNuiFocus(state, state)
    if sendMessage then
        SendNUIMessage({
            action = "ui",
            radial = state,
            items = FinalMenuItems
        })
    end

    if delay then
        Wait(500) 
    end

    inRadialMenu = state
end

-- Command
RegisterCommand('radialmenu', function()
    if not IsPauseMenuActive() and not inRadialMenu then 
        setRadialState(true, true)
        SetCursorLocation(0.5, 0.5)
    end
end)
RegisterKeyMapping('radialmenu', _U('command_description'), 'keyboard', Config.Key)


-- NUI Callbacks
RegisterNUICallback('closeRadial', function(data)
    setRadialState(false, false, data.delay)
end)

RegisterNUICallback('selectItem', function(data)
    local itemData = data.itemData
    local found, action, data = selectOption(FinalMenuItems, itemData)

    if data and found then
        if action then
            action(data)
        elseif data.type == 'client' then
            TriggerEvent(data.event, data)
        elseif data.type == 'server' then
            TriggerServerEvent(data.event, data)
        elseif data.type == 'command' then
            ExecuteCommand(data.event)
        end
    end
end)

RegisterNetEvent('esx_playerradialmenu:idcard')
AddEventHandler('esx_playerradialmenu:idcard', function(data)
    if data.args[1] then
        TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), data.args[2])
    else
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

        if closestPlayer ~= -1 and closestDistance <= 3.0 then
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), data.args[2])
        else
            TriggerEvent('dopeNotify:Alert', "", _U('no_players_nearby'), 5000, 'error')
        end	
    end
end)

RegisterNetEvent('esx_playerradialmenu:bodysearch_trigger')
AddEventHandler('esx_playerradialmenu:bodysearch_trigger', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        ESX.TriggerServerCallback('esx_playerradialmenu:getOtherPlayerData', function(data)
			if data then
				OpenBodySearchMenu(closestPlayer, data)
                SetCursorLocation(0.5, 0.5)
			else
				TriggerEvent('dopeNotify:Alert', "", _U('player_not_found'), 5000, 'error')
			end
		end, GetPlayerServerId(closestPlayer))
    else
        TriggerEvent('dopeNotify:Alert', "", _U('no_players_nearby'), 5000, 'error')
    end
end)

function OpenBodySearchMenu(player, data)
    _menuPool:CloseAllMenus()
	if BodySearchMenu ~= nil and BodySearchMenu:Visible() then
		BodySearchMenu:Visible(false)
	end

	BodySearchMenu = NativeUI.CreateMenu("Spieler Inventar", nil, nil)
	_menuPool:Add(BodySearchMenu)

	local weaponlabel, standartlabel, accountlabel

	for k, v in ipairs(data.accounts) do
		if not accountlabel then
			Item = NativeUI.CreateItem(_U('account_label'), "")
			accountlabel = true
			BodySearchMenu:AddItem(Item)
		end

		if v.name == 'black_money' and v.money > 0 then
			Item = NativeUI.CreateItem(_U('confiscate_dirty', ESX.Math.Round(v.money)), "")
			BodySearchMenu:AddItem(Item)

			Item.Activated = function(sender, index)
				Confiscate(player, v.name, 'item_account', v.money)
			end
		end
	end

	for k, v in ipairs(data.weapons) do
		if not weaponlabel then
			Item = NativeUI.CreateItem(_U('guns_label'), "")
			weaponlabel = true
			BodySearchMenu:AddItem(Item)
		end
		Item = NativeUI.CreateItem(_U('confiscate_weapon', ESX.GetWeaponLabel(v.name), v.ammo), "")
		BodySearchMenu:AddItem(Item)

		Item.Activated = function(sender, index)
			Confiscate(player, v.name, 'item_weapon', v.ammo)
		end
	end

	for k, v in ipairs(data.inventory) do
		if v.count > 0 then
			if not standartlabel then
				Item = NativeUI.CreateItem(_U('inventory_label'), "")
				standartlabel = true
				BodySearchMenu:AddItem(Item)
			end

			Item = NativeUI.CreateItem(_U('confiscate_inv', v.count, v.label), "")
			BodySearchMenu:AddItem(Item)

			Item.Activated = function(sender, index)
				Confiscate(player, v.name, 'item_standard', v.count)
			end
		end
	end

    BodySearchMenu:Visible(true)
	_menuPool:RefreshIndex()
	_menuPool:MouseControlsEnabled(false)
	_menuPool:MouseEdgeEnabled(false)
	_menuPool:ControlDisablingEnabled(false)
end

function Confiscate(player, name, itemtype, count)
	if itemtype == 'item_standard' then
		local input = KeyboardInput("Anzahl", "", 20)
		local amount = tonumber(input)
		if tostring(amount) then
			if amount and amount >= 0 and count >= amount then
				TriggerServerEvent('esx_playerradialmenu:confiscatePlayerItem', GetPlayerServerId(player), itemtype, name, amount)
				ESX.TriggerServerCallback('esx_playerradialmenu:getOtherPlayerData', function(data)
                    OpenBodySearchMenu(player, data)
				end, GetPlayerServerId(player))
			else
				TriggerEvent('dopeNotify:Alert', "", _U('quantity_invalid'), 5000, 'error')
			end
		else
			TriggerEvent('dopeNotify:Alert', "", _U('quantity_invalid'), 5000, 'error')
		end
	else
		TriggerServerEvent('esx_playerradialmenu:confiscatePlayerItem', GetPlayerServerId(player), itemtype, name, count)
		ESX.TriggerServerCallback('esx_playerradialmenu:getOtherPlayerData', function(data)
			OpenBodySearchMenu(player, data)
		end, GetPlayerServerId(player))
	end
end


RegisterNetEvent('esx_playerradialmenu:handcuff_trigger')
AddEventHandler('esx_playerradialmenu:handcuff_trigger', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TriggerServerEvent('esx_playerradialmenu:handcuff', GetPlayerServerId(closestPlayer))
    else
        TriggerEvent('dopeNotify:Alert', "", _U('no_players_nearby'), 5000, 'error')
    end
end)

RegisterNetEvent('esx_playerradialmenu:handcuff')
AddEventHandler('esx_playerradialmenu:handcuff', function()
	local playerPed = PlayerPedId()
	isHandcuffed = true
	RequestAnimDict('mp_arresting')
	while not HasAnimDictLoaded('mp_arresting') do
		Wait(100)
	end
	TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
	SetEnableHandcuffs(playerPed, true)
	DisablePlayerFiring(playerPed, true)
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
	SetPedCanPlayGestureAnims(playerPed, false)
end)

RegisterNetEvent('esx_playerradialmenu:uncuff_trigger')
AddEventHandler('esx_playerradialmenu:uncuff_trigger', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TriggerServerEvent('esx_playerradialmenu:uncuff', GetPlayerServerId(closestPlayer))
    else
        TriggerEvent('dopeNotify:Alert', "", _U('no_players_nearby'), 5000, 'error')
    end
end)

RegisterNetEvent('esx_playerradialmenu:unhandcuff')
AddEventHandler('esx_playerradialmenu:unhandcuff', function()
	local playerPed = PlayerPedId()
	isHandcuffed = false
	ClearPedSecondaryTask(playerPed)
	SetEnableHandcuffs(playerPed, false)
	DisablePlayerFiring(playerPed, false)
	SetPedCanPlayGestureAnims(playerPed, true)
end)

-- Handcuff
CreateThread(function()
	while true do
		Wait(0)
		local playerPed = PlayerPedId()
		if isHandcuffed then

			if isDead then
				isHandcuffed = false
				ClearPedSecondaryTask(playerPed)
				SetEnableHandcuffs(playerPed, false)
				DisablePlayerFiring(playerPed, false)
				SetPedCanPlayGestureAnims(playerPed, true)
				FreezeEntityPosition(playerPed, false)
			else
				DisableControlAction(0, 1, true) -- Disable pan
				DisableControlAction(0, 2, true) -- Disable tilt
				DisableControlAction(0, 24, true) -- Attack
				DisableControlAction(0, 257, true) -- Attack 2
				DisableControlAction(0, 25, true) -- Aim
				DisableControlAction(0, 263, true) -- Melee Attack 1

				DisableControlAction(0, 21, true) -- Run
	
				DisableControlAction(0, 45, true) -- Reload
				DisableControlAction(0, 44, true) -- Cover
				DisableControlAction(0, 37, true) -- Select Weapon
				DisableControlAction(0, 23, true) -- Also 'enter'?
	
				DisableControlAction(0, 288,  true) -- Disable phone
				DisableControlAction(0, 289, true) -- Inventory
				DisableControlAction(0, 170, true) -- Animations
				DisableControlAction(0, 167, true) -- Job
	
				DisableControlAction(0, 0, true) -- Disable changing view
				DisableControlAction(0, 26, true) -- Disable looking behind
				DisableControlAction(0, 73, true) -- Disable clearing animation
				DisableControlAction(2, 199, true) -- Disable pause screen
	
				DisableControlAction(0, 59, true) -- Disable steering in vehicle
				DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
				DisableControlAction(0, 72, true) -- Disable reversing in vehicle
	
				DisableControlAction(2, 36, true) -- Disable going stealth
	
				DisableControlAction(0, 47, true)  -- Disable weapon
				DisableControlAction(0, 264, true) -- Disable melee
				DisableControlAction(0, 257, true) -- Disable melee
				DisableControlAction(0, 140, true) -- Disable melee
				DisableControlAction(0, 141, true) -- Disable melee
				DisableControlAction(0, 142, true) -- Disable melee
				DisableControlAction(0, 143, true) -- Disable melee
				DisableControlAction(0, 75, true)  -- Disable exit vehicle
				DisableControlAction(27, 75, true) -- Disable exit vehicle
	
				if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
					ESX.Streaming.RequestAnimDict('mp_arresting', function()
						TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
					end)
				end
			end
		else
			Wait(500)
		end
	end
end)

-- Handcuff Animation Update
CreateThread(function()
	while true do
		if isHandcuffed then
			local playerPed = PlayerPedId()
			TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
			Wait(10000)
		end
		Wait(1)
	end
end)

RegisterNetEvent('esx_playerradialmenu:drag_trigger')
AddEventHandler('esx_playerradialmenu:drag_trigger', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TriggerServerEvent('esx_jobs:drag', GetPlayerServerId(closestPlayer))
    else
        TriggerEvent('dopeNotify:Alert', "", _U('no_players_nearby'), 5000, 'error')
    end
end)

RegisterNetEvent('esx_playerradialmenu:drag')
AddEventHandler('esx_playerradialmenu:drag', function(SourceID)
	dragStatus.isDragged = not dragStatus.isDragged
	dragStatus.SourceID = SourceID
end)

CreateThread(function()
	local playerPed = PlayerPedId()
	local targetPed

	while true do
		Wait(1)
		if dragStatus.isDragged then
			targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.SourceID))

			if not IsPedSittingInAnyVehicle(targetPed) then
				AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
			else
				dragStatus.isDragged = false
				DetachEntity(playerPed, true, false)
			end

			if IsPedDeadOrDying(targetPed, true) then
				dragStatus.isDragged = false
				DetachEntity(playerPed, true, false)
			end
		else
			DetachEntity(playerPed, true, false)
		end
	end
end)


RegisterNetEvent('esx_playerradialmenu:putInVehicle_trigger')
AddEventHandler('esx_playerradialmenu:putInVehicle_trigger', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TriggerServerEvent('esx_playerradialmenu:putInVehicle', GetPlayerServerId(closestPlayer))
    else
        TriggerEvent('dopeNotify:Alert', "", _U('no_players_nearby'), 5000, 'error')
    end
end)

RegisterNetEvent('esx_playerradialmenu:putInVehicle')
AddEventHandler('esx_playerradialmenu:putInVehicle', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords, 5.0) then
		local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

		if DoesEntityExist(vehicle) then
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
				dragStatus.isDragged = false
			end
		end
	end
end)

RegisterNetEvent('esx_playerradialmenu:putOutVehicle_trigger')
AddEventHandler('esx_playerradialmenu:putOutVehicle_trigger', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TriggerServerEvent('esx_playerradialmenu:OutVehicle', GetPlayerServerId(closestPlayer))
    else
        TriggerEvent('dopeNotify:Alert', "", _U('no_players_nearby'), 5000, 'error')
    end
end)

RegisterNetEvent('esx_playerradialmenu:OutVehicle')
AddEventHandler('esx_playerradialmenu:OutVehicle', function()
	local playerPed = PlayerPedId()
	if not IsPedSittingInAnyVehicle(playerPed) then
		return
	end

	local vehicle = GetVehiclePedIsIn(playerPed, false)
	TaskLeaveVehicle(playerPed, vehicle, 16)

	if isHandcuffed then
		ClearPedSecondaryTask(playerPed)
		Wait(200)
		TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
	end
end)

RegisterNetEvent('esx_playerradialmenu:engine')
AddEventHandler('esx_playerradialmenu:engine', function()
    ped = PlayerPedId()
    if IsPedSittingInAnyVehicle(ped) then
        local veh = GetVehiclePedIsIn(ped, false)
        if GetIsVehicleEngineRunning(veh) then
            SetVehicleEngineOn(veh, false, false, true)
            SetVehicleUndriveable(veh, true)
        elseif not GetIsVehicleEngineRunning(veh) then
            SetVehicleEngineOn(veh, true, false, true)
            SetVehicleUndriveable(veh, false)
        end
    else
        TriggerEvent('dopeNotify:Alert', "", "DU bist nicht in einem Fahrzeug", 5000, 'error')
    end
end)

RegisterNetEvent('esx_playerradialmenu:vehicle_window')
AddEventHandler('esx_playerradialmenu:vehicle_window', function(data)
    ped = PlayerPedId()
    if IsPedSittingInAnyVehicle(ped) then
        local veh = GetVehiclePedIsIn(ped, false)

        for k, v in pairs(vehicle_windows) do
            for k, window_index in pairs(data.args) do
                if v.window_index == window_index then
                    if v.status then
                        RollDownWindow(veh, window_index)
                        v.status = false
                    else
                        RollUpWindow(veh, window_index)
                        v.status = true
                    end
                end
            end
        end
    else
        TriggerEvent('dopeNotify:Alert', "", "Du bist nicht in einem Auto", 5000, 'error')
    end
end)

RegisterNetEvent('esx_playerradialmenu:ChangeSeat', function(data)
    ped = PlayerPedId()
    local Veh = GetVehiclePedIsIn(ped)
    local IsSeatFree = IsVehicleSeatFree(Veh, data.id)
    local speed = GetEntitySpeed(Veh) * 3.6
    if IsPedSittingInAnyVehicle(ped) then
        if IsSeatFree then
            if speed <= 1.0 then
                SetPedIntoVehicle(ped, Veh, data.id)
                TriggerEvent('dopeNotify:Alert', "", "Sitzplatz gewechselt", 5000, 'info')
            else
                TriggerEvent('dopeNotify:Alert', "", "Du kannst den Sitzplatz nicht wechseln wenn sich das Fahrzeug bewegt", 5000, 'error')
            end
        else
            TriggerEvent('dopeNotify:Alert', "", "Der Sitzplatz ist belegt", 5000, 'error')
        end
    else
        TriggerEvent('dopeNotify:Alert', "", "Du bist nicht in einem Auto", 5000, 'error') 
    end
end)

RegisterNetEvent('esx_playerradialmenu:vehicle_door')
AddEventHandler('esx_playerradialmenu:vehicle_door', function(data)
    ped = PlayerPedId()
    if IsPedSittingInAnyVehicle(ped) then
        local veh = GetVehiclePedIsIn(ped, false)

        if GetVehicleDoorAngleRatio(veh, data.args[1]) > 0 then
            SetVehicleDoorShut(veh, data.args[1], false)
        else
            SetVehicleDoorOpen(veh, data.args[1], false, false)
        end
    else
        TriggerEvent('dopeNotify:Alert', "", "Du bist nicht in einem Auto", 5000, 'error') 
    end
end)

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
	AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
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