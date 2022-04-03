function FindNearestFuelPump()
	local coords = GetEntityCoords(PlayerPedId())
	local fuelPumps = {}
	local handle, object = FindFirstObject()
	local success

	repeat
		if Config.PumpModels[GetEntityModel(object)] then
			table.insert(fuelPumps, object)
		end

		success, object = FindNextObject(handle, object)
	until not success

	EndFindObject(handle)

	local pumpObject = 0
	local pumpDistance = 1000

	for _, fuelPumpObject in pairs(fuelPumps) do
		local dstcheck = GetDistanceBetweenCoords(coords, GetEntityCoords(fuelPumpObject))

		if dstcheck < pumpDistance then
			pumpDistance = dstcheck
			pumpObject = fuelPumpObject
		end
	end

	return pumpObject, pumpDistance
end

function LoadAnimDict(dict)
	if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict)

		while not HasAnimDictLoaded(dict) do
			Wait(1)
		end
	end
end

function SetFuel(vehicle, fuel)
	if type(fuel) == 'number' and fuel >= 0 and fuel <= 100 then
		SetVehicleFuelLevel(vehicle, fuel + 0.0)
		DecorSetFloat(vehicle, Config.FuelDecor, GetVehicleFuelLevel(vehicle))
	end
end

function GetFuel(vehicle)
	return DecorGetFloat(vehicle, Config.FuelDecor)
end

function GetClosestGasStation()
	local coords = GetEntityCoords(PlayerPedId())
	local closestStation

	for k,v in pairs(Config.GasStations) do
		local dstcheck = GetDistanceBetweenCoords(coords, v.coords)

		if dstcheck < 50.0 then
			closest = dstcheck
			closestStation = v
		end
	end

	return closestStation
end

function IsCorrectVehicleType(vehicle)
	vehicleclass = GetVehicleClass(vehicle)
	station = GetClosestGasStation()

    if vehicleclass ~= 14 and vehicleclass ~= 15 and vehicleclass ~= 16 then
        if station.allowed_type == "car" then
            return true
        end
    elseif vehicleclass == 15 or vehicleclass == 16 then
        if station.allowed_type == "aircraft" then
            return true
        end
    elseif vehicleclass == 14 then
        if station.allowed_type == "boat" then
            return true
        end
    end
    return false
end

function ManageFuelUsage(vehicle)
	local usage = Config.FuelUsage[Round(GetVehicleCurrentRpm(vehicle), 1)]

	if usage == 0.0 then
		usage = 0.2
	end

	if IsVehicleEngineOn(vehicle) then
		SetFuel(vehicle, GetVehicleFuelLevel(vehicle) - usage * (Config.Classes[GetVehicleClass(vehicle)] or 1.0) / 10)
    end
end

function CreateBlip(coords)
	for _, station in pairs(Config.GasStations) do
		if station.coords == coords then
			local blip = AddBlipForCoord(station.coords)

			SetBlipSprite(blip, 361)
			SetBlipScale(blip, 0.9)
			SetBlipColour(blip, 4)
			SetBlipDisplay(blip, 4)
			SetBlipAsShortRange(blip, true)
		
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(station.blipname)
			EndTextCommandSetBlipName(blip)
		
			return blip
		end
	end
end