local LastVehicleFromGarage
local garageid = 'A'
local inGarage = false
local ingarage = false
local garage_coords = {}
local shell = nil
ESX = nil
local fetchdone = false
local PlayerData = {}
local playerLoaded = false
local spawned_cars = {}
local type = 'car'
local vehiclesdb = {}
local tid = 0
local propertygarage = false
local jobgarages = {}
local coordcache = {}
local propertyspawn = {}
local lastcat = nil
local deleting = false
local garage_public = false

Citizen.CreateThread(function()
    Wait(1000)
    coordcache = garagecoord
    for k,v in pairs(garagecoord) do -- create job garage
        if v.job ~= nil and jobgarages[v.garage] == nil then
            jobgarages[v.garage] = {}
            jobgarages[v.garage].coord = vector3(v.garage_x,v.garage_y,v.garage_z)
            jobgarages[v.garage].garageid = v.garage
            jobgarages[v.garage].job = v.job
            jobgarages[v.garage].garage_type = v.garage_type ~= nil and v.garage_type or 'personal'
        end
    end
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end

	while PlayerData.job == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		PlayerData = ESX.GetPlayerData()
		Citizen.Wait(111)
	end

	PlayerData = ESX.GetPlayerData()
    Wait(2000)
    for k, v in pairs (garagecoord) do
        if v.job ~= nil and v.job == PlayerData.job.name or v.job == nil then
            local blip = AddBlipForCoord(v.garage_x, v.garage_y, v.garage_z)
            SetBlipSprite (blip, v.Blip.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale  (blip, v.Blip.scale)
            SetBlipColour (blip, v.Blip.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            if Config.BlipNamesStatic then
                AddTextComponentSubstringPlayerName("Garage")
            else
                AddTextComponentSubstringPlayerName("Garage: "..v.garage.."")
            end
            EndTextCommandSetBlipName(blip)
        end
    end
    if Config.EnableImpound then
        for k, v in pairs (impoundcoord) do
            if PlayerData.job ~= nil and JobImpounder[PlayerData.job.name] ~= nil then
                local blip = AddBlipForCoord(v.garage_x, v.garage_y, v.garage_z)
                SetBlipSprite (blip, v.Blip.sprite)
                SetBlipDisplay(blip, 4)
                SetBlipScale  (blip, v.Blip.scale)
                SetBlipColour (blip, v.Blip.color)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName('STRING')
                if Config.BlipNamesStatic then
                    AddTextComponentSubstringPlayerName("Impound")
                else
                    AddTextComponentSubstringPlayerName("Garage: "..v.garage.."")
                end
                EndTextCommandSetBlipName(blip)
            end
        end
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    playerloaded = true
    Wait(1000)
    LocalPlayer.state:set( 'loaded', true, true)
    LocalPlayer.state.loaded = true
    if Config.EnableHeliGarage and PlayerData.job ~= nil and helispawn[PlayerData.job.name] ~= nil then
        for k, v in pairs (helispawn[PlayerData.job.name]) do
            local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
            SetBlipSprite (blip, v.Blip.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale  (blip, v.Blip.scale)
            SetBlipColour (blip, v.Blip.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(""..v.garage.."")
            EndTextCommandSetBlipName(blip)
        end
    end
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	playerjob = PlayerData.job.name
    if Config.EnableHeliGarage and PlayerData.job ~= nil and helispawn[PlayerData.job.name] ~= nil then
        for k, v in pairs (helispawn[PlayerData.job.name]) do
            local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
            SetBlipSprite (blip, v.Blip.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale  (blip, v.Blip.scale)
            SetBlipColour (blip, v.Blip.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName("Garage: "..v.garage.."")
            EndTextCommandSetBlipName(blip)
        end
    end
end)

local drawtext = false
local indist = false


local neargarage = false
function PopUI(name,v,reqdist,event)
    if reqdist == nil then reqdist = 9 end
    local table = {
        ['event'] = 'opengarage',
        ['title'] = 'Garage '..name,
        ['server_event'] = false,
        ['unpack_arg'] = false,
        ['invehicle_title'] = 'Store Vehicle',
        ['confirm'] = '[ENTER]',
        ['reject'] = '[CLOSE]',
        ['custom_arg'] = {}, -- example: {1,2,3,4}
        ['use_cursor'] = false, -- USE MOUSE CURSOR INSTEAD OF INPUT (ENTER)
    }
    TriggerEvent('renzu_popui:showui',table)
    local dist = #(v - GetEntityCoords(PlayerPedId()))
    while dist < reqdist and neargarage do
        dist = #(v - GetEntityCoords(PlayerPedId()))
        Wait(100)
    end
    TriggerEvent('renzu_popui:closeui')
end

function ShowFloatingHelpNotification(msg, coords, disablemarker, i)
    AddTextEntry('FloatingHelpNotificationsc'..i, msg)
    SetFloatingHelpTextWorldPosition(1, coords+vector3(0,0,0.3))
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('FloatingHelpNotificationsc'..i)
    EndTextCommandDisplayHelp(2,0, 0, -1)
end

local markers = {}
local drawsleep = 1
function DrawInteraction(i,v,reqdist,msg,event,server,var,disablemarker)
    local i = i
    if not markers[i] and i ~= nil and not inGarage then
        local ped = PlayerPedId()
        local inveh = IsPedInAnyVehicle(ped)
        Citizen.CreateThread(function()
            markers[i] = true
            --local reqdist = reqdist[2]
            local coord = v
            local dist = #(GetEntityCoords(ped) - coord)
            while dist < reqdist[2] do
                if inveh ~= IsPedInAnyVehicle(ped) then
                    break
                end
                drawsleep = 1
                dist = #(GetEntityCoords(ped) - coord)
                if not disablemarker then
                    DrawMarker(27, coord.x,coord.y,coord.z-0.8, 0, 0, 0, 0, 0, 0, 0.7, 0.7, 0.7, 200, 255, 255, 255, 0, 0, 1, 1, 0, 0, 0)
                end
                if dist < reqdist[1] then ShowFloatingHelpNotification(msg, coord, disablemarker , i) end
                if dist < reqdist[1] and IsControlJustReleased(1, 51) then
                    ShowFloatingHelpNotification(msg, coord, disablemarker , i)
                    if not server then
                        TriggerEvent(event,i,var)
                    elseif server then
                        TriggerServerEvent(event,i,var)
                    end
                    Wait(1000)
                    break
                end
                Wait(drawsleep)
            end
            ClearAllHelpMessages()
            markers[i] = false
        end)
    end
end

function DrawZuckerburg(name,v,reqdist)
    if inGarage then Config.UseMarker = true return end
    CreateThread(function()
        local reqdist = reqdist
        dist = #(v - GetEntityCoords(PlayerPedId()))
        while dist < reqdist and neargarage and not inGarage do
            dist = #(v - GetEntityCoords(PlayerPedId()))
            DrawMarker(36, v.x,v.y,v.z+0.5, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.7, 200, 10, 10, 100, 0, 0, 1, 1, 0, 0, 0)
            Wait(1)
        end
        Config.UseMarker = true
    end)
end

CreateThread(function()
    while PlayerData.job == nil do Wait(100) end
    Wait(500)
    if not Config.UsePopUI and Config.floatingtext then
        while true do
            local mycoord = GetEntityCoords(PlayerPedId())
            local inveh = IsPedInAnyVehicle(PlayerPedId())
            for k,v in pairs(garagecoord) do
                local vec = vector3(v.garage_x,v.garage_y,v.garage_z)
                local req_dis = v.Dist
                if inveh and v.store_x ~= nil then
                    vec = vector3(v.store_x,v.store_y,v.store_z)
                    req_dis = v.Store_dist
                end
                local dist = #(vec - mycoord)
                if Config.UseMarker and dist < Config.MarkerDistance then
                    Config.UseMarker = false
                    DrawZuckerburg(v.garage,vec,Config.MarkerDistance)
                end
                if dist < req_dis then
                    tid = k
                    garageid = v.garage
                    neargarage = true
                    --PopUI(v.garage,vec,req_dis)
                    if IsPedInAnyVehicle(PlayerPedId()) then
                        msg = 'Press [E] Store Vehicle'
                    else
                        msg = 'Press [E] 🏚️ Garage '..v.garage
                    end
                    DrawInteraction(v.garage,vec,{req_dis,req_dis*3},msg,'opengarage',false,false,false)
                end
            end
            if Config.EnableImpound then
                for k,v in pairs(impoundcoord) do
                    local vec = vector3(v.garage_x,v.garage_y,v.garage_z)
                    local dist = #(vec - mycoord)
                    if dist < v.Dist then
                        tid = k
                        garageid = v.garage
                        neargarage = true
                        --PopUI(v.garage,vec)
                        if IsPedInAnyVehicle(PlayerPedId()) then
                            msg = 'Press [E] Store Vehicle'
                        else
                            msg = 'Press [E] ⛍ Garage '..v.garage
                        end
                        DrawInteraction(v.garage,vec,{v.Dist,v.Dist*3},msg,'opengarage',false,false,false)
                    end
                end
            end
            if Config.EnableHeliGarage and PlayerData.job ~= nil and helispawn[PlayerData.job.name] ~= nil then
                for k,v in pairs(helispawn[PlayerData.job.name]) do
                    local vec = vector3(v.coords.x,v.coords.y,v.coords.z)
                    local dist = #(vec - mycoord)
                    if dist < v.distance then
                        tid = k
                        garageid = v.garage
                        neargarage = true
                        if IsPedInAnyVehicle(PlayerPedId()) then
                            msg = 'Press [E] Store Helicopter'
                        else
                            msg = 'Press [E] 🛸 Garage '..v.garage
                        end
                        DrawInteraction(v.garage,vec,{10,15},msg,'opengarage',false,false,false)
                        --PopUI(v.garage,vec)
                    end
                end
            end
            Wait(1000)
        end
    end
    if Config.UsePopUI and not Config.floatingtext then
        while true do
            local mycoord = GetEntityCoords(PlayerPedId())
            local inveh = IsPedInAnyVehicle(PlayerPedId())
            for k,v in pairs(garagecoord) do
                local vec = vector3(v.garage_x,v.garage_y,v.garage_z)
                local req_dis = v.Dist
                if inveh and v.store_x ~= nil then
                    vec = vector3(v.store_x,v.store_y,v.store_z)
                    req_dis = v.Store_dist
                end
                local dist = #(vec - mycoord)
                if Config.UseMarker and dist < Config.MarkerDistance then
                    Config.UseMarker = false
                    DrawZuckerburg(v.garage,vec,Config.MarkerDistance)
                end
                if dist < req_dis then
                    tid = k
                    garageid = v.garage
                    neargarage = true
                    PopUI(v.garage,vec,req_dis)
                end
            end
            if Config.EnableImpound then
                for k,v in pairs(impoundcoord) do
                    local vec = vector3(v.garage_x,v.garage_y,v.garage_z)
                    local dist = #(vec - mycoord)
                    if dist < v.Dist then
                        tid = k
                        garageid = v.garage
                        neargarage = true
                        PopUI(v.garage,vec)
                    end
                end
            end
            if Config.EnableHeliGarage and PlayerData.job ~= nil and helispawn[PlayerData.job.name] ~= nil then
                for k,v in pairs(helispawn[PlayerData.job.name]) do
                    local vec = vector3(v.coords.x,v.coords.y,v.coords.z)
                    local dist = #(vec - mycoord)
                    if dist < 10 then
                        tid = k
                        garageid = v.garage
                        neargarage = true
                        PopUI(v.garage,vec)
                    end
                end
            end
            Wait(1000)
        end
    end
end)


local jobgarage = false
local garagejob = nil
local ispolice = false
RegisterNetEvent('opengarage')
AddEventHandler('opengarage', function()
    local sleep = 2000
    local ped = PlayerPedId()
    local vehiclenow = GetVehiclePedIsIn(PlayerPedId(), false)
    jobgarage = false
    garagejob = nil
    for k,v in pairs(garagecoord) do
        if not v.property then
            local actualShop = v
            local dist = #(vector3(v.garage_x,v.garage_y,v.garage_z) - GetEntityCoords(ped))
            jobgarage = false
            if v.job ~= nil then
                if string.find(v.garage, "impound") then
                    jobgarage = false
                else
                    jobgarage = true
                end
            end
            if DoesEntityExist(vehiclenow) then
                local req_dist = v.Store_dist or v.Dist
                if dist <= req_dist and not jobgarage and not string.find(v.garage, "impound") or dist <= 7.0 and PlayerData.job ~= nil and PlayerData.job.name == v.job and jobgarage and not string.find(v.garage, "impound") then
                    garageid = v.garage
                    Storevehicle(vehiclenow,false,false,v.garage_type == 'public' or false)
                    break
                end
            elseif not DoesEntityExist(vehiclenow) then
                if dist <= v.Dist and not jobgarage and not string.find(v.garage, "impound") or dist <= 7.0 and PlayerData.job ~= nil and PlayerData.job.name == v.job and jobgarage and not string.find(v.garage, "impound") then
                    garageid = v.garage
                    tid = k
                    TriggerEvent('notifications', 'info','Garage', "Opening Garage...Please wait..")
                    TriggerServerEvent("renzu_garage:GetVehiclesTable",garageid,v.garage_type == 'public' or false)
                    fetchdone = false
                    garage_public = v.garage_type == 'public' or false
                    while not fetchdone do
                        Wait(0)
                    end
                    type = v.Type
                    if jobgarage then
                        garagejob = v.job
                    end
                    propertygarage = false
                    OpenGarage(v.garage,v.Type,garagejob or false,v.default_vehicle or {})
                    break
                end
            end
            if dist > 11 or ingarage then
                indist = false
            end
        end
    end


    --IMPOUND

    if Config.EnableImpound then
        for k,v in pairs(impoundcoord) do
            local actualShop = v
            local dist = #(vector3(v.garage_x,v.garage_y,v.garage_z) - GetEntityCoords(ped))
            if v.job ~= nil then
                jobgarage = true
                ispolice = PlayerData.job.name == v.job
            end
            if DoesEntityExist(vehiclenow) then
                if dist <= v.Dist and not jobgarage or dist <= 3.0 and PlayerData.job ~= nil and PlayerData.job.name == v.job and jobgarage then
                    garageid = v.garage
                    Storevehicle(vehiclenow)
                    break
                end
            elseif not DoesEntityExist(vehiclenow) then
                if dist <= v.Dist and Impoundforall or not Impoundforall and dist <= 3.0 and PlayerData.job ~= nil and PlayerData.job.name == v.job and jobgarage then
                    garageid = v.garage
                    TriggerEvent('notifications', 'info','Garage', "Opening Impound...Please wait..")
                    TriggerServerEvent("renzu_garage:GetVehiclesTableImpound")
                    fetchdone = false
                    while not fetchdone do
                        Wait(0)
                    end
                    OpenImpound(v.garage)
                    break
                end
            end
            if dist > 11 or ingarage then
                indist = false
            end
        end
    end


    if Config.EnableHeliGarage and PlayerData.job ~= nil and helispawn[PlayerData.job.name] ~= nil then
        for k,v in pairs(helispawn[PlayerData.job.name]) do
            local coord = v.coords
            local v = v.coords
            local dist = #(vector3(coord.x,coord.y,coord.z) - GetEntityCoords(ped))
            if DoesEntityExist(vehiclenow) then
                if dist <= 7.0 then
                    helidel(vehiclenow)
                    break
                end
            elseif not DoesEntityExist(vehiclenow) then
                if dist <= 10.0 then
                    TriggerEvent("renzu_garage:getchopper",PlayerData.job.name, PlayerData.job.grade, heli[PlayerData.job.name])
                    break
                end
            end
            if dist > 11 or ingarage then
                indist = false
            end
        end
    end
end)

local OwnedVehicles = {}
local VTable = {}

function GetPerformanceStats(vehicle)
    local data = {}
    data.brakes = GetVehicleModelMaxBraking(vehicle)
    local handling1 = GetVehicleModelMaxBraking(vehicle)
    local handling2 = GetVehicleModelMaxBrakingMaxMods(vehicle)
    local handling3 = GetVehicleModelMaxTraction(vehicle)
    data.handling = (handling1+handling2) * handling3
    return data
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
    if Config.use_RenzuCustoms then
        exports.renzu_customs:SetVehicleProp(vehicle,mods)
    else
        props = mods
        -- https://github.com/esx-framework/es_extended/tree/v1-final COPYRIGHT
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
end

function GetVehicleProperties(vehicle)
    if Config.use_RenzuCustoms then
        local mods = exports.renzu_customs:GetVehicleProperties(vehicle)
        if not Config.ReturnDamage then
            return mods
        end
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
        Wait(500)
        for windowid = 0, 7 do
            mods.vehicle_window[#mods.vehicle_window+1] = IsVehicleWindowIntact(vehicle, windowid)
        end
        return mods
    else
        if DoesEntityExist(vehicle) then
            -- https://github.com/esx-framework/es_extended/tree/v1-final COPYRIGHT
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
                if not Config.PlateSpace then
                    plate = string.gsub(tostring(GetVehicleNumberPlateText(vehicle)), '^%s*(.-)%s*$', '%1')
                end
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
    end
end

local owned_veh = {}
RegisterNetEvent('renzu_garage:receive_vehicles')
AddEventHandler('renzu_garage:receive_vehicles', function(tb, vehdata)
    fetchdone = false
    OwnedVehicles = nil
    Wait(100)
    OwnedVehicles = {}
    tableVehicles = nil
    tableVehicles = tb
    local vehdata = vehdata
    vehiclesdb = vehdata
    if vehdata == nil then
        vehdata = {}
    end
    local vehicle_data = {}
    for _,value in pairs(vehdata) do
        vehicle_data[value.model] = value.name
    end

    OwnedVehicles['garage'] = {}
    local gstate = GlobalState and GlobalState.VehicleImages
    for _,value in pairs(tableVehicles) do
        local props = json.decode(value.vehicle)
        if IsModelInCdimage(props.model) then
            local vehicleModel = tonumber(props.model)  
            local label = nil
            if label == nil then
                label = 'Unknown'
            end

            local vehname = nil
            for _,value in pairs(vehdata) do -- fetch vehicle names from vehicles sql table
                if tonumber(props.model) == GetHashKey(value.model) then
                    vehname = value.name
                    break
                end
            end

            --local vehname = vehicle_data[GetDisplayNameFromVehicleModel(tonumber(props.model))]

            if vehname == nil then
                vehname = GetLabelText(GetDisplayNameFromVehicleModel(tonumber(props.model)):lower())
            end
            if props ~= nil and props.engineHealth ~= nil and props.engineHealth < 100 then
                props.engineHealth = 200
            end
            local pmult, tmult, handling, brake = 1000,800,GetPerformanceStats(vehicleModel).handling,GetPerformanceStats(vehicleModel).brakes
            if value.type == 'boat' or value.type == 'plane' then
                pmult,tmult,handling, brake = 10,8,GetPerformanceStats(vehicleModel).handling * 0.1, GetPerformanceStats(vehicleModel).brakes * 0.1
            end
            if value.job == '' then
                value.job = nil
            end
            local havejob = false
            for k,v in pairs(jobgarages) do
                if value.job ~= nil and v.job == value.job then
                    havejob = true
                end
            end
            if value.job ~= nil and not havejob then -- fix incompatibility with vehicles with job column as a default from sql eg. civ fck!
                value.job = nil
            end
            if value.garage_id ~= nil then -- fix blank job column, seperate the car to other non job garages
                for k,v in pairs(jobgarages) do 
                    if v.job ~= nil and value.job ~= nil and v.job == value.job and v.garageid == value.garage_id and #(v.coord - GetEntityCoords(PlayerPedId())) < 20 then
                        value.job = v.job
                    end
                    if v.garage_type and v.garage_type == 'public' and #(v.coord - GetEntityCoords(PlayerPedId())) < 20 then
                        value.garage_type = 'public'
                        value.job = v.job
                    end
                end
                --value.garage_id = jobgarages[value.job].garageid
            end
            local default_thumb = string.lower(GetDisplayNameFromVehicleModel(tonumber(props.model)))
            local img = 'https://cfx-nui-renzu_garage/imgs/uploads/'..default_thumb..'.jpg'
            if Config.use_renzu_vehthumb and gstate[tostring(props.model)] then
                img = gstate[tostring(props.model)]
            end
            local VTable = 
            {
                brand = GetVehicleClassnamemodel(tonumber(props.model)),
                name = vehname:upper(),
                brake = brake,
                handling = handling,
                topspeed = math.ceil(GetVehicleModelEstimatedMaxSpeed(vehicleModel)*4.605936),
                power = math.ceil(GetVehicleModelAcceleration(vehicleModel)*pmult),
                torque = math.ceil(GetVehicleModelAcceleration(vehicleModel)*tmult),
                model = string.lower(GetDisplayNameFromVehicleModel(tonumber(props.model))),
                model2 = tonumber(props.model),
                plate = value.plate,
                img = img,
                props = value.vehicle,
                fuel = props.fuelLevel or 100,
                bodyhealth = props.bodyHealth or 1000,
                enginehealth = props.engineHealth or 1000,
                garage_id = value.garage_id,
                impound = value.impound,
                stored = value.stored,
                identifier = value.owner,
                type = value.type,
                garage_type = value.garage_type ~= nil and value.garage_type or 'personal',
                job = value.job ~= nil,
            }
            table.insert(OwnedVehicles['garage'], VTable)
        end
    end
    fetchdone = true
end)

RegisterNetEvent('renzu_garage:getchopper')
AddEventHandler('renzu_garage:getchopper', function(job, jobgrade, available)
    OwnedVehicles = {}
    Wait(100)
    tableVehicles = {}
    tableVehicles = tb
    local vehdata = vehdata
    local vehicle_data = {}

    for _,value in pairs(available) do
        OwnedVehicles[job] = {}
    end
    local gstate = GlobalState and GlobalState.VehicleImages
    local vehiclecount = 0
    for _,value in pairs(available) do
        if jobgrade >= value.grade then
            vehiclecount = vehiclecount + 1

            local default_thumb = string.lower(GetDisplayNameFromVehicleModel(value.model))
            local img = 'https://cfx-nui-renzu_garage/imgs/uploads/'..default_thumb..'.jpg'
            if Config.use_renzu_vehthumb and gstate[tostring(GetHashKey(value.model))] then
                img = gstate[tostring(GetHashKey(value.model))]
            end
            local vehicleModel = tonumber(value.model)  
            local label = nil
            if label == nil then
                label = 'Unknow'
            end

            local vehname = value.model

            if vehname == nil then
                vehname = GetDisplayNameFromVehicleModel(tonumber(value.model))
            end
            local VTable = 
            {
                brand = GetVehicleClassnamemodel(tonumber(value.model)),
                name = vehname:upper(),
                brake = GetPerformanceStats(vehicleModel).brakes,
                handling = GetPerformanceStats(vehicleModel).handling,
                topspeed = math.ceil(GetVehicleModelEstimatedMaxSpeed(vehicleModel)*4.605936),
                power = math.ceil(GetVehicleModelAcceleration(vehicleModel)*1000),
                torque = math.ceil(GetVehicleModelAcceleration(vehicleModel)*800),
                model = value.model,
                model2 = value.model,
                plate = value.plate,
                img = img,
                props = value.vehicle,
                fuel = 100,
                bodyhealth = 1000,
                enginehealth = 1000,
                garage_id = job,
                impound = 0,
                stored = 1
            }
            table.insert(OwnedVehicles[job], VTable)
        end
    end
    fetchdone = true
    if vehiclecount > 0 then
        OpenHeli(job, jobgrade)
    else
        TriggerEvent('notifications', 'info','Garage', "Es steht kein Helicopter für dein Rang zur verfügung..")
    end
end)

local Charset = {}
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GetRandomLetter(length)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

function LetterRand()
    local emptyString = {}
    local randomLetter;
    while (#emptyString < 6) do
        randomLetter = GetRandomLetter(1)
        table.insert(emptyString,randomLetter)
        Wait(0)
    end
    local a = string.format("%s%s%s", table.unpack(emptyString)):upper()  -- "2 words"
    return a
end

local patrolcars = {}
function CreateDefault(default,jobonly,garage_type,garageid)
    patrolcars = {}
    local gstate = GlobalState and GlobalState.VehicleImages
    for k,v in pairs(default) do
        if v.grade <= PlayerData.job.grade then
            local vehicleModel = GetHashKey(v.model)
            local pmult, tmult, handling, brake = 1000,800,GetPerformanceStats(vehicleModel).handling,GetPerformanceStats(vehicleModel).brakes
            if v.type == 'boat' or v.type == 'plane' then
                pmult,tmult,handling, brake = 10,8,GetPerformanceStats(vehicleModel).handling * 0.1, GetPerformanceStats(vehicleModel).brakes * 0.1
            end
            local default_thumb = string.lower(GetDisplayNameFromVehicleModel(vehicleModel))
            local img = 'https://cfx-nui-renzu_garage/imgs/uploads/'..default_thumb..'.jpg'
            if Config.use_renzu_vehthumb and gstate[tostring(vehicleModel)] then
                img = gstate[tostring(vehicleModel)]
            end
            local genplate = v.plateprefix..' '..math.random(100,999)
            patrolcars[genplate] = true
            local VTable = {
                brand = GetVehicleClassnamemodel(tonumber(vehicleModel)),
                name = v.name:upper(),
                brake = brake,
                handling = handling,
                topspeed = math.ceil(GetVehicleModelEstimatedMaxSpeed(vehicleModel)*4.605936),
                power = math.ceil(GetVehicleModelAcceleration(vehicleModel)*pmult),
                torque = math.ceil(GetVehicleModelAcceleration(vehicleModel)*tmult),
                model = v.model,
                model2 = tonumber(vehicleModel),
                plate = genplate,
                props = json.encode({model = vehicleModel, plate = genplate}),
                fuel = 100,
                bodyhealth = 1000,
                enginehealth = 1000,
                garage_id = garageid,
                impound = 0,
                stored = 1,
                identifier = jobonly,
                type = garage_type,
                job = jobonly,
            }
            table.insert(OwnedVehicles['garage'], VTable)
        end
    end
end

local cat = nil
RegisterNUICallback(
    "choosecat",
    function(data, cb)
        cat = data.cat or 'all'
    end
)

function OpenGarage(garageid,garage_type,jobonly,default)
    inGarage = true
    local ped = PlayerPedId()
    if not Config.Quickpick and garage_type == 'car' and propertyspawn.x == nil then
        CreateGarageShell()
    end
    while not fetchdone do
    Citizen.Wait(333)
    end
    local vehtable = {}
    vehtable[garageid] = {}
    local cars = 0
    CreateDefault(default,jobonly,garage_type,garageid)
    local cats = {}
    local totalcats = 0
    for k,v2 in pairs(OwnedVehicles) do
        for k2,v in pairs(v2) do
            if Config.UniqueCarperGarage and garageid == v.garage_id and garage_type == v.type and v.garage_id ~= 'private' and propertyspawn.x == nil
            or not Config.UniqueCarperGarage and garageid ~= nil and garage_type == v.type and jobonly == false and not v.job and v.garage_id ~= 'private' and propertyspawn.x == nil
            -- personal job garage
            or not Config.UniqueCarperGarage and garageid ~= nil and garage_type == v.type and jobonly == PlayerData.job.name and garageid == v.garage_id and not string.find(v.garage_id, "impound") and v.garage_id ~= 'private' and propertyspawn.x == nil
            -- public job garage
            or v.garage_type == 'public' and garageid ~= nil and garage_type == v.type and jobonly == PlayerData.job.name and garageid == v.garage_id and not string.find(v.garage_id, "impound") and v.garage_id ~= 'private' and propertyspawn.x == nil
            --
            or string.find(garageid, "impound") and string.find(v.garage_id, "impound") and garage_type == v.type and propertyspawn.x == nil
            or propertyspawn.x ~= nil and Config.UniqueProperty and garage_type == v.type and jobonly == false and not v.job and v.garage_id == garageid
            or propertyspawn.x ~= nil and not Config.UniqueProperty and garage_type == v.type and jobonly == false and not v.job and v.garage_id ~= 'private' then
                v.brand = v.brand:upper()
                if v.stored and ImpoundedLostVehicle or not ImpoundedLostVehicle then
                    if cats[v.brand] == nil then
                        cats[v.brand] = 0
                        totalcats = totalcats + 1
                    end
                    cats[v.brand] = cats[v.brand] + 1
                    SetNuiFocus(true, true)
                end
            end
        end
    end
    if totalcats > 1 then
        SendNUIMessage(
            {
                cats = cats,
                type = "cats"
            }
        )
        while cat == nil do Wait(1000) end
    end
    for k,v2 in pairs(OwnedVehicles) do
        for k2,v in pairs(v2) do
            if Config.UniqueCarperGarage and garageid == v.garage_id and garage_type == v.type and v.garage_id ~= 'private' and propertyspawn.x == nil
            or not Config.UniqueCarperGarage and garageid ~= nil and garage_type == v.type and jobonly == false and not v.job and v.garage_id ~= 'private' and propertyspawn.x == nil
            -- personal job garage
            or not Config.UniqueCarperGarage and garageid ~= nil and garage_type == v.type and jobonly == PlayerData.job.name and garageid == v.garage_id and not string.find(v.garage_id, "impound") and v.garage_id ~= 'private' and propertyspawn.x == nil
            -- public job garage
            or v.garage_type == 'public' and not Config.UniqueCarperGarage and garageid ~= nil and garage_type == v.type and jobonly == PlayerData.job.name and garageid == v.garage_id and not string.find(v.garage_id, "impound") and v.garage_id ~= 'private' and propertyspawn.x == nil
            --
            or string.find(garageid, "impound") and string.find(v.garage_id, "impound") and garage_type == v.type and propertyspawn.x == nil
            or propertyspawn.x ~= nil and Config.UniqueProperty and garage_type == v.type and jobonly == false and not v.job and v.garage_id == garageid
            or propertyspawn.x ~= nil and not Config.UniqueProperty and garage_type == v.type and jobonly == false and not v.job and v.garage_id ~= 'private' then
                if cat ~= nil and totalcats > 1 and v.brand:upper() == cat:upper() and not ImpoundedLostVehicle or totalcats == 1 and not ImpoundedLostVehicle or cat == nil and not ImpoundedLostVehicle 
                or cat ~= nil and totalcats > 1 and v.brand:upper() == cat:upper() and ImpoundedLostVehicle and v.stored or totalcats == 1 and ImpoundedLostVehicle and v.stored or cat == nil and ImpoundedLostVehicle and v.stored then
                    cars = cars + 1
                    if string.find(v.garage_id, "impound") or v.garage_id == nil then
                        v.garage_id = 'A'
                    end
                    if vehtable[v.garage_id] == nil then
                        vehtable[v.garage_id] = {}
                    end
                    veh = 
                    {
                    brand = v.brand or 1.0,
                    name = v.name or 1.0,
                    brake = v.brake or 1.0,
                    handling = v.handling or 1.0,
                    topspeed = v.topspeed or 1.0,
                    power = v.power or 1.0,
                    torque = v.torque or 1.0,
                    model = v.model,
                    model2 = v.model2,
                    img = v.img,
                    plate = v.plate,
                    --props = v.props,
                    fuel = v.fuel or 100.0,
                    bodyhealth = v.bodyhealth or 1000.0,
                    enginehealth = v.enginehealth or 1000.0,
                    garage_id = v.garage_id or 'A',
                    impound = v.impound or 0,
                    ingarage = v.ingarage or false
                    }
                    table.insert(vehtable[v.garage_id], veh)
                end
            end
        end
    end
    lastcat = cat
    cat = nil
    if cars > 0 then
        SendNUIMessage(
            {
                garage_id = garageid,
                data = vehtable,
                type = "display"
            }
        )

        SetNuiFocus(true, true)
        if not Config.Quickpick and garage_type == 'car' then
            --RequestCollisionAtCoord(926.15, -959.06, 61.94-30.0)
            for k,v in pairs(garagecoord) do
                local dist = #(vector3(v.garage_x,v.garage_y,v.garage_z) - GetEntityCoords(ped))
                if dist <= 40.0 and garageid == v.garage then
                    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", v.garage_x-4.0, v.garage_y, v.garage_z+21.0, 360.00, 0.00, 0.00, 60.00, false, 0)
                    PointCamAtCoord(cam, v.garage_x, v.garage_y, v.garage_z+21.0)
                    SetCamActive(cam, true)
                    RenderScriptCams(true, true, 1, true, true)
                    SetFocusPosAndVel(v.garage_x, v.garage_y, v.garage_z-30.0, 0.0, 0.0, 0.0)
                    SetCamFov(cam, 48.0)
                    SetCamRot(cam, -15.0, 0.0, 252.063)
                    DisplayHud(false)
                    DisplayRadar(false)
                end
            end
            ingarage = true
        end
        while inGarage do
            SetNuiFocus(true, true)
            SetNuiFocusKeepInput(false)
            Citizen.Wait(111)
        end

        if LastVehicleFromGarage ~= nil then
            DeleteEntity(LastVehicleFromGarage)
        end
    else
        TriggerEvent('notifications', 'info','Garage', 'You dont have any vehicle')
    --    if not propertyspawn.x then
    --        SetEntityCoords(PlayerPedId(), garagecoord[tid].garage_x,garagecoord[tid].garage_y,garagecoord[tid].garage_z, false, false, false, true)
    --    else
    --        SetEntityCoords(PlayerPedId(), propertyspawn.x,propertyspawn.y,propertyspawn.z, false, false, false, true)
    --    end
        CloseNui()
    end

end


function OpenHeli(garageid, jobgrade)
    inGarage = true
    local ped = PlayerPedId()
    while not fetchdone do
    Citizen.Wait(333)
    end
    local vehtable = {}
    for k,v2 in pairs(OwnedVehicles) do
        for k2,v in pairs(v2) do
            if vehtable[v.garage_id] == nil then
                vehtable[v.garage_id] = {}
            end
            veh = 
            {
            brand = v.brand,
            name = v.name,
            brake = v.brake,
            handling = v.handling,
            topspeed = v.topspeed,
            power = v.power,
            torque = v.torque,
            model = v.model,
            model2 = v.model2,
            img = v.img,
            plate = v.plate,
            --props = v.props,
            fuel = v.fuel,
            bodyhealth = v.bodyhealth,
            enginehealth = v.enginehealth,
            garage_id = v.garage_id,
            impound = v.impound,
            ingarage = v.ingarage
            }
            table.insert(vehtable[v.garage_id], veh)
        end
    end
    SendNUIMessage(
        {
            garage_id = garageid,
            data = vehtable,
            type = "display",
            chopper = true
        }
    )
    SetNuiFocus(true, true)
    if not Config.Quickpick then
        for k,v in pairs(helispawn[garageid]) do
            local v = v.coords
            local dist = #(vector3(v.x,v.y,v.z) - GetEntityCoords(ped))
            if dist <= 10.0 then
                cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", v.x-8.0, v.y, v.z+0.6, 360.00, 0.00, 0.00, 60.00, false, 0)
                PointCamAtCoord(cam, v.x, v.y, v.z+2.0)
                SetCamActive(cam, true)
                RenderScriptCams(true, true, 1, true, true)
                SetFocusPosAndVel(v.x, v.y, v.z+4.0, 0.0, 0.0, 0.0)
                DisplayHud(false)
                DisplayRadar(false)
            end
        end
    end
    while inGarage do
        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(false)
        Citizen.Wait(111)
    end
    if LastVehicleFromGarage ~= nil then
        DeleteEntity(LastVehicleFromGarage)
    end
end


function OpenImpound(garageid)
    inGarage = true
    local ped = PlayerPedId()
    while not fetchdone do
    Citizen.Wait(333)
    end
    local vehtable = {}
    local c = 0
    local nearbyvehicles = {}
    local gameVehicles = GetAllVehicleFromPool()
    for i = 1, #gameVehicles do
        local vehicle = gameVehicles[i]
        if DoesEntityExist(vehicle) then
            local otherplate = string.gsub(tostring(GetVehicleNumberPlateText(vehicle)), '^%s*(.-)%s*$', '%1'):upper()
            local plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()
            if #(GetEntityCoords(ped) - GetEntityCoords(vehicle)) < 50 then
                nearbyvehicles[otherplate] = true
            end
        end
    end
    for k,v2 in pairs(OwnedVehicles) do
        for k2,v in pairs(v2) do
            if v.garage_id == 'impound' then
                v.garage_id = impoundcoord[1].garage
            end
            if ImpoundedLostVehicle and not v.stored and not string.find(v.garage_id, "impound") then
                v.impound = 1
                v.garage_id = impoundcoord[1].garage
            end
            local plate = string.gsub(tostring(v.plate), '^%s*(.-)%s*$', '%1'):upper()

            if Config.UniqueCarperImpoundGarage then
                if v.garage_id ~= 'private' and not nearbyvehicles[plate] and garageid == v.garage_id and v.impound and ispolice or v.garage_id ~= 'private' and not nearbyvehicles[plate] and garageid == v.garage_id and Impoundforall and v.identifier == PlayerData.identifier then
                    c = c + 1
                    if vehtable[v.impound] == nil then
                        vehtable[v.impound] = {}
                    end
                    veh = 
                    {
                    brand = v.brand or 1.0,
                    name = v.name or 1.0,
                    brake = v.brake or 1.0,
                    handling = v.handling or 1.0,
                    topspeed = v.topspeed or 1.0,
                    power = v.power or 1.0,
                    torque = v.torque or 1.0,
                    model = v.model,
                    img = v.img,
                    model2 = v.model2,
                    plate = v.plate,
                    --props = v.props,
                    fuel = v.fuel or 100.0,
                    bodyhealth = v.bodyhealth or 1000.0,
                    enginehealth = v.enginehealth or 1000.0,
                    garage_id = v.garage_id or 'A',
                    impound = v.impound or 0,
                    ingarage = v.ingarage or 0,
                    impound = v.impound or 0,
                    stored = v.stored or 0,
                    identifier = v.identifier or '',
                    impound_date = v.impound_date or -1
                    }
                    table.insert(vehtable[v.impound], veh)
                end
            else
                if v.garage_id ~= 'private' and not nearbyvehicles[plate] and v.impound and ispolice or v.garage_id ~= 'private' and not nearbyvehicles[plate] and garageid == v.garage_id and Impoundforall and v.identifier == PlayerData.identifier then
                    c = c + 1
                    if vehtable[v.impound] == nil then
                        vehtable[v.impound] = {}
                    end
                    veh = 
                    {
                    brand = v.brand or 1.0,
                    name = v.name or 1.0,
                    brake = v.brake or 1.0,
                    handling = v.handling or 1.0,
                    topspeed = v.topspeed or 1.0,
                    power = v.power or 1.0,
                    torque = v.torque or 1.0,
                    model = v.model,
                    img = v.img,
                    model2 = v.model2,
                    plate = v.plate,
                    --props = v.props,
                    fuel = v.fuel or 100.0,
                    bodyhealth = v.bodyhealth or 1000.0,
                    enginehealth = v.enginehealth or 1000.0,
                    garage_id = v.garage_id or 'A',
                    impound = v.impound or 0,
                    ingarage = v.ingarage or 0,
                    impound = v.impound or 0,
                    stored = v.stored or 0,
                    identifier = v.identifier or '',
                    impound_date = v.impound_date or -1
                    }
                    table.insert(vehtable[v.impound], veh)
                end
            end
        end
    end
    if c > 0 then
        if not Config.Quickpick then
            CreateGarageShell()
        end
        SendNUIMessage(
            {
                garage_id = garageid,
                data = vehtable,
                type = "display"
            }
        )
        SetNuiFocus(true, true)
        if not Config.Quickpick then
            --  RequestCollisionAtCoord(926.15, -959.06, 61.94-30.0)
            for k,v in pairs(impoundcoord) do
                local dist = #(vector3(v.garage_x,v.garage_y,v.garage_z) - GetEntityCoords(PlayerPedId()))
                if dist <= 70.0 then
                    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", v.garage_x-5.0, v.garage_y, v.garage_z+22.0, 360.00, 0.00, 0.00, 60.00, false, 0)
                    PointCamAtCoord(cam, v.garage_x, v.garage_y, v.garage_z+20.0)
                    SetCamActive(cam, true)
                    RenderScriptCams(true, true, 1, true, true)
                    SetFocusPosAndVel(v.garage_x, v.garage_y, v.garage_z-30.0, 0.0, 0.0, 0.0)
                    DisplayHud(false)
                    DisplayRadar(false)
                end
            end
        end
        while inGarage do
            SetNuiFocusKeepInput(false)
            SetNuiFocus(true, true)
            Citizen.Wait(111)
        end

        if LastVehicleFromGarage ~= nil then
            DeleteEntity(LastVehicleFromGarage)
        end
    else
        SetEntityCoords(PlayerPedId(), impoundcoord[tid].garage_x,impoundcoord[tid].garage_y,impoundcoord[tid].garage_z, false, false, false, true)
        CloseNui()
        TriggerEvent('notifications', 'info','Garage', 'You dont have any vehicle in this garage')
    end

end

local inshell = false
function InGarageShell(bool)
    if bool == 'enter' then
        inshell = true
        while inshell do
            Citizen.Wait(0)
            NetworkOverrideClockTime(16, 00, 00)
        end
    elseif bool == 'exit' then
        inshell = false
    end
end

function GetVehicleLabel(vehicle)
    local vehicleLabel = string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
    if vehicleLabel ~= 'null' or vehicleLabel ~= 'carnotfound' or vehicleLabel ~= 'NULL'then
        local text = GetLabelText(vehicleLabel)
        if text == nil or text == 'null' or text == 'NULL' then
            vehicleLabel = vehicleLabel
        else
            vehicleLabel = text
        end
    end
    return vehicleLabel
end

function SetCoords(ped, x, y, z, h, freeze)
    RequestCollisionAtCoord(x, y, z)
    while not HasCollisionLoadedAroundEntity(ped) do
        RequestCollisionAtCoord(x, y, z)
        Citizen.Wait(1)
    end
    DoScreenFadeOut(950)
    Wait(1000)                            
    SetEntityCoords(ped, x, y, z)
    SetEntityHeading(ped, h)
    DoScreenFadeIn(3000)
end

local shell = nil
function CreateGarageShell()
    local ped = PlayerPedId()
    garage_coords = GetEntityCoords(ped)+vector3(0,0,20)
    local count = 0
    local model = GetHashKey('garage')
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(10)
    end
    shell = CreateObject(model, garage_coords.x, garage_coords.y, garage_coords.z, false, false, false)
    while not DoesEntityExist(shell) do Wait(0) end
    FreezeEntityPosition(shell, true)
    SetModelAsNoLongerNeeded(model)
    shell_door_coords = vector3(garage_coords.x+7, garage_coords.y-17, garage_coords.z)
    SetCoords(ped, shell_door_coords.x, shell_door_coords.y, shell_door_coords.z, 82.0, true)
end

local spawnedgarage = {}

function GetVehicleUpgrades(vehicle)
    local stats = {}
    props = GetVehicleProperties(vehicle)
    stats.engine = props.modEngine+1
    stats.brakes = props.modBrakes+1
    stats.transmission = props.modTransmission+1
    stats.suspension = props.modSuspension+1
    if props.modTurbo == 1 then
        stats.turbo = 1
    elseif props.modTurbo == false then
        stats.turbo = 0
    end
    return stats
end

function GetMaxMod(vehicle,index)
    local max = GetNumVehicleMods(vehicle, tonumber(index))
    return max
end

function GetVehicleStats(vehicle)
    local data = {}
    data.acceleration = GetVehicleModelAcceleration(GetEntityModel(vehicle))
    data.brakes = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fBrakeForce')
    local fInitialDriveMaxFlatVel = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fInitialDriveMaxFlatVel')
    data.topspeed = math.ceil(fInitialDriveMaxFlatVel * 1.3)
    local fTractionBiasFront = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fTractionBiasFront')
    local fTractionCurveMax = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fTractionCurveMax')
    local fTractionCurveMin = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fTractionCurveMin')
    data.handling = (fTractionBiasFront + fTractionCurveMax * fTractionCurveMin)
    return data
end

function classlist(class)
    if class == '0' then
        name = 'Compacts'
    elseif class == '1' then
        name = 'Sedans'
    elseif class == '2' then
        name = 'SUV'
    elseif class == '3' then
        name = 'Coupes'
    elseif class == '4' then
        name = 'Muscle'
    elseif class == '5' then
        name = 'Sports Classic'
    elseif class == '6' then
        name = 'Sports'
    elseif class == '7' then
        name = 'Super'
    elseif class == '8' then
        name = 'Motorcycles'
    elseif class == '9' then
        name = 'Offroad'
    elseif class == '10' then
        name = 'Industrial'
    elseif class == '11' then
        name = 'Utility'
    elseif class == '12' then
        name = 'Vans'
    elseif class == '13' then
        name = 'Cycles'
    elseif class == '14' then
        name = 'Boats'
    elseif class == '15' then
        name = 'Helicopters'
    elseif class == '16' then
        name = 'Planes'
    elseif class == '17' then
        name = 'Service'
    elseif class == '18' then
        name = 'Emergency'
    elseif class == '19' then
        name = 'Military'
    elseif class == '20' then
        name = 'Commercial'
    elseif class == '21' then
        name = 'Trains'
    else
        name = 'CAR'
    end
    return name
end

function GetVehicleClassnamemodel(vehicle)
    local class = tostring(GetVehicleClassFromName(vehicle))
    return classlist(class)
end

function GetVehicleClassname(vehicle)
    local class = tostring(GetVehicleClass(vehicle))
    return classlist(class)
end

local i = 0



local min = 0
local max = 10
local plus = 0
function GarageVehicle()
    Citizen.CreateThread(function()
        while ingarage do
            local sleep = 2000
            local ped = PlayerPedId()
            if ingarage then
                sleep = 0
            end

            if IsControlJustPressed(0, 174) and min >= 10 then
                garageid = garage_id
                for k,v2 in pairs(OwnedVehicles) do
                    for k2,v in pairs(v2) do
                        if garageid == v.garage_id and not string.find(v.garage_id, "impound") then
                            if vehtable[k] == nil then
                                vehtable[k] = {}
                            end
                            if string.find(v.garage_id, "impound") then
                                v.garage_id = 'A'
                            end
                            VTable = 
                            {
                            brand = v.brand,
                            name = v.name,
                            brake = v.brake,
                            handling = v.handling,
                            topspeed = v.topspeed,
                            power = v.power,
                            torque = v.torque,
                            model = v.model,
                            model2 = v.model2,
                            plate = v.plate,
                            props = v.props,
                            fuel = v.fuel,
                            bodyhealth = v.bodyhealth,
                            enginehealth = v.enginehealth,
                            garage_id = v.garage_id,
                            impound = v.impound,
                            ingarage = v.ingarage,
                            stored = v.stored,
                            identifier = v.owner
                            }
                            table.insert(vehtable[k], VTable)
                        end
                    end
                end
                for k,v in pairs(spawnedgarage) do
                    ReqAndDelete(v)
                end
                spawnedgarage = {}
                Citizen.Wait(111)
                local leftx = 4.0
                local lefty = 4.0
                local rightx = 4.0
                local righty = 4.0
                local current = 0
                half = (i / 2)
                if max <= 12 then
                    min = 1
                    max = 10
                    i = 0
                end
                for k2,v2 in pairs(vehtable) do
                    for i2 = 1, #v2 do
                        local v = v2[i2]
                        if min == 1 then
                            min = 0
                        end
                        current = current + 1
                        if i > (max - 10) then
                            i = i -1
                            plus = plus - 1
                            max = max - 1
                            min = min - 1
                            local props = json.decode(v.props)
                            local leftplus = (-4.1 * current)
                            local x = garage_coords.x
                            if current <=5 then
                                x = x - 4.5
                            else
                                x = x + 4.0
                            end
                            if current >= 5 then
                                leftplus = (-4.1 * (current -5))
                            end
                            local lefthead = 225.0
                            local righthead = 125.0
                            CheckWanderingVehicle(props.plate)
                            Citizen.Wait(111)
                            local hash = tonumber(v.model2)
                            local count = 0
                            if not HasModelLoaded(hash) then
                                RequestModel(hash)
                                while not HasModelLoaded(hash) do
                                    RequestModel(hash)
                                    Citizen.Wait(1)
                                end
                            end
                            local indexnew = tonumber('1'..i2..'')
                            spawnedgarage[indexnew] = CreateVehicle(tonumber(v.model2), x,garage_coords.y+leftplus,garage_coords.z, lefthead, 0, 1)
                            SetVehicleProp(spawnedgarage[indexnew], props)
                            SetEntityNoCollisionEntity(spawnedgarage[indexnew], shell, false)
                            SetModelAsNoLongerNeeded(hash)
                            NetworkFadeInEntity(spawnedgarage[indexnew], true, true)
                            if current <=5 then
                                SetEntityHeading(spawnedgarage[indexnew], lefthead)
                            else
                                SetEntityHeading(spawnedgarage[indexnew], righthead)
                            end
                            FreezeEntityPosition(spawnedgarage[indexnew], true)
                        end

                        if current >= 9 then
                            break 
                        end
                    end
                end
                if min <= 9 then
                    min = 0
                    plus = 0
                end
                if max <= 9 then
                    max = 10
                end
                Wait(1000)
            end
            
            if IsControlJustPressed(0, 175) then
                garageid = garage_id
                for k,v2 in pairs(OwnedVehicles) do
                    for k2,v in pairs(v2) do
                        if garageid == v.garage_id and not string.find(v.garage_id, "impound") then
                            if vehtable[k] == nil then
                                vehtable[k] = {}
                            end
                            if string.find(v.garage_id, "impound") then
                                v.garage_id = 'A'
                            end
                            VTable = 
                            {
                            brand = v.brand,
                            name = v.name,
                            brake = v.brake,
                            handling = v.handling,
                            topspeed = v.topspeed,
                            power = v.power,
                            torque = v.torque,
                            price = 1,
                            model = v.model,
                            model2 = v.model2,
                            plate = v.plate,
                            props = v.props,
                            fuel = v.fuel,
                            bodyhealth = v.bodyhealth,
                            enginehealth = v.enginehealth,
                            garage_id = v.garage_id,
                            impound = v.impound,
                            ingarage = v.ingarage,
                            stored = v.stored,
                            identifier = v.owner
                            }
                            table.insert(vehtable[k], VTable)
                        end
                    end
                end
                for k,v in pairs(spawnedgarage) do
                    ReqAndDelete(v)
                end
                spawnedgarage = {}
                Citizen.Wait(111)
                local leftx = 4.0
                local lefty = 4.0
                local rightx = 4.0
                local righty = 4.0
                min = (10 + plus)
                local current = 0
                half = (i / 2)
                for k2,v2 in pairs(vehtable) do
                    for i2 = max, #v2 do
                            local v = v2[i2]
                            i = i + 1
                            current = current + 1
                            if i > min and i < (max + 10) then
                                plus = plus + 1
                                local props = json.decode(v.props)
                                local leftplus = (-4.1 * current)
                                local x = garage_coords.x
                                if current <=5 then
                                    x = x - 4.5
                                else
                                    x = x + 4.0
                                end
                                if current >= 5 then
                                    leftplus = (-4.1 * (current -5))
                                end
                                local lefthead = 225.0
                                local righthead = 125.0
                                CheckWanderingVehicle(props.plate)
                                Citizen.Wait(111)
                                local hash = tonumber(v.model2)
                                local count = 0
                                if not HasModelLoaded(hash) then
                                    RequestModel(hash)
                                    while not HasModelLoaded(hash) do
                                        RequestModel(hash)
                                        Citizen.Wait(1)
                                    end
                                end
                                local indexnew = tonumber('2'..i2..'')
                                spawnedgarage[indexnew] = CreateVehicle(tonumber(v.model2), x,garage_coords.y+leftplus,garage_coords.z, lefthead, 0, 1)
                                SetVehicleProp(spawnedgarage[indexnew], props)
                                SetEntityNoCollisionEntity(spawnedgarage[indexnew], shell, false)
                                SetModelAsNoLongerNeeded(hash)
                                NetworkFadeInEntity(spawnedgarage[indexnew], true, true)
                                if current <=5 then
                                    SetEntityHeading(spawnedgarage[indexnew], lefthead)
                                else
                                    SetEntityHeading(spawnedgarage[indexnew], righthead)
                                end
                                FreezeEntityPosition(spawnedgarage[indexnew], true)
                            end

                            if i >= (max + 10) then
                                break 
                            end
                    end
                end
                max = max + 10
                Wait(1000)
            end
            Citizen.Wait(sleep)
        end
    end)
end

function GetAllVehicleFromPool()
    local list = {}
    for k,vehicle in pairs(GetGamePool('CVehicle')) do
        table.insert(list, vehicle)
    end
    return list
end

RegisterNetEvent('renzu_garage:return')
AddEventHandler('renzu_garage:return', function(v,vehicle,property,actualShop,vp,gid)
    local vp = vp
    local v = v
    FreezeEntityPosition(PlayerPedId(),true)
    ESX.TriggerServerCallback("renzu_garage:returnpayment",function(canreturn)
        if canreturn then
            DoScreenFadeOut(0)
            for k,v in pairs(spawnedgarage) do
                ReqAndDelete(v)
            end
            CheckWanderingVehicle(vp.plate)
            DeleteGarage()
            Citizen.Wait(333)
            SetEntityCoords(PlayerPedId(), v.spawn_x*1.0,v.spawn_y*1.0,v.spawn_z*1.0, false, false, false, true)
            --TaskLeaveVehicle(PlayerPedId(),GetVehiclePedIsIn(PlayerPedId()),1)
            Citizen.Wait(1000)
            local hash = tonumber(vp.model)
            local count = 0
            RequestModel(hash)
            while not HasModelLoaded(hash) do
                Citizen.Wait(10)
                RequestModel(hash)
            end
            Wait(100)
            local vehicle = CreateVehicle(tonumber(vp.model), tonumber(v.spawn_x)*1.0,tonumber(v.spawn_y)*1.0,tonumber(v.spawn_z)*1.0, tonumber(v.heading), 1, 1)
            while not DoesEntityExist(vehicle) do Wait(1) print(vp.model,'loading model') end
            SetVehicleBobo(vehicle)
            Wait(100)
            SetVehicleProp(vehicle, vp)
            SetEntityCoords(GetEntityCoords(vehicle))
            if not property then
                Spawn_Vehicle_Forward(vehicle, vector3(v.spawn_x*1.0,v.spawn_y*1.0,v.spawn_z*1.0))
            end
            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            veh = vehicle
            ESX.TriggerServerCallback("renzu_garage:changestate",function(ret,garage_public)
                if ret and garage_public then
                    local ent = Entity(veh).state
                    while ent.share == nil do Wait(100) end
                    ent.unlock = true
                    local share = ent.share or {}
                    local add = true
                    for k,v in pairs(share) do
                        if k == v.PlayerData.identifier then
                            add = false
                        end
                    end
                    if add then
                        share[PlayerData.identifier] = PlayerData.identifier
                    end
                    ent.share = share
                    ent:set('share', share, true)
                    TriggerServerEvent('statebugupdate','share',share, VehToNet(veh))
                end
            end,vp.plate, 0, gid, vp.model, vp, false, garage_public)
            spawnedgarage = {}
            TriggerEvent('renzu_popui:closeui')
            if property then
                garagecoord[gid] = nil
            end
            ingarage = false
            neargarage = false
            --DeleteGarage()
            DoScreenFadeIn(333)
            i = 0
            min = 0
            max = 10
            plus = 0
            FreezeEntityPosition(PlayerPedId(),false)
        else
            TriggerEvent('notifications', 'error','Garage', 'You dont have a money to pay the delivery')
            LastVehicleFromGarage = nil
            Wait(111)
            SetEntityCoords(PlayerPedId(), garagecoord[tid].garage_x,garagecoord[tid].garage_y,garagecoord[tid].garage_z, false, false, false, true)
            CloseNui()
            i = 0
            min = 0
            max = 10
            plus = 0
            drawtext = false
            indist = false
            SendNUIMessage({
                type = "cleanup"
            })
        end
    end)
end)

DoScreenFadeIn(333)
RegisterNetEvent('renzu_garage:ingaragepublic')
AddEventHandler('renzu_garage:ingaragepublic', function(coords, distance, vehicle, property, propertycoord, gid)
    local dist2 = 2
    if property and gid then
        spawn = propertycoord
        found, spawnPos, spawnHeading = GetClosestVehicleNodeWithHeading(spawn.x + math.random(1, 2), spawn.y + math.random(1, 2), spawn.z, 0, 3, 0)
        --table.insert(garagecoord, {spawn_x = spawnPos.x, spawn_y = spawnPos.y, spawn_z = spawnPos.z, garage = gid, property = true})
        tid = gid
        garagecoord[gid] = {garage_x = myoldcoords.x, garage_y = myoldcoords.y, garage_z = myoldcoords.z, spawn_x = spawnPos.x, spawn_y = spawnPos.y, spawn_z = spawnPos.z, garage = gid, property = true, Dist = 4, heading = spawnHeading}
        dist2 = #(vector3(spawnPos.x,spawnPos.y,spawnPos.z) - GetEntityCoords(PlayerPedId()))
    else
        dist2 = #(vector3(garagecoord[tid].spawn_x,garagecoord[tid].spawn_y,garagecoord[tid].spawn_z) - GetEntityCoords(PlayerPedId()))
    end
    dist = #(GetEntityCoords(PlayerPedId())-GetEntityCoords(vehicle))
    --for k,v in pairs(garagecoord) do
        local actualShop = v
        --if dist2 <= 80.0 then
            vp = GetVehicleProperties(vehicle)
            plate = vp.plate
            model = GetEntityModel(vehicle)
            ESX.TriggerServerCallback("renzu_garage:isvehicleingarage",function(stored,impound,garage,fee)
                if stored and impound == 0 or not Config.EnableReturnVehicle or string.find(garageid, "impound") then
                    local tempcoord = garagecoord
                    if string.find(garageid, "impound") then tempcoord = impoundcoord end
                    DoScreenFadeOut(0)
                    Citizen.Wait(333)
                    if not property then
                        SetEntityCoords(PlayerPedId(), tempcoord[tid].garage_x,tempcoord[tid].garage_y,tempcoord[tid].garage_z, false, false, false, true)
                    end
                    Citizen.Wait(1000)
                    local hash = tonumber(model)
                    local count = 0
                    if not HasModelLoaded(hash) then
                        RequestModel(hash)
                        while not HasModelLoaded(hash) do
                            RequestModel(hash)
                            Citizen.Wait(10)
                        end
                    end
                    v = CreateVehicle(model, tempcoord[tid].spawn_x,tempcoord[tid].spawn_y,tempcoord[tid].spawn_z, tempcoord[tid].heading, 1, 1)
                    SetVehicleBobo(v)
                    CheckWanderingVehicle(vp.plate)
                    vp.health = GetVehicleEngineHealth(GetVehiclePedIsIn(PlayerPedId()))
                    SetVehicleProp(v, vp)
                    Spawn_Vehicle_Forward(v, vector3(tempcoord[tid].spawn_x,tempcoord[tid].spawn_y,tempcoord[tid].spawn_z))
                    TaskWarpPedIntoVehicle(PlayerPedId(), v, -1)
                    veh = v
                    DoScreenFadeIn(333)
                    ESX.TriggerServerCallback("renzu_garage:changestate",function(ret,garage_public)
                        if ret and garage_public then
                            local ent = Entity(veh).state
                            while ent.share == nil do Wait(100) end
                            ent.unlock = true
                            local share = ent.share or {}
                            local add = true
                            for k,v in pairs(share) do
                                if k == v.PlayerData.identifier then
                                    add = false
                                end
                            end
                            if add then
                                share[PlayerData.identifier] = PlayerData.identifier
                            end
                            ent.share = share
                            ent:set('share', share, true)
                            TriggerServerEvent('statebugupdate','share',share, VehToNet(veh))
                        end
                    end,vp.plate, 0, garageid, vp.model, vp,false,garage_public)
                    garage_public = false
                    for k,v in pairs(spawnedgarage) do
                        ReqAndDelete(v)
                    end
                    spawnedgarage = {}
                    ingarage = false
                    DeleteGarage()
                    if property then
                        garagecoord[gid] = nil
                    end
                    shell = nil
                    i = 0
                    min = 0
                    max = 10
                    plus = 0
                elseif impound == 1 then
                    drawtext = true
                    SetEntityAlpha(vehicle, 51, false)
                    Wait(1000)
                    local t = {
                        ['event'] = 'impounded',
                        ['title'] = 'Vehicle is Impounded',
                        ['server_event'] = false,
                        ['unpack_arg'] = false,
                        ['invehicle_title'] = 'Vehicle is Impounded',
                        ['confirm'] = '[ENTER]',
                        ['reject'] = '[CLOSE]',
                        ['custom_arg'] = {}, -- example: {1,2,3,4}
                        ['use_cursor'] = false, -- USE MOUSE CURSOR INSTEAD OF INPUT (ENTER)
                    }
                    TriggerEvent('renzu_popui:showui',t)
                    Citizen.Wait(3000)
                    TriggerEvent('renzu_popui:closeui')
                    drawtext = false
                else
                    drawtext = true
                    SetEntityAlpha(vehicle, 51, false)
                    Wait(1000)
                    local t = {
                        ['event'] = 'renzu_garage:return',
                        ['title'] = 'Vehicle is in Outside:',
                        ['server_event'] = false,
                        ['unpack_arg'] = true,
                        ['invehicle_title'] = 'Vehicle is Outside:',
                        ['confirm'] = '[E] Return',
                        ['reject'] = '[CLOSE]',
                        ['custom_arg'] = {garagecoord[tid],vehicle,property or false,garagecoord[tid],GetVehicleProperties(vehicle),tid}, -- example: {1,2,3,4}
                        ['use_cursor'] = false, -- USE MOUSE CURSOR INSTEAD OF INPUT (ENTER)
                    }
                    TriggerEvent('renzu_popui:showui',t)
                    if property then
                        garagecoord[tid] = nil
                    end
                    local paying = 0
                    while dist < 3 and ingarage do
                        coords = GetEntityCoords(PlayerPedId())
                        vehcoords = GetEntityCoords(vehicle)
                        dist = #(coords-vehcoords)
                        paying = paying + 1
                        Citizen.Wait(500)
                    end
                    TriggerEvent('renzu_popui:closeui')
                    drawtext = false
                end
            end,plate,garageid,false,patrolcars[plate] or false)
        --end
    --end
end)

function VehiclesinGarage(coords, distance, property, propertycoord, gid)
    local data = {}
    data.dist = distance
    data.state = false
    local name = 'not found'
    for k,vehicle in pairs(GetGamePool('CVehicle')) do
        local vehcoords = GetEntityCoords(vehicle)
        local dist = #(coords-vehcoords)
        if dist < 4 then
            data.dist = dist
            data.vehicle = vehicle
            data.coords = vehcoords
            data.state = true
            for k,v in pairs(vehiclesdb) do
                if GetEntityModel(vehicle) == GetHashKey(v.model) then
                    name = v.name
                end
            end
            if name == 'not found' then
                name = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
            end
            --carstat(vehicle)
            local vehstats = GetVehicleStats(vehicle)
            local upgrades = GetVehicleUpgrades(vehicle)
            local stats = {
                topspeed = vehstats.topspeed / 300 * 100,
                acceleration = vehstats.acceleration * 150,
                brakes = vehstats.brakes * 80,
                traction = vehstats.handling * 10,
                name = name,
                plate = GetVehicleNumberPlateText(vehicle),
                engine = upgrades.engine / GetMaxMod(vehicle,11) * 100,
                transmission = upgrades.transmission / GetMaxMod(vehicle,13) * 100,
                brake = upgrades.brakes / GetMaxMod(vehicle,12) * 100,
                suspension = upgrades.suspension / GetMaxMod(vehicle,15) * 100,
                turbo = upgrades.turbo == 1 and 'Installed' or upgrades.turbo == 0 and 'Not Installed'
            }
            if stats_show == nil or stats_show ~= vehicle then
                SendNUIMessage({
                    type = "stats",
                    public = true,
                    perf = stats,
                    show = true,
                })
                stats_show = vehicle
            end
            while dist < 3 and not IsPedInAnyVehicle(PlayerPedId()) and ingarage do
                coords = GetEntityCoords(PlayerPedId())
                vehcoords = GetEntityCoords(vehicle)
                dist = #(coords-vehcoords)
                Wait(100)
            end
            -- TriggerEvent('EndScaleformMovie','mp_car_stats_01')
            -- TriggerEvent('EndScaleformMovie','mp_car_stats_02')
            SendNUIMessage({
                type = "stats",
                perf = false,
                show = false,
            })
            stats_show = nil
            while IsPedInAnyVehicle(PlayerPedId()) and ingarage do
                local table = {
                    ['key'] = 'E', -- key
                    ['event'] = 'renzu_garage:ingaragepublic',
                    ['title'] = 'Press [E] Choose Vehicle',
                    ['server_event'] = false, -- server event or client
                    ['unpack_arg'] = true, -- send args as unpack 1,2,3,4 order
                    ['invehicle_title'] = 'Press [E] Choose Vehicle',
                    ['fa'] = '<i class="fas fa-car"></i>',
                    ['custom_arg'] = {GetEntityCoords(PlayerPedId()), distance, vehicle, property or false, propertycoord or false, gid}, -- example: {1,2,3,4}
                }
                TriggerEvent('renzu_popui:drawtextuiwithinput',table)
                while IsPedInAnyVehicle(PlayerPedId()) and ingarage do
                    coords = GetEntityCoords(PlayerPedId())
                    vehcoords = GetEntityCoords(vehicle)
                    dist = #(coords-vehcoords)
                    Wait(500)
                end
                TriggerEvent('renzu_popui:closeui')
                coords = GetEntityCoords(PlayerPedId())
                vehcoords = GetEntityCoords(vehicle)
                dist = #(coords-vehcoords)
                Citizen.Wait(500)
            end
        end
    end
    data.dist = nil
    return data
end

function DeleteGarage()
    ingarage = false
    if DoesEntityExist(shell) then
        ReqAndDelete(shell)
        shell = nil
        i = 0
        min = 0
        max = 10
        plus = 0
        for k,v in pairs(spawnedgarage) do
            ReqAndDelete(v)
        end
        spawnedgarage = {}
    end
end

RegisterNetEvent('renzu_garage:store')
AddEventHandler('renzu_garage:store', function(i)
    local vehicleProps = GetVehicleProperties(GetVehiclePedIsIn(PlayerPedId(), 0))
    garageid = i
    if garageid == nil then
    garageid = 'A'
    end
    ESX.TriggerServerCallback("renzu_garage:changestate",function(ret, changestate, hasOwner)
        if ret then
            DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), 0))
        end

        if not hasOwner then
            DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), 0))
        end

    end,vehicleProps.plate, 1, garageid, vehicleProps.model, vehicleProps)
end)

function Storevehicle(vehicle,impound, impound_data, public)
    local vehicleProps = GetVehicleProperties(vehicle)
    if garageid == nil then
        garageid = 'A'
    end
    if impound then
        garageid = impound_data['impounds'] or impoundcoord[1].garage
    end
    Wait(100)
    TaskLeaveVehicle(PlayerPedId(),GetVehiclePedIsIn(PlayerPedId()),1)
    Wait(2000)
    ESX.TriggerServerCallback("renzu_garage:changestate",function(ret, garage_public, hasOwner)
        local ent = Entity(vehicle).state
        if ret then
            DeleteEntity(vehicle)
        end

        if hasOwner == false then
            DeleteEntity(vehicle)
        end

    end,vehicleProps.plate, 1, garageid, vehicleProps.model, vehicleProps, impound_data or {}, public)
    neargarage = false	
end

function helidel(vehicle)
    DeleteEntity(vehicle)
end

function SpawnVehicle(vehicle, plate ,coord)
    local veh = nil
	ESX.Game.SpawnVehicle(vehicle.model, {
		x = coord.x,
		y = coord.y,
		z = coord.z + 1
	}, coord.h, function(callback_vehicle)
		SetVehicleProp(callback_vehicle, vehicle)
		TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
        veh = callback_vehicle
	end)
    while not veh do
        Citizen.Wait(10)
    end
    return veh

end

function SpawnVehicleLocal(model, props)
    local ped = PlayerPedId()

    SetNuiFocus(true, true)
    if LastVehicleFromGarage ~= nil then
        ReqAndDelete(LastVehicleFromGarage)
        SetModelAsNoLongerNeeded(hash)
    end
    local nearveh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 2.000, 0, 70)
    ReqAndDelete(nearveh)

    if string.find(garageid, "impound") then
        for k,v in pairs(impoundcoord) do
            local dist = #(vector3(v.garage_x,v.garage_y,v.garage_z) - GetEntityCoords(ped))
            if dist <= 80.0 and garageid == v.garage then
                local actualShop = v
                local zaxis = actualShop.garage_z
                local hash = tonumber(model)
                local count = 0
                FreezeEntityPosition(PlayerPedId(),true)
                if not HasModelLoaded(hash) then
                    RequestModel(hash)
                    while not HasModelLoaded(hash) do
                        Citizen.Wait(10)
                    end
                end
                LastVehicleFromGarage = CreateVehicle(hash, actualShop.garage_x,actualShop.garage_y,zaxis + 20, 42.0, 0, 1)
                while not DoesEntityExist(LastVehicleFromGarage) do Wait(1) end
                SetEntityHeading(LastVehicleFromGarage, 50.117)
                FreezeEntityPosition(LastVehicleFromGarage, true)
                SetEntityCollision(LastVehicleFromGarage,false)
                SetVehicleProp(LastVehicleFromGarage, props)
                TaskWarpPedIntoVehicle(PlayerPedId(), LastVehicleFromGarage, -1)
                InGarageShell('enter')
            end
        end
    else
        for k,v in pairs(garagecoord) do
            local dist = #(vector3(v.garage_x,v.garage_y,v.garage_z) - GetEntityCoords(ped))
            if dist <= 80.0 and garageid == v.garage and not string.find(garageid, "impound") then
                local actualShop = v
                local zaxis = actualShop.garage_z
                local hash = tonumber(model)
                local count = 0
                FreezeEntityPosition(PlayerPedId(),true)
                if not HasModelLoaded(hash) then
                    RequestModel(hash)
                    while not HasModelLoaded(hash) do
                        Citizen.Wait(10)
                    end
                end
                LastVehicleFromGarage = CreateVehicle(hash, actualShop.garage_x,actualShop.garage_y,zaxis + 20, 42.0, 0, 1)
                while not DoesEntityExist(LastVehicleFromGarage) do Wait(1) end
                SetEntityHeading(LastVehicleFromGarage, 50.117)
                FreezeEntityPosition(LastVehicleFromGarage, true)
                SetEntityCollision(LastVehicleFromGarage,false)
                SetVehicleProp(LastVehicleFromGarage, props)
                TaskWarpPedIntoVehicle(PlayerPedId(), LastVehicleFromGarage, -1)
                InGarageShell('enter')
            end
        end
    end
end

function SpawnChopperLocal(model, props)
    local ped = PlayerPedId()

    SetNuiFocus(true, true)
    if LastVehicleFromGarage ~= nil then
        DeleteEntity(LastVehicleFromGarage)
        SetModelAsNoLongerNeeded(hash)
    end

    for k,v in pairs(helispawn[PlayerData.job.name]) do
        local v = v.coords
        local dist = #(vector3(v.x,v.y,v.z) - GetEntityCoords(ped))
        local actualShop = v
        if dist <= 10.0 then
            local zaxis = actualShop.z
            local hash = GetHashKey(model)
            local count = 0
            if not HasModelLoaded(hash) then
                RequestModel(hash)
                while not HasModelLoaded(hash) do
                    RequestModel(hash)
                    Citizen.Wait(10)
                end
            end
            LastVehicleFromGarage = CreateVehicle(hash, actualShop.x,actualShop.y,zaxis+0.3, 42.0, 0, 1)
            SetEntityHeading(LastVehicleFromGarage, 50.117)
            FreezeEntityPosition(LastVehicleFromGarage, true)
            SetEntityCollision(LastVehicleFromGarage,false)
            currentcar = LastVehicleFromGarage
            if currentcar ~= LastVehicleFromGarage then
                DeleteEntity(LastVehicleFromGarage)
                SetModelAsNoLongerNeeded(hash)
            end
            TaskWarpPedIntoVehicle(PlayerPedId(), LastVehicleFromGarage, -1)
            InGarageShell('enter')
        end
    end
end

myoldcoords = nil

RegisterNUICallback("ownerinfo",function(data, cb)
    ESX.TriggerServerCallback("renzu_garage:getowner",function(a,data)
        if a ~= nil then
        SendNUIMessage(
            {
                type = "ownerinfo",
                info = a,
                job = JobImpounder[PlayerData.job.name] or false,
                impound_data = data or {}
            }
        )
        end
    end,data.identifier, data.plate, garageid)
end)

RegisterNUICallback("SpawnVehicle",function(data, cb)
    if not Config.Quickpick and type == 'car' or propertyspawn.x ~= nil then
        local props = nil
        for k,v in pairs(OwnedVehicles['garage']) do
            if v.plate == data.plate then
                props = json.decode(v.props)
            end
        end
        SpawnVehicleLocal(data.modelcar, props)
    end
end)

RegisterNUICallback("SpawnChopper",function(data, cb)
    if not Config.Quickpick then
        local props = nil
        for k,v in pairs(OwnedVehicles['garage']) do
            if v.plate == data.plate then
                props = json.decode(v.props)
            end
        end
        SpawnChopperLocal(data.modelcar, props)
    end
end)

local vhealth = 1000

RegisterNUICallback(
    "GetVehicleFromGarage",
    function(data, cb)
        local ped = PlayerPedId()
        local props = nil
        if props == nil then
            for k,v in pairs(OwnedVehicles['garage']) do
                if v.plate == data.plate then
                    props = json.decode(v.props)
                end
            end
        end
        local veh = nil
    ESX.TriggerServerCallback("renzu_garage:isvehicleingarage",function(stored,impound,garage,fee)
        if stored and impound == 0 or ispolice and string.find(garageid, "impound") or not Config.EnableReturnVehicle and impound ~= 1 or impound == 1 and not Config.EnableImpound then
            local tempcoord = {}
            if propertygarage then
                spawn = GetEntityCoords(PlayerPedId())
                found, spawnPos, spawnHeading = GetClosestVehicleNodeWithHeading(spawn.x + math.random(1, 2), spawn.y + math.random(1, 2), spawn.z, 0, 3, 0)
                --table.insert(garagecoord, {spawn_x = spawnPos.x, spawn_y = spawnPos.y, spawn_z = spawnPos.z, garage = gid, property = true})
                tid = propertygarage
                garageid = propertygarage
                if propertyspawn.x ~= nil then
                    spawnPos = vector3(propertyspawn.x,propertyspawn.y,propertyspawn.z)
                    spawnHeading = propertyspawn.w
                end
                tempcoord[tid] = {garage_x = myoldcoords.x, garage_y = myoldcoords.y, garage_z = myoldcoords.z, spawn_x = spawnPos.x*1.0, spawn_y = spawnPos.y*1.0, spawn_z = spawnPos.z*1.0, garage = propertygarage, property = true, Dist = 4, heading = spawnHeading*1.0}
                dist2 = #(vector3(spawnPos.x,spawnPos.y,spawnPos.z) - GetEntityCoords(PlayerPedId()))
            elseif string.find(garageid, "impound") then
                tempcoord[tid] = impoundcoord[tid]
            else
                tempcoord[tid] = garagecoord[tid]
            end
            --for k,v in pairs(garagecoord) do
                local actualShop = tempcoord[tid]
                local dist = #(vector3(tempcoord[tid].spawn_x,tempcoord[tid].spawn_y,tempcoord[tid].spawn_z) - GetEntityCoords(PlayerPedId()))
                if garageid == tempcoord[tid].garage or string.find(garageid, "impound") then
                    DoScreenFadeOut(333)
                    Citizen.Wait(333)
                    CheckWanderingVehicle(props.plate)
                    DeleteEntity(LastVehicleFromGarage)
                    Citizen.Wait(1000)
                    CheckWanderingVehicle(props.plate)
                    Citizen.Wait(333)
                    SetEntityCoords(PlayerPedId(), tempcoord[tid].garage_x,tempcoord[tid].garage_y,tempcoord[tid].garage_z, false, false, false, true)
                    local hash = tonumber(props.model)
                    local count = 0
                    if not HasModelLoaded(hash) then
                        RequestModel(hash)
                        while not HasModelLoaded(hash) do
                            count = count + 10
                            Citizen.Wait(1)
                        end
                    end
                    local vehicle = CreateVehicle(tonumber(props.model), actualShop.spawn_x,actualShop.spawn_y,actualShop.spawn_z, actualShop.heading, 1, 1)
                    SetVehicleProp(vehicle, props)
                    SetVehicleBobo(vehicle)
                    if not propertygarage then
                        Spawn_Vehicle_Forward(vehicle, vector3(actualShop.spawn_x,actualShop.spawn_y,actualShop.spawn_z))
                    end
                    veh = vehicle
                    DoScreenFadeIn(111)
                    while veh == nil do
                        Citizen.Wait(101)
                    end
                    NetworkFadeInEntity(vehicle,1)
                    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                    veh = vehicle
                end
            --end

            while veh == nil do
                Citizen.Wait(10)
            end
            ESX.TriggerServerCallback("renzu_garage:changestate",function(ret, garage_public)
                if ret and garage_public then
                    local ent = Entity(veh).state
                    while ent.share == nil do Wait(100) end
                    ent.unlock = true
                    local share = ent.share or {}
                    local add = true
                    for k,v in pairs(share) do
                        if k == v.PlayerData.identifier then
                            add = false
                        end
                    end
                    if add then
                        share[PlayerData.identifier] = PlayerData.identifier
                    end
                    ent.share = share
                    ent:set('share', share, true)
                    TriggerServerEvent('statebugupdate','share',share, VehToNet(veh))
                end
            end,props.plate, 0, garageid, props.model, props,false,garage_public)
            LastVehicleFromGarage = nil
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            CloseNui()
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            SetVehicleEngineHealth(veh,props.engineHealth or 1000.0)
            Wait(100)
            i = 0
            min = 0
            max = 10
            plus = 0
            drawtext = false
            indist = false
            if propertygarage or string.find(garageid, "impound") then
                tempcoord[tid] = nil
            end
            SendNUIMessage(
            {
            type = "cleanup"
            })
        elseif impound == 1 then
            SendNUIMessage(
            {
                type = "notify",
                typenotify = "display",
                message = 'Vehicle is Impounded',
            })
            Citizen.Wait(1000)
            SendNUIMessage(
            {
                type = "onimpound",
                garage = garage,
                fee = fee,
            })
        else
            SendNUIMessage(
            {
                type = "notify",
                typenotify = "display",
                message = 'Vehicle is Outside of Garage',
            })
            Citizen.Wait(1000)
            SendNUIMessage(
            {
                type = "returnveh"
            }) 
        end
    end, props.plate,garageid,ispolice,patrolcars[props.plate] or false)
    end
)


RegisterNUICallback(
    "flychopper",
    function(data, cb)
        local ped = PlayerPedId()
        local veh = nil

        for k,v in pairs(helispawn[PlayerData.job.name]) do
            local v = v.coords
            local actualShop = v
            local dist = #(vector3(v.x,v.y,v.z) - GetEntityCoords(PlayerPedId()))
            if dist <= 10.0 then
                DoScreenFadeOut(333)
                Citizen.Wait(333)
                DeleteEntity(LastVehicleFromGarage)
                Citizen.Wait(1000)
                Citizen.Wait(333)
                SetEntityCoords(PlayerPedId(), v.x,v.y,v.z, false, false, false, true)
                local hash = GetHashKey(data.modelcar)
                local count = 0
                if not HasModelLoaded(hash) then
                    RequestModel(hash)
                    while not HasModelLoaded(hash) do
                        Citizen.Wait(1)
                    end
                end
                v = CreateVehicle(hash, actualShop.x,actualShop.y,actualShop.z, 256.0, 1, 1)
                SetVehicleBobo(vehicle)
                Spawn_Vehicle_Forward(v, vector3(actualShop.x,actualShop.y,actualShop.z))
                veh = v
                DoScreenFadeIn(333)
                while veh == nil do
                    Citizen.Wait(101)
                end
                TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                veh = v
            end
        end

        while veh == nil do
            Citizen.Wait(10)
        end
        LastVehicleFromGarage = nil
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        CloseNui()
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        i = 0
        min = 0
        max = 10
        plus = 0
        drawtext = false
        indist = false
    end)

RegisterNUICallback(
    "ReturnVehicle",
    function(data, cb)
        DeleteEntity(LastVehicleFromGarage)
        local ped = PlayerPedId()
        local props = nil
        local veh = nil
        local bool = false
        for k,v in pairs(OwnedVehicles['garage']) do
            if v.plate == data.plate then
                props = json.decode(v.props)
            end
        end
        ESX.TriggerServerCallback("renzu_garage:returnpayment",function(canreturn)
            if canreturn then
                if propertygarage then
                    spawn = GetEntityCoords(PlayerPedId())
                    found, spawnPos, spawnHeading = GetClosestVehicleNodeWithHeading(spawn.x + math.random(1, 2), spawn.y + math.random(1, 2), spawn.z, 0, 3, 0)
                    --table.insert(garagecoord, {spawn_x = spawnPos.x, spawn_y = spawnPos.y, spawn_z = spawnPos.z, garage = gid, property = true})
                    tid = propertygarage
                    garageid = propertygarage
                    if propertyspawn.x ~= nil then
                        spawnPos = vector3(propertyspawn.x,propertyspawn.y,propertyspawn.z)
                        spawnHeading = propertyspawn.w
                    end
                    garagecoord[tid] = {garage_x = myoldcoords.x, garage_y = myoldcoords.y, garage_z = myoldcoords.z, spawn_x = spawnPos.x*1.0, spawn_y = spawnPos.y*1.0, spawn_z = spawnPos.z*1.0, garage = propertygarage, property = true, Dist = 4, heading = spawnHeading*1.0}
                    dist2 = #(vector3(spawnPos.x,spawnPos.y,spawnPos.z) - GetEntityCoords(PlayerPedId()))
                end
                --for k,v in pairs(garagecoord) do
                    local actualShop = garagecoord[tid]
                    local dist = #(vector3(garagecoord[tid].spawn_x,garagecoord[tid].spawn_y,garagecoord[tid].spawn_z) - GetEntityCoords(ped))
                    if garageid == garagecoord[tid].garage then
                        DoScreenFadeOut(333)
                        Citizen.Wait(111)
                        CheckWanderingVehicle(props.plate)
                        Citizen.Wait(555)
                        SetEntityCoords(PlayerPedId(), garagecoord[tid].garage_x,garagecoord[tid].garage_y,garagecoord[tid].garage_z, false, false, false, true)
                        Citizen.Wait(555)
                        local hash = tonumber(data.modelcar)
                        local count = 0
                        if not HasModelLoaded(hash) then
                            RequestModel(hash)
                            while not HasModelLoaded(hash) do
                                RequestModel(hash)
                                Citizen.Wait(1)
                            end
                        end
                        vehicle = CreateVehicle(tonumber(data.modelcar), actualShop.spawn_x,actualShop.spawn_y,actualShop.spawn_z, actualShop.heading, 1, 1)
                        SetVehicleBobo(vehicle)
                        SetVehicleProp(vehicle, props)
                        if not propertygarage then
                            Spawn_Vehicle_Forward(vehicle, vector3(actualShop.spawn_x,actualShop.spawn_y,actualShop.spawn_z))
                        end
                        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                        veh = vehicle
                        SetVehicleEngineHealth(v,props.engineHealth)
                        Wait(100)
                        DoScreenFadeIn(333)
                    end
                --end
                bool = true
                while veh == nil do
                    Citizen.Wait(1)
                end
                ESX.TriggerServerCallback("renzu_garage:changestate",function(ret,garage_public)
                    if ret and garage_public then
                        local ent = Entity(veh).state
                        while ent.share == nil do Wait(100) end
                        ent.unlock = true
                        local share = ent.share or {}
                        local add = true
                        for k,v in pairs(share) do
                            if k == v.PlayerData.identifier then
                                add = false
                            end
                        end
                        if add then
                            share[PlayerData.identifier] = PlayerData.identifier
                        end
                        ent.share = share
                        ent:set('share', share, true)
                        TriggerServerEvent('statebugupdate','share',share, VehToNet(veh))
                    end
                end,props.plate, 0, garageid, props.model, props,false,garage_public)
                LastVehicleFromGarage = nil
                Wait(111)
                CloseNui()
                i = 0
                min = 0
                max = 10
                plus = 0
                drawtext = false
                indist = false
                if propertygarage then
                    garagecoord[tid] = nil
                end
                SendNUIMessage({
                    type = "cleanup"
                })
            else
                TriggerEvent('notifications', 'error','Garage', 'You dont have a money to pay the delivery')
                LastVehicleFromGarage = nil
                Wait(111)
                SetEntityCoords(PlayerPedId(), garagecoord[tid].garage_x,garagecoord[tid].garage_y,garagecoord[tid].garage_z, false, false, false, true)
                CloseNui()
                i = 0
                min = 0
                max = 10
                plus = 0
                drawtext = false
                indist = false
                SendNUIMessage({
                    type = "cleanup"
                })
            end
        end)
end)


RegisterNUICallback("Close",function(data, cb)
    DoScreenFadeOut(111)
    local ped = PlayerPedId()
    CloseNui()
    if string.find(garageid, "impound") then
        for k,v in pairs(impoundcoord) do
            local actualShop = v
            if v.garage_x ~= nil then
                local dist = #(vector3(v.garage_x,v.garage_y,v.garage_z) - GetEntityCoords(ped))
                if dist <= 40.0 and garageid == v.garage then
                    SetEntityCoords(ped, v.garage_x,v.garage_y,v.garage_z, 0, 0, 0, false)  
                end
            end
        end
    else
        for k,v in pairs(garagecoord) do
            local actualShop = v
            if v.garage_x ~= nil then
                local dist = #(vector3(v.garage_x,v.garage_y,v.garage_z) - GetEntityCoords(ped))
                if dist <= 40.0 and garageid == v.garage then
                    SetEntityCoords(ped, v.garage_x,v.garage_y,v.garage_z, 0, 0, 0, false)  
                end
            end
        end
    end
    DoScreenFadeIn(1000)
    DeleteGarage()
end)

local countspawn = 0
function CloseNui()
    SendNUIMessage(
        {
            type = "hide"
        }
    )
    if neargarage then
        neargarage = false
    end
    garagecoord = coordcache
    neargarage = false
    FreezeEntityPosition(PlayerPedId(),false)
    SetNuiFocus(false, false)
    InGarageShell('exit')
    if inGarage then
        if LastVehicleFromGarage ~= nil then
            DeleteEntity(LastVehicleFromGarage)
        end

        local ped = PlayerPedId()   
        if not Config.Quickpick then  
            RenderScriptCams(false)
            DestroyAllCams(true)
            ClearFocus()
            DisplayHud(true)
            DisplayRadar(true)
        end
    end
    countspawn = 0
    garagejob = false

    inGarage = false
    DeleteGarage()
    drawtext = false
    indist = false
    propertyspawn = {}
    garage_public = false
end

function ReqAndDelete(object, detach)
	if DoesEntityExist(object) then
		NetworkRequestControlOfEntity(object)
        SetEntityCollision(object, false, false)
        SetEntityAlpha(object, 0.0, true)
		local attempt = 0
		while not NetworkHasControlOfEntity(object) and attempt < 100 and DoesEntityExist(object) do
			NetworkRequestControlOfEntity(object)
			Citizen.Wait(10)
			attempt = attempt + 1
		end
        if detach and IsEntityAttached(object) then
            DetachEntity(object)
        end
		SetEntityCollision(object, false, false)
		SetEntityAlpha(object, 0.0, true)
		SetEntityAsMissionEntity(object, true, true)
		SetEntityAsNoLongerNeeded(object)
		DeleteEntity(object)
        if DoesEntityExist(object) then
            SetEntityCoords(object, 0.0,0.0,0.0)
        end
	end
end

function CheckWanderingVehicle(plate)
    local result = nil
    local gameVehicles = GetAllVehicleFromPool()
    for i = 1, #gameVehicles do
        local vehicle = gameVehicles[i]
        if DoesEntityExist(vehicle) then
            local otherplate = string.gsub(tostring(GetVehicleNumberPlateText(vehicle)), '^%s*(.-)%s*$', '%1'):upper()
            local plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()
            if otherplate:len() > 8 then
                otherplate = otherplate:sub(1, -2)
            end
            if plate:len() > 8 then
                plate = plate:sub(1, -2)
            end
            if plate == otherplate then
                ReqAndDelete(vehicle)
            end
        end
    end
end

AddEventHandler("onResourceStop",function(resourceName)
    if resourceName == GetCurrentResourceName() then
        CloseNui()
    end
end)

function GetNearestVehicleinPool(coords)
    local data = {}
    data.dist = -1
    data.state = false
    for k,vehicle in pairs(GetGamePool('CVehicle')) do
        local vehcoords = GetEntityCoords(vehicle,false)
        local dist = #(coords-vehcoords)
        if data.dist == -1 or dist < data.dist then
            data.dist = dist
            data.vehicle = vehicle
            data.coords = vehcoords
            data.state = true
        end
    end
    return data
end

local impoundata = nil

RegisterNUICallback("receive_impound", function(data, cb)
    SetNuiFocus(false,false)
    impoundata = data.impound_data
end)

RegisterCommand('impound', function(source, args, rawCommand)
    if Config.EnableImpound and PlayerData.job ~= nil and JobImpounder[PlayerData.job.name] then
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local vehicle = GetNearestVehicleinPool(coords, 5)
        SendNUIMessage(
            {
                data = {impounds = impoundcoord, duration = impound_duration},
                type = "impoundform"
            }
        )
        SetNuiFocus(true, true)
        while impoundata == nil do Wait(100) end
        if impoundata ~= 'cancel' then
            if not IsPedInAnyVehicle(ped, false) then
                if vehicle.state then
                    TaskTurnPedToFaceEntity(ped, vehicle.vehicle, 1500)
                    TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)
                    Wait(5000)
                    ClearPedTasksImmediately(ped)
                    Storevehicle(vehicle.vehicle,true,impoundata)
                else
                    TriggerEvent('notifications', 'error','Garage', "No vehicle in front")
                end
            else
                ESX.ShowNotification("get out of a vehicle to sign a papers")
            end
        end
        impoundata = nil
    end
end, false)

function GerNearVehicle(coords, distance, myveh)
    local vehicles = GetAllVehicleFromPool()
    for i=1, #vehicles, 1 do
        local vehicleCoords = GetEntityCoords(vehicles[i])
        local dist = #(coords-vehicleCoords)
        if dist < distance and vehicles[i] ~= myveh then
            return true
        end
    end
    return false
end

function Spawn_Vehicle_Forward(veh, coords)
    Wait(10)
    local move_coords = coords
    local vehicle = GerNearVehicle(move_coords, 3, veh)
    if vehicle and countspawn < 5 then
        move_coords = move_coords + GetEntityForwardVector(veh) * 9.0
        SetEntityCoords(veh, move_coords.x, move_coords.y, move_coords.z)
    else countspawn = 0 return end
    countspawn = countspawn + 1
    Spawn_Vehicle_Forward(veh, move_coords)
end

function SetVehicleBobo(vehicle)
    local netid = NetworkGetNetworkIdFromEntity(vehicle)
    SetNetworkIdExistsOnAllMachines(netid,true)
end

function getveh()
    local ped = PlayerPedId()
	local v = GetVehiclePedIsIn(PlayerPedId(), false)
	lastveh = GetVehiclePedIsIn(PlayerPedId(), true)
	local dis = -1
	if v == 0 then
		if #(GetEntityCoords(ped) - GetEntityCoords(lastveh)) < 5 then
			v = lastveh
		end
		dis = #(GetEntityCoords(ped) - GetEntityCoords(lastveh))
	end
	if dis > 3 then
		v = 0
	end
	if v == 0 then
		local count = 5
		v = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 8.000, 0, 70)
		while #(GetEntityCoords(ped) - GetEntityCoords(v)) > 10 and count >= 0 do
			v = GetClosestVehicle(GetEntityCoords(PlayerPedId()),8.000, 0, 70)
			count = count - 1
			Wait(1)
		end
        if v == 0 then
            local temp = {}
            for k,v in pairs(GetGamePool('CVehicle')) do
                local dist = #(GetEntityCoords(ped) - GetEntityCoords(v))
                temp[k] = {}
                temp[k].dist = dist
                temp[k].entity = v
            end
            local dist = -1
            local nearestveh = nil
            for k,v in pairs(temp) do
                if dist == -1 or dist > v.dist then
                    dist = v.dist
                    nearestveh = v.entity
                end
            end
            v = nearestveh
        end
	end
	return tonumber(v)
end
