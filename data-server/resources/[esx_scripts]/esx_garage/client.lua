local _menuPool                 = NativeUI.CreatePool()
local GarageUI                  = nil
local PlayerData                = {}
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local InMarker                  = false
local blips_list                = {}
local npc_list                  = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData = ESX.GetPlayerData()
    CreateBlip()
end)

CreateThread(function()
    Wait(1)
	while PlayerData.job == nil do
		PlayerData = ESX.GetPlayerData()
		Wait(100)
	end

    CreateBlip()
    SpawnNPC()
	while true do
        Wait(100)
        if npc_list then
            for i, ped in ipairs(npc_list) do
		        TaskSetBlockingOfNonTemporaryEvents(ped, true)
            end
        end
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

CreateThread(function()
    while true do
        Wait(60)
        if PlayerData and PlayerData.job then
            local coords = GetEntityCoords(PlayerPedId())
            local isInMarker  = false
            local isInTeleporterMarker  = false
            local currentZone = nil
            local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            for k,v in pairs(garagecoord) do
                if v.job and v.job == PlayerData.job.name or v.job == nil then
                    if(GetDistanceBetweenCoords(coords, v.garage_coord, true) < v.Dist) then
                        isInMarker  = true
                        currentZone = v
                        ShowNotification(currentZone, Vehicle)
                    end
                end
            end
            if isInMarker then
                HasAlreadyEnteredMarker = true
                LastZone = currentZone
                TriggerEvent('esx_garage:hasEnteredMarker', LastZone)
            elseif not isInMarker and HasAlreadyEnteredMarker then
                HasAlreadyEnteredMarker = false
                TriggerEvent('esx_garage:hasExitedMarker', LastZone)
                InMarker = false
            end
        end
    end
end)

AddEventHandler('esx_garage:hasEnteredMarker', function (zone)
	CurrentGarage     = zone
	CurrentActionMsg  = ""
	CurrentActionData = {}
end)

AddEventHandler('esx_garage:hasExitedMarker', function (zone)
    _menuPool:CloseAllMenus()
	CurrentGarage = nil
    CurrentActionMsg  = ""
	CurrentActionData = {}
end)

CreateThread(function()
	while true do
		Wait(0)
		if CurrentGarage == nil then
			Wait(100)
        else
            if IsControlJustReleased(0, 38) then
                local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                if DoesEntityExist(Vehicle) then
                    StoreVehicle(CurrentGarage, Vehicle)
                else
                    ESX.TriggerServerCallback("esx_garage:getVehicles",function(vehicles)
                        OpenGarage(CurrentGarage, vehicles)
                    end, CurrentGarage, true)
                end
            end
        end
    end
end)

function OpenGarage(garage, vehicles)
    _menuPool:CloseAllMenus()
	if GarageUI ~= nil and GarageUI:Visible() then
		GarageUI:Visible(false)
	end

    if garage.job then
        GarageUI = NativeUI.CreateMenu(PlayerData.job.label.. "-Garage", nil, nil)
    elseif garage.impound then
        GarageUI = NativeUI.CreateMenu("Abschlepphof", nil, nil)
    else
        GarageUI = NativeUI.CreateMenu("Garage", nil, nil)
    end
    _menuPool:Add(GarageUI)

    local Private 
    local PrivateCreated = false
    local Job
    local JobCreated = false
    for k, vehicle in ipairs(vehicles) do
        if vehicle.owner == PlayerData.identifier then
            Private = true
        else
            if vehicle.grade >= 0 then
                if vehicle.grade <= PlayerData.job.grade then
                    Job = true
                end
            end
        end
    end

    if not Private and not Job then
        TriggerEvent('dopeNotify:Alert', "Garage", "In der Garage befindet sich kein Fahrzeug", 5000, 'error')
        _menuPool:CloseAllMenus()
        return
    end

    for k, vehicle in ipairs(vehicles) do
        if vehicle.owner == PlayerData.identifier then
            if not PrivateCreated and Job then
                Private = _menuPool:AddSubMenu(GarageUI, 'Privat Fahrzeuge')
                PrivateCreated = true
            end
            local props = json.decode(vehicle.vehicle)
            local ModelName = GetLabelText(GetDisplayNameFromVehicleModel(tonumber(props.model)):lower())
            local VehicleItem = NativeUI.CreateItem(ModelName, 'Besitzer: ~g~Du~s~ Kennzeichen: ~g~'.. vehicle.plate)
            VehicleItem:SetRightBadge("BadgeStyle.Alert")
            if PrivateCreated then
                Private.SubMenu:AddItem(VehicleItem)
            else
                GarageUI:AddItem(VehicleItem)
            end
            _menuPool:RefreshIndex()
            VehicleItem.Activated = function(sender, index)
                if garage.impound then
                    ESX.TriggerServerCallback("esx_garage:pay",function(payed)
                        if payed then
                            GetVehicleFromGarage(garage, props)
                        else
                            TriggerEvent('dopeNotify:Alert', "Garage", "Du hast nicht genug Geld du benötigst: $"..Config.ReturnPayment, 5000, 'error')
                        end
                    end)
                elseif garage.job and garage.shareprivatetojob then
                    OpenSelect(garage, props)
                else
                    GetVehicleFromGarage(garage, props)
                end
            end
        else
            if vehicle.grade >= 0 then
                if vehicle.grade <= PlayerData.job.grade then
                    if not JobCreated and Private then
                        Job = _menuPool:AddSubMenu(GarageUI, 'Job Fahrzeuge')
                        JobCreated = true
                    end
                    local props = json.decode(vehicle.vehicle)
                    local ModelName = GetLabelText(GetDisplayNameFromVehicleModel(tonumber(props.model)):lower())
                    local VehicleItem = NativeUI.CreateItem(ModelName, 'Besitzer: ~g~'..PlayerData.job.label.. '~s~ Kennzeichen: ~g~'.. vehicle.plate)
                    if JobCreated then
                        Job.SubMenu:AddItem(VehicleItem)
                    else
                        GarageUI:AddItem(VehicleItem)
                    end
                    _menuPool:RefreshIndex()
                    VehicleItem.Activated = function(sender, index)
                        if garage.impound then
                            ESX.TriggerServerCallback("esx_garage:pay",function(payed)
                                if payed then
                                    GetVehicleFromGarage(garage, props)
                                else
                                    TriggerEvent('dopeNotify:Alert', "Garage", PlayerData.job.label.." hat nicht das benötigte Geld", 5000, 'error')
                                end
                            end, vehicle.job)
                        else
                            GetVehicleFromGarage(garage, props)
                        end
                    end
                end
            end
        end
    end

    GarageUI:Visible(true)
	_menuPool:RefreshIndex()
	_menuPool:MouseControlsEnabled(false)
	_menuPool:MouseEdgeEnabled(false)
	_menuPool:ControlDisablingEnabled(false)
end

function OpenSelect(garage, props)
    _menuPool:CloseAllMenus()
	if GarageUI ~= nil and GarageUI:Visible() then
		GarageUI:Visible(false)
	end

    GarageUI = NativeUI.CreateMenu("Garage", nil, nil)
    _menuPool:Add(GarageUI)
    local ModelName = GetLabelText(GetDisplayNameFromVehicleModel(tonumber(props.model)):lower())
    local Spawn = NativeUI.CreateItem("Fahrzeug ausparken", 'Model: ~g~'..ModelName.. '~s~ Kennzeichen: ~g~'.. props.plate .. '~s~ ausparken')
    GarageUI:AddItem(Spawn)
    local Manage = NativeUI.CreateItem("Fahrzeug Verwalten", 'Model: ~g~'..ModelName.. '~s~ Kennzeichen: ~g~'.. props.plate .. '~s~ verwalten')
    GarageUI:AddItem(Manage)
    _menuPool:RefreshIndex()

	GarageUI.OnItemSelect = function(sender, item, index)
		if item == Spawn then
            GetVehicleFromGarage(garage, props)
        elseif item == Manage then
            OpenVehicleManger(garage, props)
		end
	end

    GarageUI:Visible(true)
	_menuPool:RefreshIndex()
	_menuPool:MouseControlsEnabled(false)
	_menuPool:MouseEdgeEnabled(false)
	_menuPool:ControlDisablingEnabled(false)
end

function OpenVehicleManger(garage, props)
    _menuPool:CloseAllMenus()
	if GarageUI ~= nil and GarageUI:Visible() then
		GarageUI:Visible(false)
	end

    local playerPed = PlayerPedId()
    GarageUI = NativeUI.CreateMenu("Fahrzeug Verwaltung", nil, nil)
    _menuPool:Add(GarageUI)

    ESX.TriggerServerCallback("esx_garage:GetJob",function(job)
        local values = {}
        table.insert(values, "Nur Ich")
        for k, v in pairs(job) do
            table.insert(values, v.label)
        end
    
        local GradeList = NativeUI.CreateListItem('Rang: ', values, 0, 'Wähle einen ~g~Rang~s~ aus ab wann man dein Fahrzeug nutzen kann oder wähle ~g~"Nur Ich"~s~ aus')
        GarageUI:AddItem(GradeList)
        _menuPool:RefreshIndex()
    
        GarageUI.OnListSelect = function(sender, item, index)
            for k, v in pairs(values) do
                if k == index then
                    ESX.TriggerServerCallback("esx_garage:ChangeGrade",function(done)
                        if done then
                            if v == "Nur Ich" then
                                TriggerEvent('dopeNotify:Alert', "Garage", "Dein Fahrzeug ist nun nur für dich verfügbar", 5000, 'info')
                            else
                                TriggerEvent('dopeNotify:Alert', "Garage", "Dein Fahrzeug ist nun ab den Rang "..v.."  verfügbar", 5000, 'info')
                            end
                            _menuPool:CloseAllMenus()
                        end
                    end, props, garage, index - 2)
                end
            end
        end
    end)

    GarageUI:Visible(true)
	_menuPool:RefreshIndex()
	_menuPool:MouseControlsEnabled(false)
	_menuPool:MouseEdgeEnabled(false)
	_menuPool:ControlDisablingEnabled(false)
end

function GetVehicleFromGarage(garage, props)
    _menuPool:CloseAllMenus()
    local playerPed = PlayerPedId()

    ESX.TriggerServerCallback("esx_garage:canGetVehicle",function(canGetVehicle)
        if canGetVehicle then
            SpawnVehicle(garage, props)
        else
            TriggerEvent('dopeNotify:Alert', "Garage", "Du kannst das Fahrzeug nicht ausparken", 5000, 'error')
            OpenGarage(garage)
        end
    end, props, garage)
end

function SpawnVehicle(garage, props)
    ESX.TriggerServerCallback("esx_garage:changestatus",function(changed)
        if changed then
            if not HasModelLoaded(tonumber(props.model)) then
                RequestModel(tonumber(props.model))
                while not HasModelLoaded(tonumber(props.model)) do
                    Wait(1)
                end
            end
            local closestVehicle, Distance = ESX.Game.GetClosestVehicle(garage.spawn_coord)
            local vehicle
            for k, spawn in pairs(garage.spawn_coords) do
                local closestVehicle, Distance = ESX.Game.GetClosestVehicle(spawn.coords)
                if Distance >= 4.0 or Distance == -1 then
                    vehicle = CreateVehicle(tonumber(props.model), spawn.coords, spawn.heading, 1, 1)
                    break
                end
            end
            local count = 0
            while not vehicle do
                count = count + 1
                for k, spawn in pairs(garage.spawn_coords) do
                    local closestVehicle, Distance = ESX.Game.GetClosestVehicle(spawn.coords)
                    if Distance >= 4.0 or Distance == -1 then
                        vehicle = CreateVehicle(tonumber(props.model), spawn.coords, spawn.heading, 1, 1)
                        break
                    end
                end
                TriggerEvent('dopeNotify:Alert', "Garage", "Versuche Fahrzeug auszuparken ".. count.."/10", 100, 'error')

                if count == 10 then
                    ESX.TriggerServerCallback("esx_garage:changestatus",function(changed)
                        if changed then
                            TriggerEvent('dopeNotify:Alert', "Garage", "Aktuell sind alle Parkplätze belegt", 5000, 'error')
                        end

                    end, props, garage, true, garage.impound)
                    break
                end
                Wait(1000)
            end

            if vehicle then
                SetVehicleProp(vehicle, props)
                SetVehicleBobo(vehicle)
                NetworkFadeInEntity(vehicle,1)
                SetVehRadioStation(vehicle, 'OFF')
    
                TriggerEvent('dopeNotify:Alert', "Garage", "Du hast dein Fahrzeug mit dem Kennzeichen "..props.plate.." ausgeparkt", 5000, 'success')
            end
        end
    end, props, garage, false, false)
end

function StoreVehicle(garage, vehicle)
    local playerPed = PlayerPedId()
    local vehicleProps = GetVehicleProperties(vehicle)

    ESX.TriggerServerCallback("esx_garage:canStoreVehicle",function(canStore, hasOwner)
        if canStore then
            TaskLeaveVehicle(playerPed,GetVehiclePedIsIn(playerPed), 1)
            Wait(2000)
            ESX.TriggerServerCallback("esx_garage:changestatus",function(changed, hasOwner)
                if changed then
                    DeleteEntity(vehicle)
                else
                    DeleteEntity(vehicle)
                end
            end, vehicleProps, garage, true, garage.impound)
            TriggerEvent('dopeNotify:Alert', "Garage", "Du hast das Fahrzeug mit dem Kennzeichen "..vehicleProps.plate.." eingeparkt", 5000, 'success')
        else
            if hasOwner then
                TriggerEvent('dopeNotify:Alert', "Garage", "Du kannst das Fahrzeug hier nicht Parken", 5000, 'error')
            else
                DeleteEntity(vehicle)
                TriggerEvent('dopeNotify:Alert', "Garage", "Kein Besitzer gefunden", 5000, 'error')
            end
        end
    end, vehicleProps, garage)
end

function GetVehicleProperties(vehicle)
    if DoesEntityExist(vehicle) then
        local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
        local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
        local extras = {}
        for extraId=0, 12 do
            if DoesExtraExist(vehicle, extraId) then
                local state = IsVehicleExtraTurnedOn(vehicle, extraId) == 1
                extras[tostring(extraId)] = state
            end
        end
        local plate = GetVehicleNumberPlateText(vehicle)
        local modlivery = GetVehicleLivery(vehicle)
        if modlivery == -1 then
            modlivery = GetVehicleMod(vehicle, 48)
        end
        local mods = {
            model             = GetEntityModel(vehicle),
            plate             = plate,
            plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),
            bodyHealth        = ESX.Math.Round(GetVehicleBodyHealth(vehicle), 1),
            engineHealth      = ESX.Math.Round(GetVehicleEngineHealth(vehicle), 1),
            tankHealth        = ESX.Math.Round(GetVehiclePetrolTankHealth(vehicle), 1),
            fuelLevel         = ESX.Math.Round(GetVehicleFuelLevel(vehicle), 1),
            dirtLevel         = ESX.Math.Round(GetVehicleDirtLevel(vehicle), 1),
            color1            = colorPrimary,
            color2            = colorSecondary,
            rgb				  = table.pack(GetVehicleCustomPrimaryColour(vehicle)),
            rgb2				  = table.pack(GetVehicleCustomSecondaryColour(vehicle)),
            pearlescentColor  = pearlescentColor,
            wheelColor        = wheelColor,
            wheels            = GetVehicleWheelType(vehicle),
            windowTint        = GetVehicleWindowTint(vehicle),
            xenonColor        = GetVehicleXenonLightsColour(vehicle),
            neonEnabled       = {
                IsVehicleNeonLightEnabled(vehicle, 0),
                IsVehicleNeonLightEnabled(vehicle, 1),
                IsVehicleNeonLightEnabled(vehicle, 2),
                IsVehicleNeonLightEnabled(vehicle, 3)
            },
            neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
            extras            = extras,
            tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),
            modSpoilers       = GetVehicleMod(vehicle, 0),
            modFrontBumper    = GetVehicleMod(vehicle, 1),
            modRearBumper     = GetVehicleMod(vehicle, 2),
            modSideSkirt      = GetVehicleMod(vehicle, 3),
            modExhaust        = GetVehicleMod(vehicle, 4),
            modFrame          = GetVehicleMod(vehicle, 5),
            modGrille         = GetVehicleMod(vehicle, 6),
            modHood           = GetVehicleMod(vehicle, 7),
            modFender         = GetVehicleMod(vehicle, 8),
            modRightFender    = GetVehicleMod(vehicle, 9),
            modRoof           = GetVehicleMod(vehicle, 10),
            modEngine         = GetVehicleMod(vehicle, 11),
            modBrakes         = GetVehicleMod(vehicle, 12),
            modTransmission   = GetVehicleMod(vehicle, 13),
            modHorns          = GetVehicleMod(vehicle, 14),
            modSuspension     = GetVehicleMod(vehicle, 15),
            modArmor          = GetVehicleMod(vehicle, 16),
            modTurbo          = IsToggleModOn(vehicle, 18),
            modSmokeEnabled   = IsToggleModOn(vehicle, 20),
            modXenon          = IsToggleModOn(vehicle, 22),
            modFrontWheels    = GetVehicleMod(vehicle, 23),
            modBackWheels     = GetVehicleMod(vehicle, 24),
            modPlateHolder    = GetVehicleMod(vehicle, 25),
            modVanityPlate    = GetVehicleMod(vehicle, 26),
            modTrimA          = GetVehicleMod(vehicle, 27),
            modOrnaments      = GetVehicleMod(vehicle, 28),
            modDashboard      = GetVehicleMod(vehicle, 29),
            modDial           = GetVehicleMod(vehicle, 30),
            modDoorSpeaker    = GetVehicleMod(vehicle, 31),
            modSeats          = GetVehicleMod(vehicle, 32),
            modSteeringWheel  = GetVehicleMod(vehicle, 33),
            modShifterLeavers = GetVehicleMod(vehicle, 34),
            modAPlate         = GetVehicleMod(vehicle, 35),
            modSpeakers       = GetVehicleMod(vehicle, 36),
            modTrunk          = GetVehicleMod(vehicle, 37),
            modHydrolic       = GetVehicleMod(vehicle, 38),
            modEngineBlock    = GetVehicleMod(vehicle, 39),
            modAirFilter      = GetVehicleMod(vehicle, 40),
            modStruts         = GetVehicleMod(vehicle, 41),
            modArchCover      = GetVehicleMod(vehicle, 42),
            modAerials        = GetVehicleMod(vehicle, 43),
            modTrimB          = GetVehicleMod(vehicle, 44),
            modTank           = GetVehicleMod(vehicle, 45),
            modWindows        = GetVehicleMod(vehicle, 46),
            modLivery         = modlivery
        }
        if Config.ReturnDamage then
            mods.wheel_tires = {}
            mods.vehicle_doors = {}
            mods.vehicle_window = {}
            for tireid = 1, 7 do
                local normal = IsVehicleTyreBurst(vehicle, tireid, true)
                local completely = IsVehicleTyreBurst(vehicle, tireid, false)
                if normal or completely then
                    mods.wheel_tires[tireid] = true
                else
                    mods.wheel_tires[tireid] = false
                end
            end
            Wait(100)
            for doorid = 0, 5 do
                mods.vehicle_doors[#mods.vehicle_doors+1] = IsVehicleDoorDamaged(vehicle, doorid)
            end
            Wait(100)
            for windowid = 0, 7 do
                mods.vehicle_window[#mods.vehicle_window+1] = IsVehicleWindowIntact(vehicle, windowid)
            end
        end
        return mods
    else
        return
    end
end

function SetVehicleProp(vehicle, mods)
    local mods = mods
    if Config.ReturnDamage then
        if mods.wheel_tires then
            for tireid = 1, 7 do
                if mods.wheel_tires[tireid] ~= false then
                    SetVehicleTyreBurst(vehicle, tireid, true, 1000)
                end
            end
        end
        if mods.vehicle_window then
            for windowid = 0, 5, 1 do
                if mods.vehicle_window[windowid] ~= false then
                    RemoveVehicleWindow(vehicle, windowid)
                end
            end
        end
        if mods.vehicle_doors then
            for doorid = 0, 5, 1 do
                if mods.vehicle_doors[doorid] ~= false then
                    SetVehicleDoorBroken(vehicle, doorid-1, true)
                end
            end
        end
    end
    props = mods
    if DoesEntityExist(vehicle) then
        local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
        local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
        SetVehicleModKit(vehicle, 0)
        if props.sound then ForceVehicleEngineAudio(vehicle, props.sound) end
        if props.plate then SetVehicleNumberPlateText(vehicle, props.plate) end
        if props.plateIndex then SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex) end
        if props.bodyHealth then SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0) end
        if props.engineHealth then SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0) end
        if props.tankHealth then SetVehiclePetrolTankHealth(vehicle, props.tankHealth + 0.0) end
        if props.dirtLevel then SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0) end
        if props.rgb then SetVehicleCustomPrimaryColour(vehicle, props.rgb[1], props.rgb[2], props.rgb[3]) end
        if props.rgb2 then SetVehicleCustomSecondaryColour(vehicle, props.rgb2[1], props.rgb2[2], props.rgb2[3]) end
        if props.color1 then SetVehicleColours(vehicle, props.color1, colorSecondary) end
        if props.color2 then SetVehicleColours(vehicle, props.color1 or colorPrimary, props.color2) end
        if props.pearlescentColor then SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor) end
        if props.wheelColor then SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor) end
        if props.wheels then SetVehicleWheelType(vehicle, props.wheels) end
        if props.windowTint then SetVehicleWindowTint(vehicle, props.windowTint) end
        if props.neonEnabled then
            SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
            SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
            SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
            SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
        end
        if props.extras then
            for extraId,enabled in pairs(props.extras) do
                if enabled then
                    SetVehicleExtra(vehicle, tonumber(extraId), 0)
                else
                    SetVehicleExtra(vehicle, tonumber(extraId), 1)
                end
            end
        end
        if props.neonColor then SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3]) end
        if props.xenonColor then SetVehicleXenonLightsColour(vehicle, props.xenonColor) end
        if props.modSmokeEnabled then ToggleVehicleMod(vehicle, 20, true) end
        if props.tyreSmokeColor then SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3]) end
        if props.modSpoilers then SetVehicleMod(vehicle, 0, props.modSpoilers, false) end
        if props.modFrontBumper then SetVehicleMod(vehicle, 1, props.modFrontBumper, false) end
        if props.modRearBumper then SetVehicleMod(vehicle, 2, props.modRearBumper, false) end
        if props.modSideSkirt then SetVehicleMod(vehicle, 3, props.modSideSkirt, false) end
        if props.modExhaust then SetVehicleMod(vehicle, 4, props.modExhaust, false) end
        if props.modFrame then SetVehicleMod(vehicle, 5, props.modFrame, false) end
        if props.modGrille then SetVehicleMod(vehicle, 6, props.modGrille, false) end
        if props.modHood then SetVehicleMod(vehicle, 7, props.modHood, false) end
        if props.modFender then SetVehicleMod(vehicle, 8, props.modFender, false) end
        if props.modRightFender then SetVehicleMod(vehicle, 9, props.modRightFender, false) end
        if props.modRoof then SetVehicleMod(vehicle, 10, props.modRoof, false) end
        if props.modEngine then SetVehicleMod(vehicle, 11, props.modEngine, false) end
        if props.modBrakes then SetVehicleMod(vehicle, 12, props.modBrakes, false) end
        if props.modTransmission then SetVehicleMod(vehicle, 13, props.modTransmission, false) end
        if props.modHorns then SetVehicleMod(vehicle, 14, props.modHorns, false) end
        if props.modSuspension then SetVehicleMod(vehicle, 15, props.modSuspension, false) end
        if props.modArmor then SetVehicleMod(vehicle, 16, props.modArmor, false) end
        if props.modTurbo then ToggleVehicleMod(vehicle,  18, props.modTurbo) end
        if props.modXenon then ToggleVehicleMod(vehicle,  22, props.modXenon) end
        if props.modFrontWheels then SetVehicleMod(vehicle, 23, props.modFrontWheels, false) end
        if props.modBackWheels then SetVehicleMod(vehicle, 24, props.modBackWheels, false) end
        if props.modPlateHolder then SetVehicleMod(vehicle, 25, props.modPlateHolder, false) end
        if props.modVanityPlate then SetVehicleMod(vehicle, 26, props.modVanityPlate, false) end
        if props.modTrimA then SetVehicleMod(vehicle, 27, props.modTrimA, false) end
        if props.modOrnaments then SetVehicleMod(vehicle, 28, props.modOrnaments, false) end
        if props.modDashboard then SetVehicleMod(vehicle, 29, props.modDashboard, false) end
        if props.modDial then SetVehicleMod(vehicle, 30, props.modDial, false) end
        if props.modDoorSpeaker then SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false) end
        if props.modSeats then SetVehicleMod(vehicle, 32, props.modSeats, false) end
        if props.modSteeringWheel then SetVehicleMod(vehicle, 33, props.modSteeringWheel, false) end
        if props.modShifterLeavers then SetVehicleMod(vehicle, 34, props.modShifterLeavers, false) end
        if props.modAPlate then SetVehicleMod(vehicle, 35, props.modAPlate, false) end
        if props.modSpeakers then SetVehicleMod(vehicle, 36, props.modSpeakers, false) end
        if props.modTrunk then SetVehicleMod(vehicle, 37, props.modTrunk, false) end
        if props.modHydrolic then SetVehicleMod(vehicle, 38, props.modHydrolic, false) end
        if props.modEngineBlock then SetVehicleMod(vehicle, 39, props.modEngineBlock, false) end
        if props.modAirFilter then SetVehicleMod(vehicle, 40, props.modAirFilter, false) end
        if props.modStruts then SetVehicleMod(vehicle, 41, props.modStruts, false) end
        if props.modArchCover then SetVehicleMod(vehicle, 42, props.modArchCover, false) end
        if props.modAerials then SetVehicleMod(vehicle, 43, props.modAerials, false) end
        if props.modTrimB then SetVehicleMod(vehicle, 44, props.modTrimB, false) end
        if props.modTank then SetVehicleMod(vehicle, 45, props.modTank, false) end
        if props.modWindows then SetVehicleMod(vehicle, 46, props.modWindows, false) end
        if props.modLivery then
            SetVehicleMod(vehicle, 48, props.modLivery, false)
            SetVehicleLivery(vehicle, props.modLivery)
        end
        if props.fuelLevel then SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0) if DecorGetFloat(vehicle,'_FUEL_LEVEL') then DecorSetFloat(vehicle,'_FUEL_LEVEL',props.fuelLevel + 0.0) end end
    end
end

function SetVehicleBobo(vehicle)
    local netid = NetworkGetNetworkIdFromEntity(vehicle)
    SetNetworkIdExistsOnAllMachines(netid,true)
end

function CreateBlip()
	for i, station in ipairs(blips_list) do
		if DoesBlipExist(station) then
			RemoveBlip(station)
		end
	end	
	blips_list = {}

    for k, v in pairs (garagecoord) do
        if v.job and v.job == PlayerData.job.name or v.job == nil then
            local blip = AddBlipForCoord(v.garage_coord)
            SetBlipSprite (blip, v.Blip.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale  (blip, v.Blip.scale)
            SetBlipColour (blip, v.Blip.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            if v.job then
                AddTextComponentSubstringPlayerName(PlayerData.job.label .. " Garage")
            elseif v.impound then
                AddTextComponentSubstringPlayerName("Abschlepphof")
            else
                AddTextComponentSubstringPlayerName("Garage")
            end
            EndTextCommandSetBlipName(blip)
            table.insert(blips_list, blip)
        end
    end
    
end

function SpawnNPC()
    for k, v in pairs (garagecoord) do
        if v.npc_heading then
            RequestModel("a_m_y_mexthug_01")
            LoadPropDict("a_m_y_mexthug_01")
            local ped = CreatePed(5, "a_m_y_mexthug_01" ,v.garage_coord, v.npc_heading, false, true)
            PlaceObjectOnGroundProperly(ped)
            SetEntityAsMissionEntity(ped)
            SetPedDropsWeaponsWhenDead(ped, false)
            FreezeEntityPosition(ped, true)
            SetPedAsEnemy(ped, false)
            SetEntityInvincible(ped, true)
            SetModelAsNoLongerNeeded("a_m_y_mexthug_01")
            SetPedCanBeTargetted(ped, false)
            table.insert(npc_list, ped)
        end
    end
end

function LoadPropDict(model)
	while not HasModelLoaded(GetHashKey(model)) do
	  RequestModel(GetHashKey(model))
	  Wait(10)
	end
end

function ShowNotification(garage, vehicle)
    if not _menuPool:IsAnyMenuOpen() then
        if garage.job then
            if DoesEntityExist(vehicle) then
                showInfobar('Drücke ~g~E~s~, um Fahrzeug in die '..PlayerData.job.label..'-Garage zu parken')
            else
                showInfobar('Drücke ~g~E~s~, um die '..PlayerData.job.label..'-Garage zu öffnen')
            end
        elseif garage.impound then
            if DoesEntityExist(vehicle) then
                showInfobar('Drücke ~g~E~s~, um Fahrzeug in den Abschlepphof zu parken')
            else
                showInfobar('Drücke ~g~E~s~, um den Abchlepphof zu öffnen')
            end
        else
            if DoesEntityExist(vehicle) then
                showInfobar('Drücke ~g~E~s~, um Fahrzeug in die Garage zu parken')
            else
                showInfobar('Drücke ~g~E~s~, um die Garage zu öffnen')
            end
        end
    end
end

function showInfobar(msg)
    SetTextComponentFormat('STRING')
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

AddEventHandler("onResourceStop",function(resourceName)
    if resourceName == GetCurrentResourceName() then
        if npc_list then
            for i, ped in ipairs(npc_list) do
	            DeletePed(ped)
            end
            npc_list = {}
        end
    end
end)
