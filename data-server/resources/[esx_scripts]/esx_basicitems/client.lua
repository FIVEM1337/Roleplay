local propsEntities = {}
local animationactive
local tabletStatus = false

RegisterNetEvent('esx_basicitems:onEat')
AddEventHandler('esx_basicitems:onEat', function(itemname)
	local dict
	if Config.FoodAnimations[itemname] then
		dict = Config.FoodAnimations[itemname]
	else
		dict = Config.FoodAnimations["default"]
	end
    playanim(dict)
end)

RegisterNetEvent('esx_basicitems:onDrink')
AddEventHandler('esx_basicitems:onDrink', function(itemname)
	local dict
	if Config.DrinkAnimations[itemname] then
		dict = Config.DrinkAnimations[itemname]
	else
		dict = Config.DrinkAnimations["default"]
	end
    playanim(dict)
end)

function playanim(dict)
	if animationactive then return end

	animationactive = true
	loaddict(dict.dict)
	playprop(dict.props)

	SetTimeout(dict.duration * 1000, function() clearanimation() end)

	TaskPlayAnim(PlayerPedId(), dict.dict, dict.anim, 1.5, 1.5, -1, 51, 0, false, false, false)
	RemoveAnimDict(dict.dict)
end

function playprop(props)
    if props then
        if props.prop then
            loadmodel(props.prop)
            loadPropCreation(PlayerPedId(), props.prop, props.propBone, props.propPlacement)
        end
        if props.propTwo then
            loadmodel(props.propTwo)
            loadPropCreation(PlayerPedId(), props.propTwo, props.propTwoBone, props.propTwoPlacement)
        end
    end
end

function loaddict(dict)
    local timeout = false
    SetTimeout(5000, function() timeout = true end)

    repeat
        RequestAnimDict(dict)
        Wait(50)
    until HasAnimDictLoaded(dict) or timeout
end

function loadmodel(model)
    local timeout = false
    SetTimeout(5000, function() timeout = true end)

    local hashModel = GetHashKey(model)
    repeat
        RequestModel(hashModel)
        Wait(50)
    until HasModelLoaded(hashModel) or timeout
end

function loadPropCreation(ped, prop, bone, placement)
    local coords = GetEntityCoords(ped)
    local newProp = CreateObject(GetHashKey(prop), coords.x, coords.y, coords.z + 0.2, true, true, true)
    if newProp then
        AttachEntityToEntity(newProp, ped, GetPedBoneIndex(ped, bone), placement[1] + 0.0, placement[2] + 0.0, placement[3] + 0.0, placement[4] + 0.0, placement[5] + 0.0, placement[6] + 0.0, true, true, false, true, 1, true)
		table.insert(propsEntities, newProp)
	end
    SetModelAsNoLongerNeeded(prop)
end

function clearanimation()
	ClearPedTasks(PlayerPedId())

	for k, v in pairs(propsEntities) do
		DeleteObject(v)
	end
	propsEntities = {}

	animationactive = false
end

RegisterNetEvent('esx_basicitems:onRepairkit')
AddEventHandler('esx_basicitems:onRepairkit', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle

		if IsPedInAnyVehicle(playerPed, false) then
            TriggerEvent('dopeNotify:Alert', "", "Du musst dazu aus dem Auto aussteigen", 5000, 'error')
            TriggerServerEvent('esx_basicitems:stopTask')
            return
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
			CreateThread(function()
				Wait(20000)
                ESX.TriggerServerCallback('esx_basicitems:getItemAmount', function(quantity)
                    if quantity and quantity >= 1 then
                        TriggerServerEvent('esx_basicitems:removeItem', 'use_repairkit', 1)
                        SetVehicleFixed(vehicle)
                        SetVehicleDeformationFixed(vehicle)
                        SetVehicleUndriveable(vehicle, false)
                        ClearPedTasksImmediately(playerPed)
                    else
                        TriggerEvent('dopeNotify:Alert', "", "Du benötigst 1x use_repairkit", 5000, 'error')
                        TriggerServerEvent('esx_basicitems:stopTask')
                        return
                    end
                end, 'use_repairkit')
			end)
        else
            TriggerEvent('dopeNotify:Alert', "", "Kein Auto in der Nähe", 5000, 'error')
            TriggerServerEvent('esx_basicitems:stopTask')
            return
		end
    else
        TriggerEvent('dopeNotify:Alert', "", "Kein Auto in der Nähe", 5000, 'error')
        TriggerServerEvent('esx_basicitems:stopTask')
        return
	end
end)

RegisterNetEvent('esx_basicitems:onUseHeal')
AddEventHandler('esx_basicitems:onUseHeal', function(itemName)
    local playerPed = PlayerPedId()
    local maxHealth = GetEntityMaxHealth(playerPed)
    local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01'
	
    ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)

        while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
            Wait(0)
            DisableAllControlActions(0)
        end

        if itemName == 'use_medikit' then
            ESX.TriggerServerCallback('esx_basicitems:getItemAmount', function(quantity)
                if quantity and quantity >= 1 then
                    TriggerServerEvent('esx_basicitems:removeItem', 'use_medikit', 1)
                    SetEntityHealth(playerPed, maxHealth)
                else
                    TriggerEvent('dopeNotify:Alert', "", "Du benötigst 1x use_medikit", 5000, 'error')
                    TriggerServerEvent('esx_basicitems:stopTask')
                    return
                end
            end, 'use_medikit')

        elseif itemName == 'use_bandage' then
            ESX.TriggerServerCallback('esx_basicitems:getItemAmount', function(quantity)
                if quantity and quantity >= 1 then
                    local health = GetEntityHealth(playerPed)
                    local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 8))
                    TriggerServerEvent('esx_basicitems:removeItem', 'use_bandage', 1)
                    SetEntityHealth(playerPed, newHealth)
                else
                    TriggerEvent('dopeNotify:Alert', "", "Du benötigst 1x use_bandage", 5000, 'error')
                    TriggerServerEvent('esx_basicitems:stopTask')
                    return
                end
            end, 'use_bandage')
        end
    end)
end)

RegisterNetEvent('esx_basicitems:onUseKevlar')
AddEventHandler('esx_basicitems:onUseKevlar', function()
    local playerPed = PlayerPedId()
    local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01'
	
    ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)

        Wait(500)
        while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
            Wait(0)
            DisableAllControlActions(0)
        end

        ESX.TriggerServerCallback('esx_basicitems:getItemAmount', function(quantity)
            if quantity and quantity >= 1 then
                TriggerServerEvent('esx_basicitems:removeItem', 'use_kevlar_west', 1)
                AddArmourToPed(playerPed, 100)
                SetPedArmour(playerPed, 100)
            else
                TriggerEvent('dopeNotify:Alert', "", "Du benötigst 1x use_kevlar_west", 5000, 'error')
                TriggerServerEvent('esx_basicitems:stopTask')
                return
            end
        end, 'use_kevlar_west')
    end)
end)

RegisterNetEvent('esx_basicitems:onUseTablet')
AddEventHandler('esx_basicitems:onUseTablet', function(itemName)
    local playerPed = PlayerPedId()

    tabletStatus = not tabletStatus
    SetNuiFocus(tabletStatus, tabletStatus)
    SendNUIMessage({show = tabletStatus, name = GetCurrentResourceName()})
    
    if (IsPedInAnyVehicle(playerPed, true)) then
		return
	end

	RequestAnimDict("amb@world_human_tourist_map@male@base")
	Citizen.CreateThread(function ()
		while not HasAnimDictLoaded("amb@world_human_tourist_map@male@base") do
			Citizen.Wait(1)
		end
		TaskPlayAnim(playerPed, "amb@world_human_tourist_map@male@base", "base", 2.0, 2.0, -1, 1, 0, false, false, false)
	end)
end)

RegisterNUICallback('close', function(data, cb)
	tabletStatus = false
	SetNuiFocus(false, false)
	SendNUIMessage({show = false})
	ClearPedTasks(PlayerPedId())
end)