ESX 							= nil
local HasAlreadyEnteredMarker 	= false
local LastZone                	= nil
local CurrentAction				= nil
local infoped					= nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	TriggerEvent('esx_register:spawnnpc')

	while infoped ~= nil do
		Citizen.Wait(1)
		TaskSetBlockingOfNonTemporaryEvents(infoped, true)
	end
end)



-- Enter / Exit marker events
Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(0)

		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local currentZone = nil


		if(#(coords - Config.position) < 3.0) then
			isInMarker  = true
			currentZone = "register"
		end

		if isInMarker then
			HasAlreadyEnteredMarker = true
			LastZone = currentZone
			TriggerEvent('esx_register:hasEnteredMarker', LastZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_register:hasExitedMarker', LastZone)
		end
	end
end)

AddEventHandler('esx_register:spawnnpc', function ()
	RequestModel(Config.InfoPed)
	LoadPropDict(Config.InfoPed)

	local ped = CreatePed(5, Config.InfoPed , Config.position, 210.0, false, true)
	PlaceObjectOnGroundProperly(ped)
	SetEntityAsMissionEntity(ped)
	SetPedDropsWeaponsWhenDead(ped, false)
	FreezeEntityPosition(ped, true)
	SetPedAsEnemy(ped, false)
	SetEntityInvincible(ped, true)
	SetModelAsNoLongerNeeded(Config.InfoPed)
	SetPedCanBeTargetted(ped, false)
	infoped = ped
end)


AddEventHandler('esx_register:hasEnteredMarker', function (action)
    CurrentAction = action
end)

AddEventHandler('esx_register:hasExitedMarker', function (zone)
	CurrentAction = nil
end)

-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction == nil then
			Citizen.Wait(0)
		else		
			if IsControlJustReleased(0, 38) then
				ESX.TriggerServerCallback('esx_register:getname', function(name)
					if name.firstname == nil or name.lastname == nil or name.firstname == "" or name.lastname == "" then
						TriggerEvent('esx_multichar:RegisterAccount')
					else
						TriggerEvent('dopeNotify:Alert', "", "Du bist bereits registriert", 5000, 'error')
					end
				end)
			end
		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resourceName == GetCurrentResourceName() then
		if infoped ~= nil then
			DeletePed(infoped)
		end
	end
end)

function LoadPropDict(model)
	while not HasModelLoaded(GetHashKey(model)) do
	  RequestModel(GetHashKey(model))
	  Wait(10)
	end
end
