if Config.Rob then
    handsup = false

    RegisterCommand('steal', function()
        local player, distance = ESX.Game.GetClosestPlayer()

        if handsup then
            return
        end
        
        if player ~= -1 and distance <= 3.0 then
            local ped = GetPlayerPed(player)

            if DoesEntityExist(ped) then
                if IsEntityDead(ped) then
                    OpenInventory({
                        id = GetPlayerServerId(player),
                        type = 'player',
                        title = GetPlayerName(player),
                        weight = true,
                        delay = Config.RobTimeout
                    })

                    LoadAnimDict("random@mugging5", function()
                        TaskPlayAnim(PlayerPedId(), "random@mugging5", "ig_1_guy_handoff", 8.0, 8.0, -1, 50, 0, false, false, false)
                        Wait(1200)
                        ClearPedTasks(PlayerPedId())
                    end) 
                else 
                    if IsEntityPlayingAnim(ped, "missminuteman_1ig_2", "handsup_enter", 3) then
                        OpenInventory({
                            id = GetPlayerServerId(player),
                            type = 'player',
                            title = GetPlayerName(player),
                            weight = true,
                            delay = Config.RobTimeout
                        })

                        LoadAnimDict("random@mugging5", function()
                            TaskPlayAnim(PlayerPedId(), "random@mugging5", "ig_1_guy_handoff", 8.0, 8.0, -1, 50, 0, false, false, false)
                            Wait(1200)
                            ClearPedTasks(PlayerPedId())
                        end) 
                    end 
                end

                while true do 
                    Wait(1)
                    player, distance = ESX.Game.GetClosestPlayer()
                    if distance > 3.0 then 
                        SendNUIMessage({
                            type = 'close'
                        })    
                        break
                    end
                end
            end
        else 
            TriggerEvent('inventory:notify', Locales.noPlayersFound, 'error') 
        end
    end)

    -- handsup
    RegisterCommand('handsup', function()
        if IsEntityDead(PlayerPedId()) then 
            return
        end

        if IsPedInAnyVehicle(PlayerPedId(), false) then 
            return
        end 

        if not handsup then
            handsup = true
            LoadAnimDict("missminuteman_1ig_2", function()
                TaskPlayAnim(PlayerPedId(), "missminuteman_1ig_2", "handsup_enter", 8.0, 8.0, -1, 50, 0, false, false, false)
            end) 
        else 
            ClearPedTasks(PlayerPedId())
            handsup = false
        end
    end)
    RegisterKeyMapping('handsup', 'Hands Up/Down', 'keyboard', Config.HandsupKey)
end