

local HasAlreadyEnteredMarker = false
local CurrentShop
local Vehicles = {}
local IsShopOpen = false

CreateThread(function()
	ESX.TriggerServerCallback('esx_vehicleshop:getVehicles', function (vehicles)
		Vehicles = vehicles
	end)
	CreateBlips()
	SpawnNpcs()
end)

CreateThread(function ()
	while true do
		Wait(2)
		coords = GetEntityCoords(PlayerPedId())
		for k, v in pairs(Config.VehicleShops) do
			if not v.npc then
				if(GetDistanceBetweenCoords(coords, v.coords, true) < v.draw_distance) then
					Draw3DText(v.coords, _U('shop_menu'), 0.4)
				end
			end
		end
	end
end)

-- Enter / Exit marker events
CreateThread(function ()
	while true do
		Wait(60)
		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local currentZone = nil

		for k, v in pairs(Config.VehicleShops) do
			if(GetDistanceBetweenCoords(coords, v.coords, true) < v.interact_distance) then
				isInMarker  = true
				currentZone = v
			end
		end

		if isInMarker and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
			CurrentShop = currentZone
		elseif not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			CurrentShop = nil
		end
	end
end)

-- Key controls
CreateThread(function()
	while true do
		Wait(0)
		if CurrentShop then
			if IsControlJustReleased(0, 38) then
				OpenVehicleShop(CurrentShop)
			end
		end
	end
end)

function OpenVehicleShop(Shop)
	local vehicles = {}
	local categories = {}

	for k, v in pairs(Vehicles) do
		local job
		if v.shop == Shop.shop_id then
			if v.job and v.job ~= "" and not string.match(v.job,"[^%w]") then
				job = v.job
				v.joblabel = ESX.PlayerData.job.label
			else
				v.job = nil
			end

			if not job or job == ESX.PlayerData.job.name and ESX.PlayerData.job.can_managecars then
				v.name = GetLabelText(GetDisplayNameFromVehicleModel(v.model):lower())
				table.insert(vehicles, v)
			end
		end
	end

	for k, v in pairs(Vehicles) do
		already_exist = false
		if type(next(categories)) == "nil" then
			table.insert(categories, v.category)
		else
			for k, cat in pairs(categories) do
				if v.category == cat then
					already_exist = true
				end
			end

			if not already_exist then
				table.insert(categories, v.category)
			end
		end
	end

	if not IsShopOpen then
		if tablelength(vehicles) > 0 then
			IsShopOpen = true
			SetNuiFocus(true, true)
	
			SendNUIMessage({
				show = true,
				cars = vehicles,
				categories = categories
			})
		else
			TriggerEvent('dopeNotify:Alert', _U('vehicleshop'), _U('no_vehicles'), 5000, 'info')
		end
	end
end

RegisterNUICallback('CloseMenu', function(data, cb)
	SetNuiFocus(false, false)
	IsShopOpen = false
end)

RegisterNUICallback('BuyVehicle', function(data, cb)
	SetNuiFocus(false, false)
	IsShopOpen = false
	local vehicle_id = data.id
	local playerPed = PlayerPedId()

	local vehicle_data
	for k, v in pairs(Vehicles) do
		if v.id == vehicle_id then
			vehicle_data = v
			break
		end
	end

	ESX.TriggerServerCallback('esx_vehicleshop:buyVehicle', function(hasEnoughMoney)
		if hasEnoughMoney then
			local spawn = CurrentShop.spawn_coords[vehicle_data.car_type]

			if spawn then
				local vehicle
				local count = 0
				while not vehicle do
					count = count + 1
					for k, spawn in pairs(spawn) do
						local closestVehicle, Distance = ESX.Game.GetClosestVehicle(spawn.coords)
						if Distance >= 2.5 or Distance == -1 then
							vehicle = SpawnVehicle(vehicle_data, spawn)
							break
						end
					end

					if not vehicle then
						TriggerEvent('dopeNotify:Alert', "Fahrzeughändler", "Versuche Fahrzeug auszuparken ".. count.."/10", 100, 'error')
					end
	
					if count >= 10 then
						SpawnVehicleInVoid(vehicle_data)
						break
					end
					Wait(1000)
				end
			else
				print("Error: No spawn coords for this vehicle")
			end
		else

			if vehicle_data.job and vehicle_data.job ~= "" and not string.match(vehicle_data.job,"[^%w]") then
				TriggerEvent('dopeNotify:Alert', _U('vehicleshop'), _U('not_enough_society_money'), 5000, 'error')
			else
				TriggerEvent('dopeNotify:Alert', _U('vehicleshop'), _U('not_enough_money'), 5000, 'error')
			end
		end
	end, vehicle_id)
end)

function SpawnVehicle(vehicle_data, spawn)
	ESX.Game.SpawnVehicle(vehicle_data.model, spawn.coords, spawn.heading, function (vehicle)
		local newPlate     = GeneratePlate()
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		vehicleProps.plate = newPlate
		SetVehicleNumberPlateText(vehicle, newPlate)
		SetVehicleEngineOn(vehicle, false, false, true)
		SetVehicleDoorsLocked(vehicle, 2)
		TriggerServerEvent('esx_vehicleshop:setVehicleOwned', vehicleProps, vehicle_data.id)
		TriggerEvent('dopeNotify:Alert', _U('vehicleshop'), _U('vehicle_purchased'), 5000, 'success')
	end)
	return true
end

function SpawnVehicleInVoid(vehicle_data)
	ESX.Game.SpawnVehicle(vehicle_data.model, vector3(4313.8110351563,-1654.6583251953,2113.6779785156), 0.0, function (vehicle)
		local newPlate     = GeneratePlate()
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		vehicleProps.plate = newPlate
		TriggerServerEvent('esx_vehicleshop:setVehicleOwned', vehicleProps, vehicle_data.id)
		TriggerEvent('dopeNotify:Alert', "Fahrzeughändler", "Aktuell sind alle Parkplätze belegt das Fahrzeug wird von uns in deine Garage geliefert", 5000, 'info')
		DeleteVehicle(vehicle)
		TriggerServerEvent('esx_garage:storeVehicle', vehicleProps.plate)
	end)
	return true
end