ESX = nil
local HasAlreadyEnteredMarker = false
local LastZone = nil
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}
local ShopOpen = false

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	ESX.TriggerServerCallback('esx_weaponshop:getShop', function(shopItems)
		for k,v in pairs(shopItems) do
			Config.Zones[k].Items = v
		end
	end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function (job)
	ESX.PlayerData.job = job
end)


RegisterNetEvent('esx_weaponshop:sendShop')
AddEventHandler('esx_weaponshop:sendShop', function(shopItems)
	for k,v in pairs(shopItems) do
		Config.Zones[k].Items = v
	end
end)

function OpenShopMenu(zone)
	if ESX.PlayerData.job == nil then
		ESX.PlayerData = ESX.GetPlayerData()
	end

	local elements = {}
	ShopOpen = true
	local Allowed_Items = {}
	local Allowed_Categorys = {}

	SetNuiFocus(true, true)

	if Config.Blur then
		SetTimecycleModifier('hud_def_blur') -- blur
	end

	local count = 0
	for i=1, #Config.Zones[zone].Items, 1 do
		local item = Config.Zones[zone].Items[i]
		if item.job ~= "" then
			if item.job == ESX.PlayerData.job.name and ESX.PlayerData.job.can_managemoney then
				table.insert(Allowed_Items, item)
			end
		else
			table.insert(Allowed_Items, item)
		end
	end

	for i=1, #Allowed_Items, 1 do
		exist = false
		for k=1, #Allowed_Categorys, 1 do	
			if Allowed_Categorys[k] == Allowed_Items[i].category then
				exist = true
			end
		end
	
		if not exist then
			table.insert(Allowed_Categorys, Allowed_Items[i].category)
		end
	end

	SendNUIMessage({
		display = true,
		clear = true,
		categories = Allowed_Categorys,
		items = Allowed_Items
	})

end

AddEventHandler('esx_weaponshop:hasEnteredMarker', function(zone)
	if zone == 'GunShop' or zone == 'BlackWeashop' then
		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('shop_menu_prompt')
		CurrentActionData = { zone = zone }
	end
end)

AddEventHandler('esx_weaponshop:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if ShopOpen then
			ESX.UI.Menu.CloseAll()
		end
	end
end)

-- Create Blips
Citizen.CreateThread(function()
	for k,v in pairs(Config.Zones) do
		if v.Legal then
			for i = 1, #v.Locations, 1 do
				local blip = AddBlipForCoord(v.Locations[i])

				SetBlipSprite (blip, 110)
				SetBlipDisplay(blip, 4)
				SetBlipScale  (blip, 0.8)
				SetBlipColour (blip, 4)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentSubstringPlayerName(_U('map_blip'))
				EndTextCommandSetBlipName(blip)
			end
		end
	end
end)

-- Create DrawText
function DrawText3Ds(x, y, z, text)
	SetTextScale(0.25, 0.25)
	SetTextFont(0)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(true)
	AddTextComponentString(text)
	SetDrawOrigin(x,y,z, 0)
	DrawText(0.0, 0.0)
	local factor = (string.len(text)) / 370
	DrawRect(0.0, 0.0+0.0125, 0.025+ factor, 0.03, 0, 0, 0, 75)
	ClearDrawOrigin()
end

-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local coords = GetEntityCoords(PlayerPedId())

		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Locations, 1 do
				if (Config.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Locations[i], true) < Config.DrawDistance) then
					DrawMarker(-1, v.Locations[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
					DrawText3Ds(v.Locations[i].x, v.Locations[i].y, v.Locations[i].z + 1.0, '~g~E~w~ - Open Weapon Shop')
				end
			end
		end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
		local isInMarker, currentZone = false, nil

		for k,v in pairs(Config.Zones) do
			for i=1, #v.Locations, 1 do
				if GetDistanceBetweenCoords(coords, v.Locations[i], true) < Config.Size.x then
					isInMarker, ShopItems, currentZone, LastZone = true, v.Items, k, k
				end
			end
		end

		if isInMarker and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
			TriggerEvent('esx_weaponshop:hasEnteredMarker', currentZone)
		end
		
		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_weaponshop:hasExitedMarker', LastZone)
		end
	end
end)


-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if CurrentAction ~= nil then

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'shop_menu' then
					OpenShopMenu(CurrentActionData.zone)
				end
			end
		end
	end
end)


RegisterNUICallback('buyItem', function(data, cb)
	ESX.TriggerServerCallback('esx_weaponshop:buyWeapon', function(success)
		if success then
			ESX.ShowNotification('Successful purchase')
		else
			PlaySoundFrontend(-1, 'ERROR', 'HUD_AMMO_SHOP_SOUNDSET', false)
	   end
	end, data.item, data.zone)
end)

RegisterNUICallback('focusOff', function(data, cb)
	SetNuiFocus(false, false)
   
	if Config.Blur then 
		SetTimecycleModifier('default') -- remove blur
	end
end)     