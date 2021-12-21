ESX = nil
local PlayerData = {}
local HasAlreadyEnteredMarker = false
local CurrentAction
local CurrentActionMsg
local CurrentActionData = {}
local isHandcuffed = false
local dragStatus = {}
dragStatus.isDragged = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end

	while PlayerData.job == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		PlayerData = ESX.GetPlayerData()
		Citizen.Wait(111)
	end

	Wait(5000)
	PlayerData = ESX.GetPlayerData()
	for k, v in pairs (gangs) do
		if v.job ~= nil and v.job == PlayerData.job.name then
			local blip = AddBlipForCoord(v.pos)
			SetBlipSprite(blip, v.Blip.sprite)
			SetBlipDisplay(blip, 4)
			SetBlipScale(blip, v.Blip.scale)
			SetBlipColour(blip, v.Blip.color)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName('STRING')	
			AddTextComponentSubstringPlayerName(PlayerData.job.label)
			EndTextCommandSetBlipName(blip)
		end
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if PlayerData.job then
			for k, v in pairs (gangs) do
				if v.job ~= nil and v.job == PlayerData.job.name then

					local playerPed = PlayerPedId()
					local coords    = GetEntityCoords(playerPed)

					local isInMarker = false 
					local hasExited = false
					local currentPart
					local LastPart

					local distance = GetDistanceBetweenCoords(coords, v.armory, true)
					if distance < Config.DrawDistance then
						DrawMarker(21, v.armory, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
					end
					if distance < Config.MarkerSize.x then
						isInMarker = true
						currentPart = 'Armory'
					end


					local distance = GetDistanceBetweenCoords(coords, v.boss, true)

					if distance < Config.DrawDistance then
						DrawMarker(22, v.boss, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
					end
					if distance < Config.MarkerSize.x then
						isInMarker = true
						currentPart = 'Boss'
					end



					if isInMarker and not HasAlreadyEnteredMarker then
						HasAlreadyEnteredMarker = true
						LastPart = currentPart
						TriggerEvent('esx_gangjobs:hasEnteredMarker', currentPart, v.job)
					end

					if not isInMarker and HasAlreadyEnteredMarker then
						HasAlreadyEnteredMarker = false
						TriggerEvent('esx_gangjobs:hasExitedMarker', LastPart, v.job)
					end
				end
			end
		end
	end
end)

AddEventHandler('esx_gangjobs:hasEnteredMarker', function(currentPart, station)
	if currentPart == 'Armory' then
		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}
	elseif currentPart == 'Boss' then
		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = _U('open_bossmenu')
		CurrentActionData = {}
	end
end)

AddEventHandler('esx_gangjobs:hasExitedMarker', function(LastPart, station)
	if not isInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)
			if IsControlJustReleased(0, 38) then
				for k, v in pairs (gangs) do
					if v.job ~= nil and v.job == PlayerData.job.name then
						if CurrentAction == 'menu_armory' then
							OpenGangArmoryMenu(CurrentActionData.station)
						elseif CurrentAction == 'menu_boss_actions' then
							ESX.UI.Menu.CloseAll()
							TriggerEvent('esx_society:openBossMenu', 'grove', function(data, menu)
								menu.close()
								CurrentAction     = 'menu_boss_actions'
								CurrentActionMsg  = _U('open_bossmenu')
								CurrentActionData = {}
							end, { wash = false })
						end
					end
				end
			end
		end


		if IsControlJustReleased(0, 167) and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'gang_actions') then
			for k, v in pairs (gangs) do
				if v.job ~= nil and v.job == PlayerData.job.name then
					OpenGangActionsMenu()
				end
			end
		end
	end
end)

function OpenGangActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gang_actions', {
		title    = 'Gang',
		align    = 'top-left',
		elements = {
			{label = _U('citizen_interaction'), value = 'citizen_interaction'}
	}}, function(data, menu)
		if data.current.value == 'citizen_interaction' then
			local elements = {
				{label = _U('id_card'), value = 'identity_card'},
				{label = _U('search'), value = 'body_search'},
				{label = _U('handcuff'), value = 'handcuff'},
				{label = _U('drag'), value = 'drag'},
				{label = _U('put_in_vehicle'), value = 'put_in_vehicle'},
				{label = _U('out_the_vehicle'), value = 'out_the_vehicle'},
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title    = _U('citizen_interaction'),
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
					local action = data2.current.value

					if action == 'identity_card' then
						OpenIdentityCardMenu(closestPlayer)
					elseif action == 'body_search' then
						TriggerServerEvent('esx_gangjobs:message', GetPlayerServerId(closestPlayer), _U('being_searched'))
						OpenBodySearchMenu(closestPlayer)
					elseif action == 'handcuff' then
						TriggerServerEvent('esx_gangjobs:handcuff', GetPlayerServerId(closestPlayer))
					elseif action == 'drag' then
						TriggerServerEvent('esx_gangjobs:drag', GetPlayerServerId(closestPlayer))
					elseif action == 'put_in_vehicle' then
						TriggerServerEvent('esx_gangjobs:putInVehicle', GetPlayerServerId(closestPlayer))
					elseif action == 'out_the_vehicle' then
						TriggerServerEvent('esx_gangjobs:OutVehicle', GetPlayerServerId(closestPlayer))
					end
				else
					ESX.ShowNotification(_U('no_players_nearby'))
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('esx_gangjobs:handcuff')
AddEventHandler('esx_gangjobs:handcuff', function()
	isHandcuffed = not isHandcuffed
	local playerPed = PlayerPedId()

	Citizen.CreateThread(function()
		if isHandcuffed then

			RequestAnimDict('mp_arresting')
			while not HasAnimDictLoaded('mp_arresting') do
				Citizen.Wait(100)
			end

			TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)

			SetEnableHandcuffs(playerPed, true)
			DisablePlayerFiring(playerPed, true)
			SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
			SetPedCanPlayGestureAnims(playerPed, false)
			FreezeEntityPosition(playerPed, true)
			DisplayRadar(false)
		else
			ClearPedSecondaryTask(playerPed)
			SetEnableHandcuffs(playerPed, false)
			DisablePlayerFiring(playerPed, false)
			SetPedCanPlayGestureAnims(playerPed, true)
			FreezeEntityPosition(playerPed, false)
			DisplayRadar(true)
		end
	end)
end)

RegisterNetEvent('esx_gangjobs:drag')
AddEventHandler('esx_gangjobs:drag', function(copId)
	if not isHandcuffed then
		return
	end

	dragStatus.isDragged = not dragStatus.isDragged
	dragStatus.CopId = copId
end)

Citizen.CreateThread(function()
	local playerPed
	local targetPed

	while true do
		Citizen.Wait(1)

		if isHandcuffed then
			playerPed = PlayerPedId()

			if dragStatus.isDragged then
				targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))

				if not IsPedSittingInAnyVehicle(targetPed) then
					AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				else
					dragStatus.isDragged = false
					DetachEntity(playerPed, true, false)
				end

				if IsPedDeadOrDying(targetPed, true) then
					dragStatus.isDragged = false
					DetachEntity(playerPed, true, false)
				end

			else
				DetachEntity(playerPed, true, false)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('esx_gangjobs:putInVehicle')
AddEventHandler('esx_gangjobs:putInVehicle', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	if not isHandcuffed then
		return
	end

	if IsAnyVehicleNearPoint(coords, 5.0) then
		local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

		if DoesEntityExist(vehicle) then
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
				dragStatus.isDragged = false
			end
		end
	end
end)

-- Handcuff
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if isHandcuffed then
			DisableControlAction(0, 1, true) -- Disable pan
			DisableControlAction(0, 2, true) -- Disable tilt
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			DisableControlAction(0, 32, true) -- W
			DisableControlAction(0, 34, true) -- A
			DisableControlAction(0, 31, true) -- S
			DisableControlAction(0, 30, true) -- D

			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 23, true) -- Also 'enter'?

			DisableControlAction(0, 288,  true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job

			DisableControlAction(0, 0, true) -- Disable changing view
			DisableControlAction(0, 26, true) -- Disable looking behind
			DisableControlAction(0, 73, true) -- Disable clearing animation
			DisableControlAction(2, 199, true) -- Disable pause screen

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, 36, true) -- Disable going stealth

			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle

			if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
				end)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('esx_gangjobs:OutVehicle')
AddEventHandler('esx_gangjobs:OutVehicle', function()
	local playerPed = PlayerPedId()

	if not IsPedSittingInAnyVehicle(playerPed) then
		return
	end

	local vehicle = GetVehiclePedIsIn(playerPed, false)
	TaskLeaveVehicle(playerPed, vehicle, 16)
end)


function OpenGangArmoryMenu(station)
	local elements = {
		{label = _U('get_weapon'), value = 'get_weapon'},
		{label = _U('put_weapon'), value = 'put_weapon'},
		{label = _U('remove_object'), value = 'get_stock'},
		{label = _U('deposit_object'), value = 'put_stock'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
		title    = _U('armory'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'get_weapon' then
			OpenGetWeaponMenu(station)
		elseif data.current.value == 'put_weapon' then
			OpenPutWeaponMenu(station)
		elseif data.current.value == 'put_stock' then
			OpenPutStocksMenu(station)
		elseif data.current.value == 'get_stock' then
			OpenGetStocksMenu(station)
		end

	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}
	end)
end


function OpenGetWeaponMenu(station)
	ESX.TriggerServerCallback('esx_gangjobs:getArmoryWeapons', function(weapons)
		local elements = {}

		for i=1, #weapons, 1 do
			if weapons[i].count > 0 then
				table.insert(elements, {
					label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name),
					value = weapons[i].name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon', {
			title    = _U('get_weapon_menu'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()

			ESX.TriggerServerCallback('esx_gangjobs:removeArmoryWeapon', function()
				OpenGetWeaponMenu(station)
			end, data.current.value, station)
		end, function(data, menu)
			menu.close()
		end)
	end, station)
end

function OpenPutWeaponMenu(station)
	local elements   = {}
	local playerPed  = PlayerPedId()
	local weaponList = ESX.GetWeaponList()

	for i=1, #weaponList, 1 do
		local weaponHash = GetHashKey(weaponList[i].name)

		if HasPedGotWeapon(playerPed, weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
			table.insert(elements, {
				label = weaponList[i].label,
				value = weaponList[i].name
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_put_weapon', {
		title    = _U('put_weapon_menu'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()

		ESX.TriggerServerCallback('esx_gangjobs:addArmoryWeapon', function()
			OpenPutWeaponMenu(station)
		end, data.current.value, true, station)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenPutStocksMenu(station)
	ESX.TriggerServerCallback('esx_gangjobs:getPlayerInventory', function(inventory)
		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = _U('inventory'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_gangjobs:putStockItems', itemName, count)

					Citizen.Wait(300)
					OpenPutStocksMenu(station)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end, station)
end

function OpenGetStocksMenu(station)
	ESX.TriggerServerCallback('esx_gangjobs:getStockItems', function(items)
		local elements = {}

		for i=1, #items, 1 do
			if items[i].count > 0 then
				table.insert(elements, {
					label = 'x' .. items[i].count .. ' ' .. items[i].label,
					value = items[i].name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = _U('gang_stock'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_gangjobs:getStockItem', itemName, count)

					Citizen.Wait(300)
					OpenGetStocksMenu(station)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end, station)
end
