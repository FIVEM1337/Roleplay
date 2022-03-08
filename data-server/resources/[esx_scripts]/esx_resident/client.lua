ESX = nil
local resident = false
local isInMarker = false
local HasAlreadyEnteredMarker = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	if ESX then
		ESX.TriggerServerCallback('esx_resident:getResidentStatus', function(status)
			resident = status
		end)
	end
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
		while ESX == nil do
			Citizen.Wait(1)
			if ESX then
				ESX.TriggerServerCallback('esx_resident:getResidentStatus', function(status)
					resident = status
				end)
			end
		end
    end
end)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(1)
		if resident then
			if(GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.Coord, true) < Config.Marker.distance) then
				DrawMarker(Config.Marker.type, Config.Coord, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.range, Config.Marker.range, 1.0, Config.Marker.red, Config.Marker.green, Config.Marker.blue, 100, false, true, 2, true, false, false, false)
			end

			if(GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.Coord, true) < Config.Marker.range -1) then
				isInMarker = true
			else
				isInMarker = false
			end

			if isInMarker and not HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = true
				showInfobar('Drücke ~g~E~s~, um zu verlassen')

			elseif not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
			end
		end
	end
end)

-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if isInMarker then
			if IsControlJustReleased(0, 38) then
				TriggerEvent('esx_resident:PortOutside')
				HasAlreadyEnteredMarker = false
			end
		end
	end
end)


RegisterNetEvent('esx_resident:PortOutside')
AddEventHandler('esx_resident:PortOutside', function(status)
    SetEntityCoords(GetPlayerPed(-1), Config.OutsideCoords)
end)

function showInfobar(msg)
	SetTextComponentFormat('STRING')
	AddTextComponentString(msg)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
