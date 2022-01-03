ESX = nil
local blips_list = {}
local npc_list = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local work  = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end

    DeleteBlips()
	for k, v in pairs (routen) do
        for k, v in pairs (v) do
            if not v.illegal then
                for k, v in pairs (v) do
                    if (type(v) == "table") then
		                CreateBlip(v)
                    end
                end
            end
        end
	end

    TriggerEvent('esx_routen:spawnnpcs')

	while true do
        Citizen.Wait(1)
        if npc_list then
            for i, ped in ipairs(npc_list) do
		        TaskSetBlockingOfNonTemporaryEvents(ped, true)
            end
        end
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    DeleteBlips()
	for k, v in pairs (routen) do
        for k, v in pairs (v) do
            for k, v in pairs (v) do
                if (type(v) == "table") then
		            CreateBlip(v)
                end
            end
        end
	end
end)


AddEventHandler('esx_routen:spawnnpcs', function ()
    for k, v in pairs (routen) do
        for k, v in pairs (v) do
            for k, v in pairs (v) do
                if (type(v) == "table") then
		            if v.npc then
                        RequestModel(v.npc.model)
                        LoadPropDict(v.npc.model)
                        local ped = CreatePed(5, v.npc.model , v.coord, v.npc.heading, false, true)
                        PlaceObjectOnGroundProperly(ped)
                        SetEntityAsMissionEntity(ped)
                        SetPedDropsWeaponsWhenDead(ped, false)
                        FreezeEntityPosition(ped, true)
                        SetPedAsEnemy(ped, false)
                        SetEntityInvincible(ped, true)
                        SetModelAsNoLongerNeeded(v.npc.model)
                        SetPedCanBeTargetted(ped, false)
                        table.insert(npc_list, ped)
                    end
                end
            end
        end
	end
end)

-- Display markers
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        coords = GetEntityCoords(PlayerPedId())
        for k, v in pairs (routen) do
            for k, v in pairs (v) do
                if not v.illegal then
                    for k, v in pairs (v) do
                        if (type(v) == "table") then
                            if v.marker.show then
                                if(GetDistanceBetweenCoords(coords, v.coord.x, v.coord.y, v.coord.z, true) < 30.0) then
                                    DrawMarker(v.marker.type, v.coord, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.marker.range, v.marker.range, 1.0, v.marker.red, v.marker.green, v.marker.blue, 100, false, true, 2, true, false, false, false)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(0)

		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local currentZone = nil

        for k, v in pairs (routen) do
            for k, v in pairs (v) do
                for k, v in pairs (v) do
                    zone = v
                    if (type(v) == "table") then
			            if(#(coords - v.coord) < (v.marker.range / 2)) then
			            	isInMarker  = true
			            	currentZone = zone
			            end
                    end
                end
            end
		end

		if isInMarker then
			HasAlreadyEnteredMarker = true
			LastZone = currentZone
			TriggerEvent('esx_routen:hasEnteredMarker', LastZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_routen:hasExitedMarker', LastZone)
		end
	end
end)


RegisterNetEvent('esx_routen:changestatus')
AddEventHandler('esx_routen:changestatus', function(status)
    work = status
    if status == false then
        ClearPedTasks(PlayerPedId())
    end
end)

AddEventHandler('esx_routen:hasEnteredMarker', function (zone)
	local PlayerData = ESX.GetPlayerData()

    CurrentAction     = zone
	CurrentActionMsg  = "test"
	CurrentActionData = {}
	actionDisplayed = true
end)

AddEventHandler('esx_routen:hasExitedMarker', function (zone)
    TriggerServerEvent('esx_routen:stopRoute', LastZone)
	CurrentAction = nil
end)

-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction == nil then
			Citizen.Wait(0)
		else		
			if IsControlJustReleased(0, Config.ControlKey) then
                ESX.TriggerServerCallback('esx_routen:done', function(running)
                    if running then
                        TriggerServerEvent('esx_routen:stopRoute', LastZone)
                    else
                        TriggerServerEvent('esx_routen:startRoute', LastZone)
                    end
                end)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
        if work and PlayAnimations then
            if not IsPedUsingScenario(PlayerPedId(), LastZone.animation) then
                TaskStartScenarioInPlace(PlayerPedId(), LastZone.animation, 0, true)
            end
        end
	end
end)

function DeleteBlips()
	for i, station in ipairs(blips_list) do
		if DoesBlipExist(station) then
			RemoveBlip(station)
		end
	end
	blips_list = {}
end

function CreateBlip(config)
    local blip = AddBlipForCoord(config.coord)
    SetBlipSprite(blip, config.blip.sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, config.blip.scale)
    SetBlipColour(blip, config.blip.color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')	
    AddTextComponentSubstringPlayerName(config.name)
    EndTextCommandSetBlipName(blip)
    table.insert(blips_list, blip)
end


AddEventHandler('onResourceStop', function(resource)
    if resourceName == GetCurrentResourceName() then

        if npc_list then
            for i, ped in ipairs(npc_list) do
	            DeletePed(ped)
            end
            npc_list = {}
        end
    end
end)    

function LoadPropDict(model)
	while not HasModelLoaded(GetHashKey(model)) do
	  RequestModel(GetHashKey(model))
	  Wait(10)
	end
end
