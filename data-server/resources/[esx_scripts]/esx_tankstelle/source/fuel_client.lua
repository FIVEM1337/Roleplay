ESX = nil

local isNearPump = false
local isFueling = false
local currentFuel = 0.0
local currentCost = 0.0
local currentCash = 1000
local fuelSynced = false
local inBlacklisted = false
local compFuel = 0.0
local compFuel2 = 0.0
local enableField = false

CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(100)
	end
end)


AddEventHandler('onResourceStart', function(name)
    if GetCurrentResourceName() ~= name then
        return
    end

    close()
end)

function open()
    SetNuiFocus(true, true)
	enableField = true

	SendNUIMessage({
		action = "open",
    })

	SendNUIMessage({
		action = "tankpreis",
		tankpreis = tostring(Round(Config.CostMultiplier, 2)) .. "0"
	})

	SendNUIMessage({
		action = "price",
		price = "$ " .. Round(0, 1)
	})

	SendNUIMessage({
		action = "currentfuel",
		currentfuel = Round(GetVehicleFuelLevel(GetPlayersLastVehicle()), 1)
	})

	SendNUIMessage({
		action = "max",
		max = Config.FuelClassesMax[GetVehicleClass(GetPlayersLastVehicle())] .. " L"
	})
end
  
function close()
	SetNuiFocus(false, false)
	enableField = false
	
	SendNUIMessage({
		action = "close"
	})
	isFueling = false

	ClearPedTasks(PlayerPedId())
	RemoveAnimDict("timetable@gardener@filling_can")

	SendNUIMessage({
		action = "currentfuel",
		currentfuel = Round(0, 1)
	})

	SendNUIMessage({
		action = "compfuel",
		currentfuel = Round(0, 1)
	})

	SendNUIMessage({
		action = "tankpreis",
		currentfuel = "0 L"
	})
end

RegisterNUICallback('escape', function(data, cb)
	close()
end)

function ManageFuelUsage(vehicle)
	if not DecorExistOn(vehicle, Config.FuelDecor) then
		SetFuel(vehicle, math.random(200, 800) / 10)
	elseif not fuelSynced then
		SetFuel(vehicle, GetFuel(vehicle))

		fuelSynced = true
	end

	if IsVehicleEngineOn(vehicle) then
		SetFuel(vehicle, GetVehicleFuelLevel(vehicle) - Config.FuelUsage[Round(GetVehicleCurrentRpm(vehicle), 1)] * (Config.Classes[GetVehicleClass(vehicle)] or 1.0) / 10)
	end
end

CreateThread(function()
	DecorRegister(Config.FuelDecor, 1)

	for index = 1, #Config.Blacklist do
		if type(Config.Blacklist[index]) == 'string' then
			Config.Blacklist[GetHashKey(Config.Blacklist[index])] = true
		else
			Config.Blacklist[Config.Blacklist[index]] = true
		end
	end

	for index = #Config.Blacklist, 1, -1 do
		table.remove(Config.Blacklist, index)
	end

	while true do
		Wait(1000)

		local ped = PlayerPedId()

		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsIn(ped)

			if Config.Blacklist[GetEntityModel(vehicle)] then
				inBlacklisted = true
			else
				inBlacklisted = false
			end

			if not inBlacklisted and GetPedInVehicleSeat(vehicle, -1) == ped then
				ManageFuelUsage(vehicle)
			end
		else
			if fuelSynced then
				fuelSynced = false
			end

			if inBlacklisted then
				inBlacklisted = false
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(250)

		local pumpObject, pumpDistance = FindNearestFuelPump()

		if pumpDistance < 2.5 then
			isNearPump = pumpObject

			if Config.UseESX then
				local playerData = ESX.GetPlayerData()
				for i=1, #playerData.accounts, 1 do
					if playerData.accounts[i].name == 'money' then
						currentCash = playerData.accounts[i].money
						break
					end
				end
			end
		else
			isNearPump = false

			Wait(math.ceil(pumpDistance * 20))
		end
	end
end)

AddEventHandler('fuel:startFuelUpTick', function(pumpObject, ped, vehicle)
	currentFuel = GetVehicleFuelLevel(vehicle)
	while isFueling do
		Wait(500)

		local oldFuel = DecorGetFloat(vehicle, Config.FuelDecor)
		local fuelToAdd
		if pumpObject then
			fuelToAdd = 0.1
		else
			fuelToAdd = 0.1
		end
		local extraCost = fuelToAdd * Config.CostMultiplier

		if not pumpObject then
			if GetAmmoInPedWeapon(ped, 883325847) - fuelToAdd >= 0 then
				currentFuel = oldFuel + fuelToAdd * 10

				SetPedAmmo(ped, 883325847, math.floor(GetAmmoInPedWeapon(ped, 883325847) - fuelToAdd))
			else
				isFueling = false
			end
		else
			currentFuel = oldFuel + fuelToAdd
			compFuel = compFuel + fuelToAdd
			compFuel2 = compFuel2 + fuelToAdd
		end

		if currentFuel > Config.FuelClassesMax[GetVehicleClass(vehicle)] then
			currentFuel = Config.FuelClassesMax[GetVehicleClass(vehicle)]
			isFueling = false
		end

		currentCost = currentCost + extraCost

		if currentCash >= currentCost and compFuel <= Config.FuelClassesMax[GetVehicleClass(vehicle)] then
			if pumpObject then
				SetFuel(vehicle, compFuel)
			else
				SetFuel(vehicle, currentFuel)
			end
		else
			isFueling = false
		end
	end

	if pumpObject then
		TriggerServerEvent('fuel:pay', currentCost)
	end

	currentCost = 0.0
end)

RegisterNUICallback('unfuel', function(data, cb)
	isFueling = false
end)

AddEventHandler('fuel:refuelFromPump', function(pumpObject, ped, vehicle)
	TaskTurnPedToFaceEntity(ped, vehicle, 1000)
	Wait(1000)
	if pumpObject then
		SetCurrentPedWeapon(ped, -1569615261, true)
	end
	LoadAnimDict("timetable@gardener@filling_can")
	TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)

	TriggerEvent('fuel:startFuelUpTick', pumpObject, ped, vehicle)
	while isFueling do
		for _, controlIndex in pairs(Config.DisableKeys) do
			DisableControlAction(0, controlIndex)
		end

		local vehicleCoords = GetEntityCoords(vehicle)

		DrawText3Ds(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 0.5, Config.Strings.CancelFuelingJerryCan .. "\nBenzinkanister: ~g~" .. Round(GetAmmoInPedWeapon(ped, 883325847) / 20 * 100, 1) .. "% | Fahrzeug: " .. Round(currentFuel, 1) .. "%")
		if IsControlJustReleased(0, 38) or DoesEntityExist(GetPedInVehicleSeat(vehicle, -1)) or (isNearPump and GetEntityHealth(pumpObject) <= 0) then
			isFueling = false
		end

		Wait(0)
	end
	TriggerServerEvent('esx_tankstelle:setjerryfuel', GetAmmoInPedWeapon(ped, 883325847))
	ClearPedTasks(ped)
	RemoveAnimDict("timetable@gardener@filling_can")
	compFuel2 = 0.0
end)

local vehicleToRefuel = GetPlayersLastVehicle()

function ShowAboveRadarMessage(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(0,1)
end

RegisterNUICallback('enternotify', function(data, cb)
	ShowAboveRadarMessage("Halte ENTER zum tanken.")
end)

RegisterNUICallback('refuel', function(data, cb)
	isFueling = true
	TriggerEvent('fuel:refuelFromPump', isNearPump, PlayerPedId(), GetPlayersLastVehicle())
	compFuel = GetVehicleFuelLevel(GetPlayersLastVehicle())
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
	while true do
		local ped = PlayerPedId()

		if not isFueling and ((isNearPump and GetEntityHealth(isNearPump) > 0) or (GetSelectedPedWeapon(ped) == 883325847 and not isNearPump)) then
			if IsPedInAnyVehicle(ped) and GetPedInVehicleSeat(GetVehiclePedIsIn(ped), -1) == ped then
				local pumpCoords = GetEntityCoords(isNearPump)

				DrawText3Ds(pumpCoords.x, pumpCoords.y, pumpCoords.z + 1.2, Config.Strings.ExitVehicle)
			else
				local vehicle = GetPlayersLastVehicle()
				local vehicleCoords = GetEntityCoords(vehicle)
				local correctVehileType = IsCorrectVehicleType(vehicle)

				if DoesEntityExist(vehicle) and GetDistanceBetweenCoords(GetEntityCoords(ped), vehicleCoords) < 2.5 and correctVehileType then
					if not DoesEntityExist(GetPedInVehicleSeat(vehicle, -1)) then
						local stringCoords = GetEntityCoords(isNearPump)
						local canFuel = true

						if GetSelectedPedWeapon(ped) == 883325847 then
							stringCoords = vehicleCoords

							if GetAmmoInPedWeapon(ped, 883325847) <= 0  then
								canFuel = false
							end
						end

						if GetVehicleFuelLevel(vehicle) < 95 and canFuel then
							if currentCash > 0 then
								DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, Config.Strings.EToRefuel)

								if IsControlJustReleased(0, 38) then
									isFueling = true
									if isNearPump then
										open()
									else
										TriggerEvent('fuel:refuelFromPump', isNearPump, ped, vehicle)
									end
									LoadAnimDict("timetable@gardener@filling_can")
									if not IsEntityPlayingAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 3) then
										TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
									end
								end
							else
								DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, Config.Strings.NotEnoughCash)
							end
						elseif not canFuel then
							DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, Config.Strings.JerryCanEmpty)
						else
							DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, Config.Strings.FullTank)
						end
					end
				elseif isNearPump then
					local stringCoords = GetEntityCoords(isNearPump)

					if currentCash >= Config.JerryCanCost then
						if HasPedGotWeapon(ped, 883325847) then
							local refillCost = Round(Config.RefillCost * (1 - GetAmmoInPedWeapon(ped, 883325847) / 20))
							if refillCost > 0 then
								if currentCash >= refillCost then
									DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, Config.Strings.RefillJerryCan .. refillCost.."$")

									if IsControlJustReleased(0, 38) then
										TriggerServerEvent('fuel:pay', refillCost)
										TriggerServerEvent('esx_tankstelle:setjerryfuel', 20)
									end
								else
									DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, Config.Strings.NotEnoughCashJerryCan)
								end
							else
								DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, Config.Strings.JerryCanFull)
							end
						end
					else
						DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, Config.Strings.NotEnoughCash)
					end
				else
					Wait(250)
				end
			end
		else
			Wait(250)
		end

		Wait(0)
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


				for k, v in pairs(station.allowedtypes) do
					if v == "aircraft" or v == "boat" then
						table.insert(a, station.coords)
					else
						if dstcheck < closest then
							closest = dstcheck
							closestCoords = station.coords
							table.insert(a, closestCoords)
						end
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

	for k, v in pairs(station.allowedtypes) do
		if v == "car" then
			if vehicleclass ~= 14 and vehicleclass ~= 15 and vehicleclass ~= 16 then
				return true
			end
		elseif v == "aircraft" then
			if vehicleclass == 15 or vehicleclass == 16 then
				return true
			end
		elseif v == "boat" then
			if vehicleclass == 14 then
				return true
			end
		end
	end
	return false
end