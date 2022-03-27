local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local HasAlreadyEnteredMarker = false
local LastZone                = nil
local actionDisplayed         = false
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local IsInShopMenu            = false
local Categories              = {}
local Vehicles                = {}
local LastVehicles            = {}
local CurrentVehicleData      = nil

ESX                           = nil

CreateThread(function ()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(0)
	end

	ESX.TriggerServerCallback('esx_vehicleshop:getVehicles', function (vehicles)
		Vehicles = vehicles
	end)
	Wait(1000)	
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx_vehicleshop:sendVehicles')
AddEventHandler('esx_vehicleshop:sendVehicles', function (vehicles)
	Vehicles = vehicles
end)

function DeleteShopInsideVehicles()
	while #LastVehicles > 0 do
		local vehicle = LastVehicles[1]

		ESX.Game.DeleteVehicle(vehicle)
		table.remove(LastVehicles, 1)
	end
end

function StartShopRestriction()

	CreateThread(function()
		while IsInShopMenu do
			Wait(1)
	
			DisableControlAction(0, 75,  true) -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		end
	end)

end

RegisterNUICallback('BuyVehicle', function(data, cb)
    SetNuiFocus(false, false)

    local model = data.model
	local playerPed = PlayerPedId()
	IsInShopMenu = false
	TriggerEvent('dopeNotify:Alert', _U('vehicleshop'), _U('wait_vehicle'), 5000, 'info')

    ESX.TriggerServerCallback('esx_vehicleshop:buyVehicle', function(hasEnoughMoney, CarType, Job, Donator)
		if hasEnoughMoney then
			local _Config
			if Donator then
				_Config = Config.Zones[tostring(CarType .. '_donator')]
			else
				_Config = Config.Zones[CarType]
			end
			ESX.Game.SpawnVehicle(model, _Config.Pos, _Config.Heading, function (vehicle)
				TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

				local newPlate     = GeneratePlate()
				local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
				vehicleProps.plate = newPlate
				SetVehicleNumberPlateText(vehicle, newPlate)
				if Config.EnableOwnedVehicles then
					TriggerServerEvent('esx_vehicleshop:setVehicleOwned', vehicleProps, CarType, Job)
				end
				TriggerEvent('dopeNotify:Alert', _U('vehicleshop'), _U('vehicle_purchased'), 5000, 'success')
				
			end)
		else
			TriggerEvent('dopeNotify:Alert', _U('vehicleshop'), _U('not_enough_money'), 5000, 'error')
		end
	end, model)
end)

RegisterNUICallback('CloseMenu', function(data, cb)
    SetNuiFocus(false, false)
	IsInShopMenu = false
	cb(false)
end)


RegisterCommand('closeshop', function() 
	SetNuiFocus(false, false)
    IsInShopMenu = false
end)

function OpenShopMenu()
	local _Config = Config.Zones[LastZone]
	local Allowed_Vehicles   = {}

	local count = 0
	for i=1, #Vehicles, 1 do
		local vehicle = Vehicles[i]
		if vehicle.donator == _Config.DonatorShop and vehicle.type == _Config.VehType then
			if vehicle.job ~= "" then
				if vehicle.job == ESX.PlayerData.job.name and ESX.PlayerData.job.can_managemoney then
					count = count + 1
					table.insert(Allowed_Vehicles, vehicle)
				end
			else
				count = count + 1
				table.insert(Allowed_Vehicles, vehicle)
			end
		end
	end



	local Allowed_Category = {}

	for i=1, #Allowed_Vehicles, 1 do
		exist = false
		local vehicle = Allowed_Vehicles[i]

		if type(next(Allowed_Category)) == "nil" then
			table.insert(Allowed_Category, vehicle.category)
		else
			for k=1, #Allowed_Category, 1 do
				local cat = Allowed_Category[k]
				if cat == vehicle.category then
					exist = true
				end
			end
			if not exist then
				table.insert(Allowed_Category, vehicle.category)
			end
		end
	end
	if type(next(Allowed_Vehicles)) ~= "nil" then
		if not IsInShopMenu then
			IsInShopMenu = true
			SetNuiFocus(true, true)

			SendNUIMessage({
    	        show = true,
				cars = Allowed_Vehicles,
				categories = Allowed_Category
    	    })
		end
	else
		TriggerEvent('dopeNotify:Alert', _U('vehicleshop'),"Der Händler hat keine Fahrzeuge zu verkaufen", 5000, 'error')
	end
end


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function (job)
	ESX.PlayerData.job = job
end)

AddEventHandler('esx_vehicleshop:hasEnteredMarker', function (zone)
	local PlayerData = ESX.GetPlayerData()
	local _Config = Config.Zones[zone]

	if _Config.VehicleShop then

		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('shop_menu')
		CurrentActionData = {}
		actionDisplayed = true

	elseif _Config.VehicleSell then
		local playerPed = PlayerPedId()

		if IsPedSittingInAnyVehicle(playerPed) then

			local vehicle     = GetVehiclePedIsIn(playerPed, false)
			local vehicleData, model, resellPrice, plate

			if GetPedInVehicleSeat(vehicle, -1) == playerPed then
				for i=1, #Vehicles, 1 do
					if GetHashKey(Vehicles[i].model) == GetEntityModel(vehicle) then
						vehicleData = Vehicles[i]
						break
					end
				end

				if vehicleData ~= nil then
					sellable = true
					label = vehicleData.name
					resellPrice = ESX.Math.Round(vehicleData.price / 100 * Config.ResellPercentage)
					model = GetEntityModel(vehicle)
					plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
				else
					sellable = false
					label = nil
					resellPrice = 0
					model = nil
					plate = nil
				end

				CurrentAction     = 'resell_vehicle'
				CurrentActionMsg  = _U('sell_vehicle2',resellPrice)
				ESX.ShowHelpNotification(_U('sell_vehicle2',GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)), resellPrice ))
				
				CurrentActionData = {
					vehicle = vehicle,
					label = label,
					price = resellPrice,
					model = model,
					plate = plate,
					sellable = sellable
				}
			end

		end

	end
end)

AddEventHandler('esx_vehicleshop:hasExitedMarker', function (zone)
	if not IsInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if IsInShopMenu then
			ESX.UI.Menu.CloseAll()

			DeleteShopInsideVehicles()

			local playerPed = PlayerPedId()
			
			FreezeEntityPosition(playerPed, false)
			SetEntityVisible(playerPed, true)
			SetEntityCoords(playerPed, Config.Zones.ShopEntering.Pos.x, Config.Zones.ShopEntering.Pos.y, Config.Zones.ShopEntering.Pos.z)
		end
	end
end)

-- Create Blips
CreateThread(function ()

	for k, v in pairs (Config.Zones) do
		if v.VehicleShop ~= nil then
			local bliptype = nil
			local blip = AddBlipForCoord(v.Pos.x, v.Pos.y, v.Pos.z)

			if v.VehType == "car" then
				bliptype = 326
			elseif v.VehType == "helicopter" then
				bliptype = 43
			elseif v.VehType == "plane" then
				bliptype = 423
			elseif v.VehType == "boat" then
				bliptype = 410
			else
				bliptype = 326
			end


			SetBlipSprite (blip, bliptype)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 0.8)
			SetBlipColour  (blip, 38)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(v.ShopName)
			EndTextCommandSetBlipName(blip)
		end
	end
end)

function Draw3DText(x,y,z,text,scale)
	local onScreen, _x, _y = World3dToScreen2d(x,y,z)
	local pX,pY,pZ = table.unpack(GetGameplayCamCoords())
	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(true)
	SetTextColour(255, 255, 255, 255)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len( text )) / 700
	DrawRect(_x, _y + 0.0150, 0.06 +factor, 0.03, 0, 0, 0, 200)
end

-- Display markers
CreateThread(function ()
	
	while true do
		Wait(0)

		local coords = GetEntityCoords(PlayerPedId())

		if(Config.Zones.ResellVehicle.Type ~= -1 and #(coords - Config.Zones.ResellVehicle.Pos) < Config.DrawDistance) then
			DrawMarker(Config.Zones.ResellVehicle.Type, Config.Zones.ResellVehicle.Pos.x, Config.Zones.ResellVehicle.Pos.y, Config.Zones.ResellVehicle.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Zones.ResellVehicle.Size.x, Config.Zones.ResellVehicle.Size.y, Config.Zones.ResellVehicle.Size.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
		end
	end
end)

CreateThread(function() 
	
	while true do
		Wait(0)
		local coords      = GetEntityCoords(PlayerPedId())
		for k,v in pairs(Config.Zones) do
			if v.Type == 36 then
				if #(coords - v.Pos) <= 8 then
					Draw3DText(v.Pos.x, v.Pos.y, v.Pos.z, _U('watch_catalog'),0.4)
				end
			end
		end
		
	end
	
end)


-- Enter / Exit marker events
CreateThread(function ()
	while true do
		Wait(0)

		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			if(#(coords - v.Pos) < 3.5) then
				isInMarker  = true
				currentZone = k
			end
		end

		if isInMarker then
			HasAlreadyEnteredMarker = true
			LastZone = currentZone
			TriggerEvent('esx_vehicleshop:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_vehicleshop:hasExitedMarker', LastZone)
		end
	end
end)

-- Key controls
CreateThread(function()
	while true do
		Wait(0)

		if CurrentAction == nil then
			Wait(0)
		else		
			if IsControlJustReleased(0, Keys['E']) then
				if CurrentAction == 'shop_menu' then
					OpenShopMenu()
				elseif CurrentAction == 'resell_vehicle' then
					ESX.TriggerServerCallback('esx_vehicleshop:resellVehicle', function(vehicleSold, sellable)
						if sellable == false then
							TriggerEvent('dopeNotify:Alert', _U('vehicleshop'),_U('not_sellable'), 5000, 'error')
						else
							if vehicleSold then
								ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
								TriggerEvent('dopeNotify:Alert', _U('vehicleshop'),_U('vehicle_sold_for', CurrentActionData.label, ESX.Math.GroupDigits(CurrentActionData.price)), 5000, 'success')
							else
								TriggerEvent('dopeNotify:Alert', _U('vehicleshop'),_U('not_yours'), 5000, 'error')
							end
						end
					end, CurrentActionData.plate, CurrentActionData.model, CurrentActionData.sellable)
				end
				CurrentAction = nil
			end
		end
	end
end)

CreateThread(function()
	RequestIpl('shr_int') -- Load walls and floor

	local interiorID = 7170
	LoadInterior(interiorID)
	EnableInteriorProp(interiorID, 'csr_beforeMission') -- Load large window
	RefreshInterior(interiorID)
end)
