local menu, PlayerData = {}, {}
local isDead, disabled = false, false

local vehiclemenu = {}

local InVeh = false
CreateThread(function()
    while true do
        Wait(0)
        if IsPedInAnyVehicle(PlayerPedId()) then
            InVeh = true
        else
            InVeh = false
        end
    end
end)

CreateThread(function()
    local ESX = exports['es_extended']:getSharedObject()
    while ESX.GetPlayerData().job == nil do
        Wait(100)
    end
    PlayerData = ESX.GetPlayerData()

    RegisterNetEvent('esx:playerLoaded', function(xPlayer)
        PlayerData = xPlayer
    end)

    RegisterNetEvent('esx:setJob', function(job)
        PlayerData.job = job
        removeMenu(Config.JobOption.label)
        Wait(100)
        AddJobMenu()
    end)

    for k, v in pairs(Config.RadialMenu) do
        menu[#menu + 1] = v
    end

    for k, v in pairs(Config.VehicleMenu) do
        vehiclemenu[#vehiclemenu + 1] = v
    end
end)

RegisterNUICallback('initialize', function(data, cb)
    cb({
        size = Config.UI.Size,
        colors = Config.UI.Colors
    })
end)

RegisterNUICallback('hideFrame', function(data,cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('clickedItem', function(data, cb)
    if data.shouldClose then
        SetNuiFocus(false, false)
    end
    if not data.args then
        data.args = {}
    end
    if data.client then
        TriggerEvent(data.event, table.unpack(data.args))
    elseif not data.client then
        TriggerServerEvent(data.event, table.unpack(data.args))
    end
    cb('ok')
end)

function addMenu(data)
    if data.label and data.icon and (data.submenu or (data.client ~= nil and data.shouldClose ~= nil and data.event)) then
        menu[#menu + 1] = data
    end
end

exports('addMenu', addMenu)

function removeMenu(label)
    if label then
        removeItemFromArray(menu, 'label', label)
    end
end

exports('removeMenu', removeMenu)

exports('setDead', function(status)
    isDead = status
end)

exports('disable', function(toggle)
    disabled = toggle
end)

RegisterCommand(Config.Open.command, function()
    if not disabled then
        SetNuiFocus(true, true)
        if InVeh then
            SendNUIMessage({
                action="openMenu",
                data=vehiclemenu
            })
        else
            SendNUIMessage({
                action="openMenu",
                data=menu
            })
        end
    end
end)

if not Config.Open.commandonly then
    RegisterKeyMapping(Config.Open.command, 'Open Radial Menu', 'keyboard', Config.Open.key)
end

-- Utils
function removeItemFromArray(array, property, value)
    for i=1, #array do
        if array[i][property] == value then
            array[i] = nil
            break
        end
    end
end



RegisterNetEvent('esx_radialmenu:idcard')
AddEventHandler('esx_radialmenu:idcard', function(show_self, license_type)
    if show_self then
        TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), license_type)
    else
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

        if closestDistance ~= -1 and closestDistance <= 3.0 then
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), license_type)
        else
            TriggerEvent('dopeNotify:Alert', "", "Kein Spieler in der Umgebung", 5000, 'error')
        end	
    end
end)

RegisterNetEvent('esx_radialmenu:handcuff')
AddEventHandler('esx_radialmenu:handcuff', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TriggerServerEvent('esx_jobs:handcuff', GetPlayerServerId(closestPlayer))
    else
        TriggerEvent('dopeNotify:Alert', "", "Kein Spieler in der Umgebung", 5000, 'error')
    end
end)

RegisterNetEvent('esx_radialmenu:uncuff')
AddEventHandler('esx_radialmenu:uncuff', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TriggerServerEvent('esx_jobs:uncuff', GetPlayerServerId(closestPlayer))
    else
        TriggerEvent('dopeNotify:Alert', "", "Kein Spieler in der Umgebung", 5000, 'error')
    end
end)

RegisterNetEvent('esx_radialmenu:engine')
AddEventHandler('esx_radialmenu:engine', function()
    ped = PlayerPedId()
    if not IsPedSittingInAnyVehicle(ped) then
        TriggerEvent('dopeNotify:Alert', "", "Kein Spieler in der Umgebung", 5000, 'error')
    elseif IsPedSittingInAnyVehicle(ped) then
        local veh = GetVehiclePedIsIn(ped, false)

        if GetIsVehicleEngineRunning(veh) then
            SetVehicleEngineOn(veh, false, false, true)
            SetVehicleUndriveable(veh, true)
        elseif not GetIsVehicleEngineRunning(veh) then
            SetVehicleEngineOn(veh, true, false, true)
            SetVehicleUndriveable(veh, false)
        end
    end
end)

RegisterNetEvent('esx_radialmenu:vehicle_door')
AddEventHandler('esx_radialmenu:vehicle_door', function(door_index)
    ped = PlayerPedId()
    if not IsPedSittingInAnyVehicle(ped) then
        TriggerEvent('dopeNotify:Alert', "", "Du bist nicht in einem Auto", 5000, 'error')
    elseif IsPedSittingInAnyVehicle(ped) then
        local veh = GetVehiclePedIsIn(ped, false)

        if GetVehicleDoorAngleRatio(veh, door_index) > 0 then
            SetVehicleDoorShut(veh, door_index, false)
        else
            SetVehicleDoorOpen(veh, door_index, false, false)
        end
    end
end)

local vehicle_windows = {
    {window_index = 0, status = true},
    {window_index = 1, status = true},
    {window_index = 2, status = true},
    {window_index = 3, status = true},
    {window_index = 4, status = true},
    {window_index = 5, status = true},
    {window_index = 6, status = true},
    {window_index = 7, status = true},
}

RegisterNetEvent('esx_radialmenu:vehicle_window')
AddEventHandler('esx_radialmenu:vehicle_window', function(windows_index)
    ped = PlayerPedId()
    if not IsPedSittingInAnyVehicle(ped) then
        TriggerEvent('dopeNotify:Alert', "", "Du bist nicht in einem Auto", 5000, 'error')
    elseif IsPedSittingInAnyVehicle(ped) then
        local veh = GetVehiclePedIsIn(ped, false)

        for k, v in pairs(vehicle_windows) do
            for k, window_index in pairs(windows_index) do
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
    end
end)




