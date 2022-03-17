if Config.TrunkEnabled then 
    local inTrunk = false
    local vehicle = nil
    local function VehicleInFront()
        local pos = GetEntityCoords(GetPlayerPed(-1))
        local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 4.0, 0.0)
        local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
        local a, b, c, d, result = GetRaycastResult(rayHandle)
        return result
    end


    AddEventHandler('inventory:close', function()
        if vehicle then
            inTrunk = false
            SetVehicleDoorShut(vehicle, 5, true)
            vehicle = nil
        end
    end)

    RegisterCommand('openTrunk', function()
        if IsEntityDead(PlayerPedId()) then return end
        if not IsPedInAnyVehicle(PlayerPedId(), false) then 
            vehicle = VehicleInFront()
            if DoesEntityExist(vehicle) then
                if not IsVehicleStopped(vehicle) then 
                    return
                end
                local plate = trim(GetVehicleNumberPlateText(vehicle))
                local type = GetVehicleClass(vehicle)
                local locked = GetVehicleDoorLockStatus(vehicle)
                if locked == 1 then
                    for k,v in pairs(Config.BlacklistedVehicleTypes) do
                        if type == v then
                            TriggerEvent('inventory:notify', Locales.vehicleNoTrunk, 'error')
                            return
                        end
                    end

                    local trunkWeight = Config.TrunkClassWeights[type]
                    for k,v in pairs(Config.TrunkIndividualWeights) do 
                        if k:upper() == GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)):upper() then 
                            trunkWeight = v
                        end
                    end

                    SetCarBootOpen(vehicle)
                    if Config.TrunkSave then
                        local owned = Events.TriggerServerEvent('inventory:isVehicleOwned', plate)
                        OpenInventory({
                            id = plate, 
                            type = 'trunk', 
                            title = Locales.trunkTitle .. ' - ' .. plate,
                            weight = trunkWeight, 
                            save = owned,
                            delay = Config.TrunkTimeout
                        }) 
                    else 
                        OpenInventory({
                            id = plate, 
                            type = 'trunk', 
                            title = Locales.trunkTitle .. ' - ' .. plate,
                            weight = trunkWeight, 
                            save = false,
                            delay = Config.TrunkTimeout
                        }) 
                    end

                    inTrunk = true
                else 
                    TriggerEvent('inventory:notify', Locales.vehicleLocked, 'error')
                end
            end
        end
    end, true)

    RegisterKeyMapping('openTrunk', 'Open Trunk', 'keyboard', Config.TrunkKey)

    CreateThread(function ()
        while true do 
            Wait(1000)
            if inTrunk and vehicle then 
                local dist = #(GetEntityCoords(vehicle) - GetEntityCoords(PlayerPedId()))
                if dist > 3.0 then 
                    SendNUIMessage({
                        action = 'close'
                    })    
                end
            end
        end
    end)

    function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
    end
end
