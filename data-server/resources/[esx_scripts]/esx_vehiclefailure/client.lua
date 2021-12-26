ESX               = nil


local enginerunning
local invehicle
local vehicle 

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local ped = GetPlayerPed(-1)
		if DoesEntityExist(ped) and IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) and not IsPauseMenuActive() then
			local engineRunning = GetIsVehicleEngineRunning(GetVehiclePedIsIn(ped, true))
			while engineRunning do
				Citizen.Wait(0)
				if DoesEntityExist(ped) and not IsPedInAnyVehicle(ped, false) and not IsEntityDead(ped) and not IsPauseMenuActive() then
					local veh = GetVehiclePedIsIn(ped, true)
					SetVehicleEngineOn(veh, true, true, true)
					SetVehicleJetEngineOn(veh, true, true, true)
					break
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
  while ESX == nil do
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	Citizen.Wait(0)
  end
end)


local pedInSameVehicleLast=false
local vehicle
local lastVehicle
local vehicleClass
local fCollisionDamageMult = 0.0
local fDeformationDamageMult = 0.0
local fEngineDamageMult = 0.0
local fBrakeForce = 1.0
local isBrakingForward = false
local isBrakingReverse = false

local healthEngineLast = 1000.0
local healthEngineCurrent = 1000.0
local healthEngineNew = 1000.0
local healthEngineDelta = 0.0
local healthEngineDeltaScaled = 0.0

local healthBodyLast = 1000.0
local healthBodyCurrent = 1000.0
local healthBodyNew = 1000.0
local healthBodyDelta = 0.0
local healthBodyDeltaScaled = 0.0

local healthPetrolTankLast = 1000.0
local healthPetrolTankCurrent = 1000.0
local healthPetrolTankNew = 1000.0
local healthPetrolTankDelta = 0.0
local healthPetrolTankDeltaScaled = 0.0
local tireBurstLuckyNumber

math.randomseed(GetGameTimer());

local tireBurstMaxNumber = config.randomTireBurstInterval * 1200; 												-- the tire burst lottery runs roughly 1200 times per minute
if config.randomTireBurstInterval ~= 0 then tireBurstLuckyNumber = math.random(tireBurstMaxNumber) end			-- If we hit this number again randomly, a tire will burst.

local function isPedDrivingAVehicle()
	local ped = GetPlayerPed(-1)
	vehicle = GetVehiclePedIsIn(ped, false)
	if IsPedInAnyVehicle(ped, false) then
		-- Check if ped is in driver seat
		if GetPedInVehicleSeat(vehicle, -1) == ped then
			local class = GetVehicleClass(vehicle)
			-- We don't want planes, helicopters, bicycles and trains
			if class ~= 15 and class ~= 16 and class ~=21 and class ~=13 then
				return true
			end
		end
	end
	return false
end


local function fscale(inputValue, originalMin, originalMax, newBegin, newEnd, curve)
	local OriginalRange = 0.0
	local NewRange = 0.0
	local zeroRefCurVal = 0.0
	local normalizedCurVal = 0.0
	local rangedValue = 0.0
	local invFlag = 0

	if (curve > 10.0) then curve = 10.0 end
	if (curve < -10.0) then curve = -10.0 end

	curve = (curve * -.1)
	curve = 10.0 ^ curve

	if (inputValue < originalMin) then
	  inputValue = originalMin
	end
	if inputValue > originalMax then
	  inputValue = originalMax
	end

	OriginalRange = originalMax - originalMin

	if (newEnd > newBegin) then
		NewRange = newEnd - newBegin
	else
	  NewRange = newBegin - newEnd
	  invFlag = 1
	end

	zeroRefCurVal = inputValue - originalMin
	normalizedCurVal  =  zeroRefCurVal / OriginalRange

	if (originalMin > originalMax ) then
	  return 0
	end

	if (invFlag == 0) then
		rangedValue =  ((normalizedCurVal ^ curve) * NewRange) + newBegin
	else
		rangedValue =  newBegin - ((normalizedCurVal ^ curve) * NewRange)
	end

	return rangedValue
end



local function tireBurstLottery()
	local tireBurstNumber = math.random(tireBurstMaxNumber)
	if tireBurstNumber == tireBurstLuckyNumber then
		-- We won the lottery, lets burst a tire.
		if GetVehicleTyresCanBurst(vehicle) == false then return end
		local numWheels = GetVehicleNumberOfWheels(vehicle)
		local affectedTire
		if numWheels == 2 then
			affectedTire = (math.random(2)-1)*4		-- wheel 0 or 4
		elseif numWheels == 4 then
			affectedTire = (math.random(4)-1)
			if affectedTire > 1 then affectedTire = affectedTire + 2 end	-- 0, 1, 4, 5
		elseif numWheels == 6 then
			affectedTire = (math.random(6)-1)
		else
			affectedTire = 0
		end
		SetVehicleTyreBurst(vehicle, affectedTire, false, 1000.0)
		tireBurstLuckyNumber = math.random(tireBurstMaxNumber)			-- Select a new number to hit, just in case some numbers occur more often than others
	end
end

if config.torqueMultiplierEnabled or config.preventVehicleFlip or config.limpMode then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			if config.torqueMultiplierEnabled or config.sundayDriver or config.limpMode then
				if pedInSameVehicleLast then
					local factor = 1.0
					if config.torqueMultiplierEnabled and healthEngineNew < 900 then
						factor = (healthEngineNew+200.0) / 1100
					end
					if config.sundayDriver and GetVehicleClass(vehicle) ~= 14 then -- Not for boats
						local accelerator = GetControlValue(2,71)
						local brake = GetControlValue(2,72)
						local speed = GetEntitySpeedVector(vehicle, true)['y']
						-- Change Braking force
						local brk = fBrakeForce
						if speed >= 1.0 then
							-- Going forward
							if accelerator > 127 then
								-- Forward and accelerating
								local acc = fscale(accelerator, 127.0, 254.0, 0.1, 1.0, 10.0-(config.sundayDriverAcceleratorCurve*2.0))
								factor = factor * acc
							end
							if brake > 127 then
								-- Forward and braking
								isBrakingForward = true
								brk = fscale(brake, 127.0, 254.0, 0.01, fBrakeForce, 10.0-(config.sundayDriverBrakeCurve*2.0))
							end
						elseif speed <= -1.0 then
							-- Going reverse
							if brake > 127 then
								-- Reversing and accelerating (using the brake)
								local rev = fscale(brake, 127.0, 254.0, 0.1, 1.0, 10.0-(config.sundayDriverAcceleratorCurve*2.0))
								factor = factor * rev
							end
							if accelerator > 127 then
								-- Reversing and braking (Using the accelerator)
								isBrakingReverse = true
								brk = fscale(accelerator, 127.0, 254.0, 0.01, fBrakeForce, 10.0-(config.sundayDriverBrakeCurve*2.0))
							end
						end
						if brk > fBrakeForce - 0.02 then brk = fBrakeForce end -- Make sure we can brake max.
						SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fBrakeForce', brk)  -- Set new Brake Force multiplier
					end
					if config.limpMode == true and healthEngineNew < config.engineSafeGuard + 5 then
						factor = config.limpModeMultiplier
					end
					SetVehicleEngineTorqueMultiplier(vehicle, factor)
				end
			end
			if config.preventVehicleFlip then
				local roll = GetEntityRoll(vehicle)
				if (roll > 130.0 or roll < -130.0) and GetEntitySpeed(vehicle) < 2 then
					DisableControlAction(2,59,true) -- Disable left/right
					DisableControlAction(2,60,true) -- Disable up/down
				end
			end
		end
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(50)
		local ped = GetPlayerPed(-1)
		if isPedDrivingAVehicle() then
			vehicle = GetVehiclePedIsIn(ped, false)
			vehicleClass = GetVehicleClass(vehicle)
			healthEngineCurrent = GetVehicleEngineHealth(vehicle)
			if healthEngineCurrent == 1000 then healthEngineLast = 1000.0 end
			healthEngineNew = healthEngineCurrent
			healthEngineDelta = healthEngineLast - healthEngineCurrent
			healthEngineDeltaScaled = healthEngineDelta * config.damageFactorEngine * config.classDamageMultiplier[vehicleClass] / 3

			healthBodyCurrent = GetVehicleBodyHealth(vehicle)
			if healthBodyCurrent == 1000 then healthBodyLast = 1000.0 end
			healthBodyNew = healthBodyCurrent
			healthBodyDelta = healthBodyLast - healthBodyCurrent
			healthBodyDeltaScaled = healthBodyDelta * config.damageFactorBody * config.classDamageMultiplier[vehicleClass]

			healthPetrolTankCurrent = GetVehiclePetrolTankHealth(vehicle)
			if config.compatibilityMode and healthPetrolTankCurrent < 1 then
				--	SetVehiclePetrolTankHealth(vehicle, healthPetrolTankLast)
				--	healthPetrolTankCurrent = healthPetrolTankLast
				healthPetrolTankLast = healthPetrolTankCurrent
			end
			if healthPetrolTankCurrent == 1000 then healthPetrolTankLast = 1000.0 end
			healthPetrolTankNew = healthPetrolTankCurrent
			healthPetrolTankDelta = healthPetrolTankLast-healthPetrolTankCurrent
			healthPetrolTankDeltaScaled = healthPetrolTankDelta * config.damageFactorPetrolTank * config.classDamageMultiplier[vehicleClass]

			if healthEngineCurrent > config.engineSafeGuard+1 then
				SetVehicleUndriveable(vehicle,false)
			end

			if healthEngineCurrent <= config.engineSafeGuard+1 and config.limpMode == false then
				SetVehicleUndriveable(vehicle,true)
			end

			-- If ped spawned a new vehicle while in a vehicle or teleported from one vehicle to another, handle as if we just entered the car
			if vehicle ~= lastVehicle then
				pedInSameVehicleLast = false
			end


			if pedInSameVehicleLast == true then
				-- Damage happened while in the car = can be multiplied

				-- Only do calculations if any damage is present on the car. Prevents weird behavior when fixing using trainer or other script
				if healthEngineCurrent ~= 1000.0 or healthBodyCurrent ~= 1000.0 or healthPetrolTankCurrent ~= 1000.0 then

					-- Combine the delta values (Get the largest of the three)
					local healthEngineCombinedDelta = math.max(healthEngineDeltaScaled, healthBodyDeltaScaled, healthPetrolTankDeltaScaled)

					-- If huge damage, scale back a bit
					if healthEngineCombinedDelta > (healthEngineCurrent - config.engineSafeGuard) then
						healthEngineCombinedDelta = healthEngineCombinedDelta * 0.7
					end

					-- If complete damage, but not catastrophic (ie. explosion territory) pull back a bit, to give a couple of seconds og engine runtime before dying
					if healthEngineCombinedDelta > healthEngineCurrent then
						healthEngineCombinedDelta = healthEngineCurrent - (config.cascadingFailureThreshold / 5)
					end


					------- Calculate new value

					healthEngineNew = healthEngineLast - healthEngineCombinedDelta


					------- Sanity Check on new values and further manipulations



					-- Prevent Engine going to or below zero. Ensures you can reenter a damaged car.
					if healthEngineNew < config.engineSafeGuard then
						healthEngineNew = config.engineSafeGuard
					end

					-- Prevent Explosions
					if config.compatibilityMode == false and healthPetrolTankCurrent < 750 then
						healthPetrolTankNew = 750.0
					end

					-- Prevent negative body damage.
					if healthBodyNew < 0  then
						healthBodyNew = 0.0
					end
				end
			else
				-- Just got in the vehicle. Damage can not be multiplied this round
				-- Set vehicle handling data
				fDeformationDamageMult = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fDeformationDamageMult')
				fBrakeForce = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fBrakeForce')
				local newFDeformationDamageMult = fDeformationDamageMult ^ config.deformationExponent	-- Pull the handling file value closer to 1
				if config.deformationMultiplier ~= -1 then SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fDeformationDamageMult', newFDeformationDamageMult * config.deformationMultiplier) end  -- Multiply by our factor
				if config.weaponsDamageMultiplier ~= -1 then SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fWeaponDamageMult', config.weaponsDamageMultiplier/config.damageFactorBody) end -- Set weaponsDamageMultiplier and compensate for damageFactorBody

				--Get the CollisionDamageMultiplier
				fCollisionDamageMult = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fCollisionDamageMult')
				--Modify it by pulling all number a towards 1.0
				local newFCollisionDamageMultiplier = fCollisionDamageMult ^ config.collisionDamageExponent	-- Pull the handling file value closer to 1
				SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fCollisionDamageMult', newFCollisionDamageMultiplier)

				--Get the EngineDamageMultiplier
				fEngineDamageMult = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fEngineDamageMult')
				--Modify it by pulling all number a towards 1.0
				local newFEngineDamageMult = fEngineDamageMult ^ config.engineDamageExponent	-- Pull the handling file value closer to 1
				SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fEngineDamageMult', newFEngineDamageMult)

				-- If body damage catastrophic, reset somewhat so we can get new damage to multiply
				if healthBodyCurrent < config.cascadingFailureThreshold then
					healthBodyNew = config.cascadingFailureThreshold
				end
				pedInSameVehicleLast = true
			end

			-- set the actual new values
			if healthEngineNew ~= healthEngineCurrent then
				SetVehicleEngineHealth(vehicle, healthEngineNew)
			end
			if healthBodyNew ~= healthBodyCurrent then SetVehicleBodyHealth(vehicle, healthBodyNew) end
			if healthPetrolTankNew ~= healthPetrolTankCurrent then SetVehiclePetrolTankHealth(vehicle, healthPetrolTankNew) end

			-- Store current values, so we can calculate delta next time around
			healthEngineLast = healthEngineNew
			healthBodyLast = healthBodyNew
			healthPetrolTankLast = healthPetrolTankNew
			lastVehicle=vehicle
			if config.randomTireBurstInterval ~= 0 and GetEntitySpeed(vehicle) > 10 then tireBurstLottery() end
		end
	end
end)


local First = vector3(0.0, 0.0, 0.0)
local Second = vector3(5.0, 5.0, 5.0)

local Vehicle = {Coords = nil, Vehicle = nil, Dimension = nil, IsInFront = false, Distance = nil}
Citizen.CreateThread(function()
	Citizen.Wait(200)
	while true do
		local ped = PlayerPedId()
		local closestVehicle, Distance = ESX.Game.GetClosestVehicle()
		local vehicleCoords = GetEntityCoords(closestVehicle)
		local dimension = GetModelDimensions(GetEntityModel(closestVehicle), First, Second)
		if Distance < 6.0  and not IsPedInAnyVehicle(ped, false) then
			Vehicle.Coords = vehicleCoords
			Vehicle.Dimensions = dimension
			Vehicle.Vehicle = closestVehicle
			Vehicle.Distance = Distance
			if GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle), GetEntityCoords(ped), true) > GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle) * -1, GetEntityCoords(ped), true) then
				Vehicle.IsInFront = false
			else
				Vehicle.IsInFront = true
			end
		else
			Vehicle = {Coords = nil, Vehicle = nil, Dimensions = nil, IsInFront = false, Distance = nil}
		end
		Citizen.Wait(500)
	end
end)

local angle = 0.0
local anglemax = 40.0
local anglemin = -40.0
local rotangle = 1.0

Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(1)
		local ped = PlayerPedId()
		if Vehicle.Vehicle ~= nil then
			if IsVehicleSeatFree(Vehicle.Vehicle, -1) and GetVehicleEngineHealth(Vehicle.Vehicle) <= config.engineSafeGuard then
				ESX.Game.Utils.DrawText3D({x = Vehicle.Coords.x, y = Vehicle.Coords.y, z = Vehicle.Coords.z}, 'Drücke [~g~SHIFT~w~] und [~g~ALT~w~] um Fahrzeug zu schieben', 0.8)
			end
	 

			if IsControlPressed(0, 21) and IsControlPressed(0, 19) and IsVehicleSeatFree(Vehicle.Vehicle, -1) and not IsEntityAttachedToEntity(ped, Vehicle.Vehicle) and GetVehicleEngineHealth(Vehicle.Vehicle) <= config.engineSafeGuard then
				NetworkRequestControlOfEntity(Vehicle.Vehicle)
				local coords = GetEntityCoords(ped)
				if Vehicle.IsInFront then    
					AttachEntityToEntity(PlayerPedId(), Vehicle.Vehicle, GetPedBoneIndex(6286), 0.0, Vehicle.Dimensions.y * -1 + 0.1 , Vehicle.Dimensions.z + 1.0, 0.0, 0.0, 180.0, 0.0, false, false, true, false, true)
				else
					AttachEntityToEntity(PlayerPedId(), Vehicle.Vehicle, GetPedBoneIndex(6286), 0.0, Vehicle.Dimensions.y - 0.3, Vehicle.Dimensions.z  + 1.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, true)
				end

				ESX.Streaming.RequestAnimDict('missfinale_c2ig_11')
				TaskPlayAnim(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0, -8.0, -1, 35, 0, 0, 0, 0)
				Citizen.Wait(200)

				local currentVehicle = Vehicle.Vehicle
				 while true do
					Citizen.Wait(5)
					local tangle = GetVehicleSteeringAngle(Vehicle.Vehicle)
					if IsDisabledControlPressed(0, 34) then -- KEY A
					  --TaskVehicleTempAction(PlayerPedId(), currentVehicle, 11, 1000)
					  if angle < anglemax then
						angle = angle + rotangle
						SetVehicleSteeringAngle(Vehicle.Vehicle, angle)
					  end
					end

					if IsDisabledControlPressed(0, 9) then -- KEY D
					  --TaskVehicleTempAction(PlayerPedId(), currentVehicle, 10, 1000)
					  if angle > anglemin then
						angle = angle - rotangle
						SetVehicleSteeringAngle(Vehicle.Vehicle, angle)
					  end
					  SetVehicleSteeringAngle(Vehicle.Vehicle, angle)
					end

					if IsDisabledControlPressed(0, 32) then -- KEY W
					  --TaskVehicleTempAction(PlayerPedId(), currentVehicle, 11, 1000)
					  if angle > 0.0 then
						angle = angle - rotangle
						SetVehicleSteeringAngle(Vehicle.Vehicle, angle)
					  elseif angle < 0.0 then
						angle = angle + rotangle
						SetVehicleSteeringAngle(Vehicle.Vehicle, angle)
					  end
					end

					if Vehicle.IsInFront then
						SetVehicleForwardSpeed(currentVehicle, -1.0)
					else
						SetVehicleForwardSpeed(currentVehicle, 1.0)
					end

					if HasEntityCollidedWithAnything(currentVehicle) then
						SetVehicleOnGroundProperly(currentVehicle)
					end

					if not IsDisabledControlPressed(0, 21) then -- KEY E
						DetachEntity(ped, false, false)
						StopAnimTask(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0)
						FreezeEntityPosition(ped, false)
						break
					end
				end
			end
		end
	end
end)