
local shouldSendNUIUpdate = false
local isHudHidden = true
local isBeltHidden = true
seatbeltOn = false

local lastCarLS_r, lastCarLS_o, lastCarLS_h
local lastCarFuelAmount, lastCarHandbreak, lastCarBrakePressure, lastseatbelt, lastseat
local lastCarIL, lastCarRPM, lastCarSpeed, lastCarGear
displayKMH = 0
local nitro = 0

local function DisableVehicleExit()
	while true do
		Wait(0)
		if GetPedConfigFlag(PlayerPedId(), 32) == false then
			DisableControlAction(0, 75, true)
		end
	end
end

RegisterCommand('*seat_belt', function()
	local PlayerPed = PlayerPedId()
	local PlayerVehicle = GetVehiclePedIsUsing(PlayerPed)
	local VehicleClass = GetVehicleClass(PlayerVehicle)
	local seat_belt


	if GetPedConfigFlag(PlayerPed, 32) == false then
		seat_belt = true
	else
		seat_belt = false
	end

	if IsPedInAnyVehicle(PlayerPed, false) and VehicleClass ~= 8 and VehicleClass ~= 13 and VehicleClass ~= 14 and VehicleClass ~= 15 and VehicleClass ~= 16 then

		if not seat_belt then
			TriggerServerEvent('InteractSound_SV:PlayOnSource', 'carbuckle', 0.25)
			TriggerEvent('dopeNotify:Alert', "", "Du hast dich angeschnallt", 2000, 'carbuckle')
		else
			TriggerServerEvent('InteractSound_SV:PlayOnSource', 'carunbuckle', 0.25)
			TriggerEvent('dopeNotify:Alert', "", "Du hast dich abgeschnallt", 2000, 'carunbuckle')
		end

		SetPedConfigFlag(PlayerPed, 32, seat_belt)
		TriggerEvent('seatbelt:client:ToggleSeatbelt', not seat_belt)
		DisableVehicleExit()
	end
end, false)

function GetPedVehicleSeat(ped)
    local vehicle = GetVehiclePedIsIn(ped, false)
    for i=-2,GetVehicleMaxNumberOfPassengers(vehicle) do
        if(GetPedInVehicleSeat(vehicle, i) == ped) then return i end
    end
    return -2
end

CreateThread(function()
	while true do
		Wait(50)
		local PlayerPed = PlayerPedId()
		if IsPedInAnyVehicle(PlayerPed, false) then
			local currentVehicle = GetVehiclePedIsUsing(PlayerPed)
			local class = GetVehicleClass(currentVehicle)
			local seat = GetPedVehicleSeat(PlayerPed)

			SendNUIMessage({action = "seatbelt", seatbelted = GetPedConfigFlag(PlayerPed, 32)})

			if DoesEntityExist(currentVehicle) and class ~= 15 and class ~= 16 and class ~=21 and class ~=13 then
				if isBeltHidden then
					isBeltHidden = false
					SendNUIMessage({action = "show_seatbelt", show = true})	
				end
				if seat == -1 then
					if isHudHidden then
						isHudHidden = false
						SendNUIMessage({HideHud = isHudHidden})
					end
					local carRPM = GetVehicleCurrentRpm(currentVehicle)
	
					local multiplierUnit = 2.8
	
					if Config.Unit == "KMH" then
						multiplierUnit = 3.6
					end
	
					local carSpeed = math.floor(GetEntitySpeed(currentVehicle) * multiplierUnit)
					local carGear = GetVehicleCurrentGear(currentVehicle)
					local carHandbrake = GetVehicleHandbrake(currentVehicle)
					local carBrakePressure = GetVehicleWheelBrakePressure(currentVehicle, 0)
					local fuelamount = GetVehicleFuelLevel(currentVehicle) or 0
					local nowseat = GetPedVehicleSeat(PlayerPed)
	
					shouldSendNUIUpdate = false
	
					if lastCarRPM ~= carRPM then lastCarRPM = carRPM shouldSendNUIUpdate = true end
					if lastCarSpeed ~= carSpeed then lastCarSpeed = carSpeed shouldSendNUIUpdate = true end
					if lastCarGear ~= carGear then lastCarGear = carGear shouldSendNUIUpdate = true end
					if lastCarHandbreak ~= carHandbrake then lastCarHandbreak = carHandbrake shouldSendNUIUpdate = true end
					if lastCarBrakePressure ~= carBrakePressure then lastCarBrakePressure = carBrakePressure shouldSendNUIUpdate = true end
					if lastseatbelt ~= seatbeltOn then lastseatbelt = seatbeltOn shouldSendNUIUpdate = true end
					if lastseat ~= nowseat then lastseat = nowseat shouldSendNUIUpdate = true end
					if lastCarFuelAmount ~= fuelamount then lastCarFuelAmount = fuelamount shouldSendNUIUpdate = true end
		
					if shouldSendNUIUpdate then
						SendNUIMessage({
							ShowHud = true,
							CurrentCarRPM = carRPM * 10,
							CurrentUnitDistance = Config.Unit,
							CurrentCarGear = carGear,
							CurrentCarSpeed = carSpeed,
							CurrentCarHandbrake = carHandbrake,
							CurrentCarFuelAmount = math.ceil(fuelamount),
							CurrentDisplayKMH = displayKMH,
							CurrentCarBrake = carBrakePressure,
							CurrentNitro = nitro
						})
					end
				else
					if not isHudHidden then
						isHudHidden = true
						SendNUIMessage({HideHud = isHudHidden})
					end	
				end
			else
				if not isBeltHidden then
					isBeltHidden = true
					SendNUIMessage({action = "show_seatbelt", show = isBeltHidden})
				end
				if not isHudHidden then
					isHudHidden = true
					SendNUIMessage({HideHud = isHudHidden})
				end	
			end
		else
			if not isBeltHidden then
				isBeltHidden = true
				SendNUIMessage({action = "show_seatbelt", show = false})
			end
			if not isHudHidden then
				isHudHidden = true
				SendNUIMessage({HideHud = isHudHidden})
			end
		end
	end
end)


CreateThread(function()	
	SetFlyThroughWindscreenParams(20.0, 0.0, 0.0, 15.0)

	while true do
		Wait(500)

		if not isHudHidden or not isBeltHidden then
			if not Config.ShowStreetName then
				HideHudComponentThisFrame(9)
				HideHudComponentThisFrame(7)
			end

			if not Config.ShowClassVehicleName then
				HideHudComponentThisFrame(6)
				HideHudComponentThisFrame(8)
			end
			Wait(1)
		end
				
	end
end)