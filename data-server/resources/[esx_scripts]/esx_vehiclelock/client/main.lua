ESX = nil

local isRunningWorkaround = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function StartWorkaroundTask()
	if isRunningWorkaround then
		return
	end

	local timer = 0
	local playerPed = PlayerPedId()
	isRunningWorkaround = true

	while timer < 100 do
		Citizen.Wait(0)
		timer = timer + 1

		local vehicle = GetVehiclePedIsTryingToEnter(playerPed)

		if DoesEntityExist(vehicle) then
			local lockStatus = GetVehicleDoorLockStatus(vehicle)

			if lockStatus == 4 then
				ClearPedTasks(playerPed)
			end
		end
	end

	isRunningWorkaround = false
end

-- Keymappings
RegisterCommand('usevehiclekey', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local vehicle

	Citizen.CreateThread(function()
		StartWorkaroundTask()
	end)

	if IsPedInAnyVehicle(playerPed, false) then
		vehicle = GetVehiclePedIsIn(playerPed, false)
	else
		vehicle = GetClosestVehicle(coords, 8.0, 0, 71)
	end

	if not DoesEntityExist(vehicle) then
		return
	end

	ESX.TriggerServerCallback('esx_vehiclelock:requestPlayerCars', function(isOwnedVehicle)

		if isOwnedVehicle then
			local lockStatus = GetVehicleDoorLockStatus(vehicle)


			ESX.Streaming.RequestAnimDict("anim@mp_player_intmenu@key_fob@", function()
				TaskPlayAnim(PlayerPedId(), "anim@mp_player_intmenu@key_fob@", "fob_click_fp", 8.0, -8.0, -1, 0, 0.0, false, false, false)
			end)


			if lockStatus == 1 then -- unlocked
				SetVehicleDoorsLocked(vehicle, 2)
				PlayVehicleDoorCloseSound(vehicle, 1)
				TriggerEvent('dopeNotify:Alert', "", _U('message_locked'), 5000, 'locked')
				BlinkVehicleLights(vehicle)
			elseif lockStatus == 2 then -- locked
				SetVehicleDoorsLocked(vehicle, 1)
				PlayVehicleDoorOpenSound(vehicle, 0)
				TriggerEvent('dopeNotify:Alert', "", _U('message_unlocked'), 5000, 'unlocked')
				BlinkVehicleLights(vehicle)
			end
		end

	end, ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)))
end, true)
RegisterKeyMapping('usevehiclekey', _U('keymapping_desc'), 'keyboard', Config.DefaultOpenKey)



function BlinkVehicleLights(vehicle)
	Citizen.Wait(100)
	SetVehicleLights(vehicle, 2)
	Citizen.Wait(200)
	SetVehicleLights(vehicle, 1)
	Citizen.Wait(200)
	SetVehicleLights(vehicle, 2)
	Citizen.Wait(200)
	SetVehicleLights(vehicle, 1)
	Citizen.Wait(200)
	SetVehicleLights(vehicle, 2)
	Citizen.Wait(200)
	SetVehicleLights(vehicle, 0)
end