local isNearPump
local isFueling
local currentCash
local Busy = false

CreateThread(function()
    while true do
        PlayerData = ESX.GetPlayerData()
        if PlayerData and PlayerData.accounts then
            for k,v in pairs(PlayerData.accounts) do
                if v.name == "money" then
                    currentCash = v.money
                    break
                end
            end
        end
        if currentCash then
            break
        end
        Wait(100)
    end
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	if account.name == "money" then
        currentCash = account.money
	end
end)

CreateThread(function()
	while true do
        Wait(1)
		local pumpObject, pumpDistance = FindNearestFuelPump()

		if pumpDistance < 2.5 then
			isNearPump = pumpObject
            Wait(1)
		else
			isNearPump = false
			Wait(math.ceil(pumpDistance * 20))
		end
	end
end)

CreateThread(function()
	while true do
        Wait(1)
        local playerPed = PlayerPedId()
        if isNearPump and not isFueling and GetEntityHealth(isNearPump) > 0 then
            local coords = GetEntityCoords(playerPed)
            PumpCoords = GetEntityCoords(isNearPump)
            if IsPedInAnyVehicle(playerPed) then
                ESX.Game.Utils.DrawText3D({x = PumpCoords.x, y = PumpCoords.y, z = PumpCoords.z + 1.2}, 'Verlasse das Fahrzeug, um zu tanken.', 0.8)
            elseif GetSelectedPedWeapon(playerPed) == 883325847 then
                if GetAmmoInPedWeapon(playerPed, 883325847) < Config.JerryCanMaxFuel then
                    if currentCash and currentCash >= Config.Price then
                        ESX.Game.Utils.DrawText3D({x = PumpCoords.x, y = PumpCoords.y, z = PumpCoords.z + 1.2}, 'Drücke [~g~E~w~] um den Kanister zu betanken', 0.8)
                        if IsControlJustReleased(0, 38) and not Busy then
                            isFueling = true
                            TriggerEvent('esx_fuelstation:FillJerryCanFromPump',isNearPump)
                        end
                    else
                        ESX.Game.Utils.DrawText3D({x = PumpCoords.x, y = PumpCoords.y, z = PumpCoords.z + 1.2}, 'Du besitzt nicht genügend Geld.', 0.8)
                    end
                else
                    ESX.Game.Utils.DrawText3D({x = PumpCoords.x, y = PumpCoords.y, z = PumpCoords.z + 1.2}, 'Dein Kanister ist voll.', 0.8)
                end
            else
                local closestVehicle, Distance = ESX.Game.GetClosestVehicle(coords)
                if closestVehicle ~= -1 and Distance <= 3.0 then
                    if IsCorrectVehicleType(closestVehicle) then
                        if GetVehicleFuelLevel(closestVehicle) < 100 then 
                            if currentCash and currentCash >= Config.Price then
                                ESX.Game.Utils.DrawText3D({x = PumpCoords.x, y = PumpCoords.y, z = PumpCoords.z + 1.2}, 'Drücke [~g~E~w~] um das Fahrzeug zu Tanken', 0.8)
                                if IsControlJustReleased(0, 38) and not Busy then
                                    isFueling = true
                                    TriggerEvent('esx_fuelstation:FillVehicleFromPump', closestVehicle, isNearPump)
                                end
                            else
                                ESX.Game.Utils.DrawText3D({x = PumpCoords.x, y = PumpCoords.y, z = PumpCoords.z + 1.2}, 'Du besitzt nicht genügend Geld.', 0.8)
                            end
                        else
                            ESX.Game.Utils.DrawText3D({x = PumpCoords.x, y = PumpCoords.y, z = PumpCoords.z + 1.2}, 'Das Fahrzeug ist bereits voll.', 0.8)
                        end
                    else
                        ESX.Game.Utils.DrawText3D({x = PumpCoords.x, y = PumpCoords.y, z = PumpCoords.z + 1.2}, 'Das Fahrzeug ist nicht der richtige Typ.', 0.8)
                    end
                end
            end
        else
            if not isFueling then
                if GetSelectedPedWeapon(playerPed) == 883325847 then
                    local closestVehicle, Distance = ESX.Game.GetClosestVehicle(coords)
                    local vehicleCoords = GetEntityCoords(closestVehicle)
        
                    if closestVehicle ~= -1 and Distance <= 3.0 then
                        if GetAmmoInPedWeapon(playerPed, 883325847) > 0 then
                            if GetVehicleFuelLevel(closestVehicle) < 95 then
                                ESX.Game.Utils.DrawText3D({x = vehicleCoords.x, y = vehicleCoords.y, z = vehicleCoords.z + 1.2}, 'Drücke [~g~E~w~] um das Fahrzeug mit Kanister zu Tanken', 0.8)
                                if IsControlJustReleased(0, 38) and not Busy then
                                    isFueling = true
                                    TriggerEvent('esx_fuelstation:FillVehicleFromJerryCan', closestVehicle)
                                end
                            else
                                ESX.Game.Utils.DrawText3D({x = vehicleCoords.x, y = vehicleCoords.y, z = vehicleCoords.z + 1.2}, 'Das Fahrzeug ist bereits voll.', 0.8)
                            end
                        else
                            ESX.Game.Utils.DrawText3D({x = vehicleCoords.x, y = vehicleCoords.y, z = vehicleCoords.z + 1.2}, 'Dein Kanister ist Leer.', 0.8)
                        end
                    end
                end
            end
        end
	end
end)

AddEventHandler('esx_fuelstation:FillJerryCanFromPump', function(pumpObject)
    local playerPed = PlayerPedId()
    TaskTurnPedToFaceEntity(playerPed, isNearPump, 1000)
    Wait(1000)

	LoadAnimDict("timetable@gardener@filling_can")
	TaskPlayAnim(playerPed, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)

    TriggerEvent('esx_fuelstation:startFillJerryCanFromPumpTick')
	while isFueling do
		for _, controlIndex in pairs(Config.DisableKeys) do
			DisableControlAction(0, controlIndex)
		end
        
        PumpCoords = GetEntityCoords(isNearPump)
        JerryFuel = GetAmmoInPedWeapon(playerPed, 883325847)

        ESX.Game.Utils.DrawText3D({x = PumpCoords.x, y = PumpCoords.y, z = PumpCoords.z + 1.2}, 'Kanister: '..JerryFuel..' / ' ..Config.JerryCanMaxFuel.. ' Liter', 0.8)

        if IsControlJustReleased(0, 38) or DoesEntityExist(GetPedInVehicleSeat(vehicle, -1)) or (isNearPump and GetEntityHealth(pumpObject) <= 0) or not pumpObject then
			isFueling = false
            Busy = true
            Wait(50)
            Busy = false
		end
		Wait(0)
	end

	ClearPedTasks(playerPed)
	RemoveAnimDict("timetable@gardener@filling_can")
end)

AddEventHandler('esx_fuelstation:startFillJerryCanFromPumpTick', function()
    local playerPed = PlayerPedId()

    while isFueling do
        Wait(1000)
        if not isNearPump then
            isFueling = false
        end

        JerryFuel = GetAmmoInPedWeapon(playerPed, 883325847)
        if JerryFuel >= Config.JerryCanMaxFuel then
            isFueling = false
        else
            SetPedAmmo(playerPed, 883325847, JerryFuel + 1)
        end
        currentCost = Config.Price

        if currentCash >= currentCost and GetAmmoInPedWeapon(playerPed, 883325847) >= Config.JerryCanMaxFuel then
            TriggerServerEvent('esx_fuelstation:pay', currentCost)
            SetPedAmmo(playerPed, 883325847, 20)
            isFueling = false
        end
    end
end)

AddEventHandler('esx_fuelstation:FillVehicleFromPump', function(vehicle, pumpObject)
    local playerPed = PlayerPedId()
    TaskTurnPedToFaceEntity(playerPed, vehicle, 1000)
    Wait(1000)

    if pumpObject then
		SetCurrentPedWeapon(ped, -1569615261, true)
	end

	LoadAnimDict("timetable@gardener@filling_can")
	TaskPlayAnim(playerPed, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)

    TriggerEvent('esx_fuelstation:startFillVehicleFromPumpTick', vehicle)
	while isFueling do
		for _, controlIndex in pairs(Config.DisableKeys) do
			DisableControlAction(0, controlIndex)
		end

        vehicleCoords = GetEntityCoords(vehicle)
        currentFuel = GetVehicleFuelLevel(vehicle)
        ESX.Game.Utils.DrawText3D({x = vehicleCoords.x, y = vehicleCoords.y, z = vehicleCoords.z + 1.2}, 'Fahrzeug: '..math.ceil(currentFuel)..' / ' ..math.ceil(Config.FuelClassesMax[GetVehicleClass(vehicle)]).. ' Liter', 0.8)

		if IsControlJustReleased(0, 38) or DoesEntityExist(GetPedInVehicleSeat(vehicle, -1)) or (isNearPump and GetEntityHealth(pumpObject) <= 0) or not pumpObject then
			isFueling = false
            Busy = true
            Wait(50)
            Busy = false
		end
		Wait(0)
	end

	ClearPedTasks(playerPed)
	RemoveAnimDict("timetable@gardener@filling_can")
end)

AddEventHandler('esx_fuelstation:startFillVehicleFromPumpTick', function(vehicle)
    local playerPed = PlayerPedId()

    while isFueling do
        Wait(1000)
        if not isNearPump then
            isFueling = false
        end
        currentCost = (Config.Price / 100) * (Config.FillPerTick * 100)
        newfuel = GetVehicleFuelLevel(vehicle) + Config.FillPerTick

        if currentCash >= currentCost and newfuel <= Config.FuelClassesMax[GetVehicleClass(vehicle)] then
            SetFuel(vehicle, newfuel)
            TriggerServerEvent('esx_fuelstation:pay', currentCost)
        else
            isFueling = false
        end
    end
end)


AddEventHandler('esx_fuelstation:FillVehicleFromJerryCan', function(vehicle)
    local playerPed = PlayerPedId()
    TaskTurnPedToFaceEntity(playerPed, vehicle, 1000)
    Wait(1000)

    if pumpObject then
		SetCurrentPedWeapon(ped, -1569615261, true)
	end

	LoadAnimDict("timetable@gardener@filling_can")
	TaskPlayAnim(playerPed, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)

    TriggerEvent('esx_fuelstation:startFillVehicleFromJerryCanTick', vehicle)
	while isFueling do
		for _, controlIndex in pairs(Config.DisableKeys) do
			DisableControlAction(0, controlIndex)
		end

        vehicleCoords = GetEntityCoords(vehicle)
        currentFuel = GetVehicleFuelLevel(vehicle)
        JerryFuel = GetAmmoInPedWeapon(playerPed, 883325847)
        ESX.Game.Utils.DrawText3D({x = vehicleCoords.x, y = vehicleCoords.y, z = vehicleCoords.z + 1.2}, 'Fahrzeug: '..math.ceil(currentFuel)..' / ' ..math.ceil(Config.FuelClassesMax[GetVehicleClass(vehicle)]).. ' Liter Kanister: '..JerryFuel..' / ' ..Config.JerryCanMaxFuel.. ' Liter', 0.8)

		if IsControlJustReleased(0, 38) or DoesEntityExist(GetPedInVehicleSeat(vehicle, -1)) or GetAmmoInPedWeapon(playerPed, 883325847) <= 0 then

            isFueling = false
            Busy = true
            Wait(50)
            Busy = false
		end
		Wait(0)
	end

	ClearPedTasks(playerPed)
	RemoveAnimDict("timetable@gardener@filling_can")
end)

AddEventHandler('esx_fuelstation:startFillVehicleFromJerryCanTick', function(vehicle)
    local playerPed = PlayerPedId()

    while isFueling do
        Wait(1000)
        newfuel = GetVehicleFuelLevel(vehicle) + 1.0
        JerryFuel = GetAmmoInPedWeapon(playerPed, 883325847)

        if newfuel <= Config.FuelClassesMax[GetVehicleClass(vehicle)] and GetAmmoInPedWeapon(playerPed, 883325847) > 0 then
            SetPedAmmo(playerPed, 883325847, JerryFuel - 1)
            SetFuel(vehicle, newfuel)
        else
            isFueling = false
        end
    end
end)

CreateThread(function()
	while true do
		Wait(1)
		if GetSelectedPedWeapon(PlayerPedId()) == 883325847 then
			DisablePlayerFiring(PlayerPedId(), true)
		end
	end
end)



CreateThread(function()
	DecorRegister(Config.FuelDecor, 1)

	while true do
		Wait(1000)

		local ped = PlayerPedId()

		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsIn(ped)

            ManageFuelUsage(vehicle)
		else
			if fuelSynced then
				fuelSynced = false
			end
		end
	end
end)

if Config.ShowNearestGasStationOnly then
	CreateThread(function()
		local currentGasBlip = {}

		while true do
			local coords = GetEntityCoords(PlayerPedId())
			local closest = 2000
			local closestCoords 
			local a = {}

			for _, station in pairs(Config.GasStations) do
				local dstcheck = GetDistanceBetweenCoords(coords, station.coords)


                if station.allowed_type == "aircraft" or v == "boat" then
                    table.insert(a, station.coords)
                else
                    if dstcheck < closest then
                        closest = dstcheck
                        closestCoords = station.coords
                        table.insert(a, closestCoords)
                    end
                end
			end
			
			for i, station in ipairs(currentGasBlip) do
				if DoesBlipExist(station) then
					RemoveBlip(station)
				end
			end

			for i, station in ipairs(a) do
				blip = CreateBlip(station)
				table.insert(currentGasBlip, blip)
			end
			Wait(10000)
		end
	end)
elseif Config.ShowAllGasStations then
	CreateThread(function()
		for _, station in pairs(Config.GasStations) do
			CreateBlip(station.coords)
		end
	end)
end