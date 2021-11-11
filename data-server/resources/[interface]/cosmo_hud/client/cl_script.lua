-- Variables
ESX = nil
local beltStatus = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(100)
    end
end)

-- Principal Event
RegisterNetEvent("cosmo_hud:onTick")
AddEventHandler("cosmo_hud:onTick", function(status)
    local playerPed = PlayerPedId()

    TriggerEvent('esx_status:getStatus', 'hunger', function(status) 
        hunger = status.val / 10000
    end)
    
    TriggerEvent('esx_status:getStatus', 'thirst', function(status) 
        thirst = status.val / 10000 
    end)
    
    if Config.ShowStress then
        TriggerEvent('esx_status:getStatus', 'stress', function(status) 
            stress = status.val / 10000 
        end)
    end
    
    if hunger == 0 or thirst == 0 then
        ForcePedMotionState(playerPed, 1110276645, 0, 0, 0)
    end
end)

-- Principal Loop
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.TickTime)
        local pedID = PlayerPedId()

        -- Player ID
        if Config.ShowServerID then
            SendNUIMessage({
                pid = true,
                playerid = GetPlayerServerId(PlayerId()),
            })
        else
            SendNUIMessage({pid = false})
        end

        -- Ped oxygen underwater
        if IsPedSwimmingUnderWater(pedID) then
            SendNUIMessage({showOxygen = true})
        else
            SendNUIMessage({showOxygen = false})
        end

        -- Ped stamina while sprinting
        if Config.ShowStamina then
            SendNUIMessage({showStamina = true})
        else
            SendNUIMessage({showStamina = false})
        end
        
        -- Entity health
        if ((GetEntityHealth(pedID) - 100) >= 100) then
            SendNUIMessage({showHealth = false})
        else
            SendNUIMessage({showHealth = true})
        end

        -- Vehicle config while entity inside
        if IsPedInAnyVehicle(pedID, true) then
            SetRadarZoom(1000)
            local veh = GetVehiclePedIsUsing(pedID, false)
            local speed = math.floor(GetEntitySpeed(veh) * 3.6)

            SendNUIMessage({
                speed = speed, 
            })
        end

        -- SpeedO gonfig
        if Config.ShowSpeedO then
            if IsPedInAnyVehicle(pedID, false) 
            and not IsPedInFlyingVehicle(pedID) 
            and not IsPedInAnySub(pedID) then
                SendNUIMessage({showSpeedo = true})
            elseif not IsPedInAnyVehicle(pedID, false) then
                SendNUIMessage({showSpeedo = false})
            end
        end

        -- Stress config
        if Config.ShowStress then
            if stress > 1 then
                SendNUIMessage({showStress = true})
            else
                SendNUIMessage({showStress = false})
            end
        end

        -- Pause menu checks
        if IsPauseMenuActive() then
            SendNUIMessage({showUi = false})
        elseif not IsPauseMenuActive() then
            SendNUIMessage({showUi = true})
        end

        -- Fuel config
        if Config.ShowFuel then
            SendNUIMessage({showFuel = true})
        else
            SendNUIMessage({showFuel = false})
        end

        if Config.ShowFuel then
            if IsPedInAnyVehicle(pedID, true) then
                local veh = GetVehiclePedIsUsing(pedID, false)
                local fuellevel = exports["LegacyFuel"]:GetFuel(veh)
                SendNUIMessage({
                    action = "update_fuel",
                    fuel = fuellevel
                })
            end
        end

        -- Radar config
        if not Config.ShowRadar then
            if IsPedInAnyVehicle(pedID, false) then
                DisplayRadar(true)
            else
                DisplayRadar(false)
            end
        else
            DisplayRadar(true)
        end

        -- Stress config
        if Config.ShowStress then
            if math.floor(stress) >= Config.MinStressEffect then
                Citizen.Wait(10000)
                forRepeat()
            elseif math.floor(stress) == 100 then
                Citizen.Wait(500)
                forRepeat()
            end
        end
        
        -- Information sent to JavaScript
        SendNUIMessage({
            action = "update_hud",
            hp = GetEntityHealth(pedID) - 100,
            armor = GetPedArmour(pedID),
            hunger = hunger,
            thirst = thirst,
            stress = stress,
            isBeltOn = beltStatus,
            oxygen = GetPlayerUnderwaterTimeRemaining(PlayerId()) * 10,
            stamina = GetPlayerSprintTimeRemaining(PlayerId()) * 10,
        })
    end
end)

-- Microphone
AddEventHandler("SaltyChat_VoiceRangeChanged", function(voiceRange, index, availableVoiceRanges)
    SendNUIMessage({
        action = "voice_level", 
        voicelevel = index
    })
end)

AddEventHandler("SaltyChat_TalkStateChanged", function(isTalking)
    SendNUIMessage({
        talking = isTalking
    })
end)

-- Seatbelt events
RegisterNetEvent("cosmo_hud:isSeatbeltOn")
AddEventHandler("cosmo_hud:isSeatbeltOn", function(isOn)
    beltStatus = isOn
    SendNUIMessage({
        isBeltOn = beltStatus
    })
end)

if Config.ShowStress then
    -- Stress function that makes you close your eyes when stress is too high
    function forRepeat()
        Citizen.Wait(750)
        DoScreenFadeOut(200)
        Citizen.Wait(Config.TickTime)
        DoScreenFadeIn(200)
    end

    -- Updated stress from server
    RegisterNetEvent('cosmo_hud:UpdateStress')
    AddEventHandler('cosmo_hud:UpdateStress', function(newStress)
        stress = newStress
    end)
end