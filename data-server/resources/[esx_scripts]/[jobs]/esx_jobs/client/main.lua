ESX = nil
local PlayerData = {}
local blips_list = {}
local HasAlreadyEnteredMarker = false
local CurrentAction
local CurrentActionMsg
local CurrentActionData = {}
local isHandcuffed = false
local dragStatus = {}
local currentTask = {}
dragStatus.isDragged = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end

	while PlayerData.job == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		PlayerData = ESX.GetPlayerData()
		SetBlips()
		Citizen.Wait(111)
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData = ESX.GetPlayerData()
	SetBlips()
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3)
		if PlayerData.job then
			if jobs[PlayerData.job.name] then
				v = jobs[PlayerData.job.name]
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
				local distance = GetDistanceBetweenCoords(coords, v.cloak, true)
				if distance < Config.DrawDistance then
					DrawMarker(22, v.cloak, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
				end
				if distance < Config.MarkerSize.x then
					isInMarker = true
					currentPart = 'Cloack'
				end
				if isInMarker and not HasAlreadyEnteredMarker then
					HasAlreadyEnteredMarker = true
					LastPart = currentPart
					TriggerEvent('esx_jobs:hasEnteredMarker', currentPart, v.job)
				end
				if not isInMarker and HasAlreadyEnteredMarker then
					HasAlreadyEnteredMarker = false
					TriggerEvent('esx_jobs:hasExitedMarker', LastPart, v.job)
				end
			end
		end
	end
end)

AddEventHandler('esx_jobs:hasEnteredMarker', function(currentPart, station)
	if currentPart == 'Armory' then
		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}
	elseif currentPart == 'Boss' then
		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = _U('open_bossmenu')
		CurrentActionData = {}
	elseif currentPart == 'Cloack' then
		CurrentAction     = 'menu_cloackroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	end
end)

AddEventHandler('esx_jobs:hasExitedMarker', function(LastPart, station)
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
				if PlayerData.job then
					if jobs[PlayerData.job.name] then
						v = jobs[PlayerData.job.name]
						if CurrentAction == 'menu_armory' then
							OpenJobArmoryMenu(PlayerData.job.name)
						elseif CurrentAction == 'menu_boss_actions' then
							ESX.UI.Menu.CloseAll()
							TriggerEvent('esx_society:openBossMenu', PlayerData.job.name, function(data, menu)
								menu.close()
								CurrentAction     = 'menu_boss_actions'
								CurrentActionMsg  = _U('open_bossmenu')
								CurrentActionData = {}
							end, { wash = false })
						elseif CurrentAction == 'menu_cloackroom' then
							OpenCloakroomMenu(PlayerData.job.name)
						end
					end
				end
			end
		end


		if IsControlJustReleased(0, 167) and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'job_actions') then
			if PlayerData.job then
				if jobs[PlayerData.job.name] then
					v = jobs[PlayerData.job.name]
					OpenJobActionsMenu(v)
				end
			end
		end
	end
end)

RegisterNetEvent('esx_jobs:handcuff')
AddEventHandler('esx_jobs:handcuff', function()
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

RegisterNetEvent('esx_jobs:drag')
AddEventHandler('esx_jobs:drag', function(copId)
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

RegisterNetEvent('esx_jobs:putInVehicle')
AddEventHandler('esx_jobs:putInVehicle', function()
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

RegisterNetEvent('esx_jobs:OutVehicle')
AddEventHandler('esx_jobs:OutVehicle', function()
	local playerPed = PlayerPedId()

	if not IsPedSittingInAnyVehicle(playerPed) then
		return
	end

	local vehicle = GetVehiclePedIsIn(playerPed, false)
	TaskLeaveVehicle(playerPed, vehicle, 16)
end)

function OpenJobActionsMenu(JobConfig)
	ESX.UI.Menu.CloseAll()


	citizen_interaction_elements = {}
	if JobConfig.identity_card then
		table.insert(citizen_interaction_elements, {label = _U('id_card'), value = 'identity_card'})
	end
	if JobConfig.body_search then
		table.insert(citizen_interaction_elements, {label = _U('search'), value = 'body_search'})
	end
	if JobConfig.handcuff then
		table.insert(citizen_interaction_elements, {label = _U('handcuff'), value = 'handcuff'})
	end
	if JobConfig.drag then
		table.insert(citizen_interaction_elements, {label = _U('drag'), value = 'drag'})
	end
	if JobConfig.put_in_vehicle then
		table.insert(citizen_interaction_elements, {label = _U('put_in_vehicle'), value = 'put_in_vehicle'})
	end
	if JobConfig.out_the_vehicle then
		table.insert(citizen_interaction_elements, {label = _U('out_the_vehicle'), value = 'out_the_vehicle'})
	end
	if JobConfig.fine then
		table.insert(citizen_interaction_elements, {label = _U('fine'), value = 'fine'})
	end
	if JobConfig.unpaid_bills then
		table.insert(citizen_interaction_elements, {label = _U('unpaid_bills'), value = 'unpaid_bills'})
	end
	if JobConfig.ems_menu_revive then
		table.insert(citizen_interaction_elements, {label = _U('ems_menu_revive'), value = 'ems_menu_revive'})
	end
	if JobConfig.ems_menu_small then
		table.insert(citizen_interaction_elements, {label = _U('ems_menu_small'), value = 'ems_menu_small'})
	end
	if JobConfig.ems_menu_big then
		table.insert(citizen_interaction_elements, {label = _U('ems_menu_big'), value = 'ems_menu_big'})
	end


	vehicle_interaction_elements = {}
	if JobConfig.vehicle_infos then
		table.insert(vehicle_interaction_elements, {label = _U('vehicle_info'), value = 'vehicle_infos'})
		table.insert(vehicle_interaction_elements, {label = _U('search_database'), value = 'search_database'})
	end
	if JobConfig.hijack_vehicle then
		table.insert(vehicle_interaction_elements, {label = _U('pick_lock'), value = 'hijack_vehicle'})
	end
	if JobConfig.impound then
		table.insert(vehicle_interaction_elements, {label = _U('impound'), value = 'impound'})
	end


	main_elements = {}
	if not rawequal(next(citizen_interaction_elements), nil) then
		table.insert(main_elements, {label = _U('citizen_interaction'), value = 'citizen_interaction'})
	end
	if not rawequal(next(vehicle_interaction_elements), nil) then
		table.insert(main_elements, {label = _U('vehicle_interaction'), value = 'vehicle_interaction'})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_actions', {
		title    = 'Job Menü',
		align    = 'top-right',
		elements = main_elements
	}, function(data, menu)
		if data.current.value == 'citizen_interaction' then
	
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title    = _U('citizen_interaction'),
				align    = 'top-right',
				elements = citizen_interaction_elements
			}, function(data2, menu2)
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
					local action = data2.current.value

					if action == 'identity_card' then
						OpenIdentityCardMenu(closestPlayer)
					elseif action == 'body_search' then
						OpenBodySearchMenu(closestPlayer)
					elseif action == 'handcuff' then
						TriggerServerEvent('esx_jobs:handcuff', GetPlayerServerId(closestPlayer))
					elseif action == 'drag' then
						TriggerServerEvent('esx_jobs:drag', GetPlayerServerId(closestPlayer))
					elseif action == 'put_in_vehicle' then
						TriggerServerEvent('esx_jobs:putInVehicle', GetPlayerServerId(closestPlayer))
					elseif action == 'out_the_vehicle' then
						TriggerServerEvent('esx_jobs:OutVehicle', GetPlayerServerId(closestPlayer))
					elseif action == 'fine' then
						OpenFineMenu(closestPlayer)
					elseif action == 'license' then
						ShowPlayerLicense(closestPlayer)
					elseif action == 'unpaid_bills' then
						OpenUnpaidBillsMenu(closestPlayer)
					elseif action == 'ems_menu_revive' then
						revivePlayer(closestPlayer)
					elseif action == 'ems_menu_small' then
						HealPlayer(closestPlayer, "small")
					elseif action == 'ems_menu_big' then
						HealPlayer(closestPlayer, "big")
					end
				else
					ESX.ShowNotification(_U('no_players_nearby'))
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'vehicle_interaction' then
			local elements  = vehicle_interaction_elements
			local playerPed = PlayerPedId()
			local vehicle = ESX.Game.GetVehicleInDirection()

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_interaction', {
				title    = _U('vehicle_interaction'),
				align    = 'top-right',
				elements = elements
			}, function(data2, menu2)
				local coords  = GetEntityCoords(playerPed)
				vehicle = ESX.Game.GetVehicleInDirection()
				action  = data2.current.value

				if action == 'search_database' then
					LookupVehicle()
				elseif DoesEntityExist(vehicle) then
					if action == 'vehicle_infos' then
						local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
						OpenVehicleInfosMenu(vehicleData)
					elseif action == 'hijack_vehicle' then
						if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
							TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
							Citizen.Wait(20000)
							ClearPedTasksImmediately(playerPed)

							SetVehicleDoorsLocked(vehicle, 1)
							SetVehicleDoorsLockedForAllPlayers(vehicle, false)
							ESX.ShowNotification(_U('vehicle_unlocked'))
						end
					elseif action == 'impound' then
						if currentTask.busy then
							return
						end

						ESX.ShowHelpNotification(_U('impound_prompt'))
						TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)

						currentTask.busy = true
						currentTask.task = ESX.SetTimeout(10000, function()
							ClearPedTasks(playerPed)
							ImpoundVehicle(vehicle)
							Citizen.Wait(100)
						end)

						-- keep track of that vehicle!
						Citizen.CreateThread(function()
							while currentTask.busy do
								Citizen.Wait(1000)

								vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
								if not DoesEntityExist(vehicle) and currentTask.busy then
									ESX.ShowNotification(_U('impound_canceled_moved'))
									ESX.ClearTimeout(currentTask.task)
									ClearPedTasks(playerPed)
									currentTask.busy = false
									break
								end
							end
						end)
					end
				else
					ESX.ShowNotification(_U('no_vehicles_nearby'))
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenCloakroomMenu(job)
	local playerPed = PlayerPedId()
	local grade = ESX.PlayerData.job.grade_name

	local elements = {
		{label = _U('citizen_wear'), value = 'citizen_wear'},
		{label = _U('job_wear1'), value = 'job_wear1'},
		{label = _U('job_wear2'), value = 'job_wear2'},
		{label = _U('job_wear3'), value = 'job_wear3'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
		title    = _U('cloakroom'),
		align    = 'top-right',
		elements = elements
	}, function(data, menu)
		local action = data.current.value
		cleanPlayer(playerPed)

		if action == 'citizen_wear' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		elseif action == 'job_wear1' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				ESX.TriggerServerCallback('esx_jobs:getjobskin', function(jobskin)
					TriggerEvent('skinchanger:loadClothes', skin, json.decode(jobskin))
				end, skin.sex, 1)
			end)
		elseif action == 'job_wear2' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				ESX.TriggerServerCallback('esx_jobs:getjobskin', function(jobskin)
					TriggerEvent('skinchanger:loadClothes', skin, json.decode(jobskin))
				end, skin.sex, 2)
			end)

		elseif action == 'job_wear3' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				ESX.TriggerServerCallback('esx_jobs:getjobskin', function(jobskin)
					TriggerEvent('skinchanger:loadClothes', skin, json.decode(jobskin))
				end, skin.sex, 3)
			end)
		end

	end, function(data, menu)
		menu.close()
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	end)
end

function cleanPlayer(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end


function OpenJobArmoryMenu(station)
	local elements = {
		{label = _U('get_weapon'), value = 'get_weapon'},
		{label = _U('put_weapon'), value = 'put_weapon'},
		{label = _U('remove_object'), value = 'get_stock'},
		{label = _U('deposit_object'), value = 'put_stock'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
		title    = _U('armory'),
		align    = 'top-right',
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
	ESX.TriggerServerCallback('esx_jobs:getArmoryWeapons', function(weapons)
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
			align    = 'top-right',
			elements = elements
		}, function(data, menu)
			menu.close()

			ESX.TriggerServerCallback('esx_jobs:removeArmoryWeapon', function()
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
		align    = 'top-right',
		elements = elements
	}, function(data, menu)
		menu.close()

		ESX.TriggerServerCallback('esx_jobs:addArmoryWeapon', function()
			OpenPutWeaponMenu(station)
		end, data.current.value, true, station)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenPutStocksMenu(station)
	ESX.TriggerServerCallback('esx_jobs:getPlayerInventory', function(inventory)
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
			title    = _U('put_item_menu'),
			align    = 'top-right',
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
					TriggerServerEvent('esx_jobs:putStockItems', itemName, count)

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
	ESX.TriggerServerCallback('esx_jobs:getStockItems', function(items)
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
			title    = _U('get_item_menu'),
			align    = 'top-right',
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
					TriggerServerEvent('esx_jobs:getStockItem', itemName, count)

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

function DeleteBlips()
	for i, station in ipairs(blips_list) do
		if DoesBlipExist(station) then
			RemoveBlip(station)
		end
	end
	
	blips_list = {}
end

function SetBlips()
	DeleteBlips()
	for k, v in pairs (jobs) do
		if v.Blip.alwayshow then
			blip = CreateBlip(v.pos, v.Blip.sprite, v.Blip.scale, v.Blip.color, v.Blip.name)
			table.insert(blips_list, blip)
		else
			if PlayerData.job then
				if v.job ~= nil and v.job == PlayerData.job.name then
					blip = CreateBlip(v.pos, v.Blip.sprite, v.Blip.scale, v.Blip.color, v.Blip.name)
					table.insert(blips_list, blip)
				end
			end
		end
	end
end


function CreateBlip(pos, sprite, scale, color, label)
	local blip = AddBlipForCoord(pos)
	SetBlipSprite(blip, sprite)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, scale)
	SetBlipColour(blip, color)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName('STRING')	
	AddTextComponentSubstringPlayerName(label)
	EndTextCommandSetBlipName(blip)
	return blip
end

function OpenFineMenu(player)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine', {
		title    = _U('fine'),
		align    = 'top-right',
		elements = {
			{label = _U('traffic_offense'), value = 0},
			{label = _U('minor_offense'),   value = 1},
			{label = _U('average_offense'), value = 2},
			{label = _U('major_offense'),   value = 3}
	}}, function(data, menu)
		OpenFineCategoryMenu(player, data.current.value)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenFineCategoryMenu(player, category)
	ESX.TriggerServerCallback('esx_jobs:getFineList', function(fines)
		local elements = {}

		for k,fine in ipairs(fines) do
			table.insert(elements, {
				label     = ('%s <span style="color:green;">%s</span>'):format(fine.label, _U('armory_item', ESX.Math.GroupDigits(fine.amount))),
				value     = fine.id,
				amount    = fine.amount,
				fineLabel = fine.label
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine_category', {
			title    = _U('fine'),
			align    = 'top-right',
			elements = elements
		}, function(data, menu)
			menu.close()

			if Config.EnablePlayerManagement then
				TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_police', _U('fine_total', data.current.fineLabel), data.current.amount)
			else
				TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), '', _U('fine_total', data.current.fineLabel), data.current.amount)
			end

			ESX.SetTimeout(300, function()
				OpenFineCategoryMenu(player, category)
			end)
		end, function(data, menu)
			menu.close()
		end)
	end, category)
end


function LookupVehicle()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'lookup_vehicle', {
		title = _U('search_database_title'),
	}, function(data, menu)
		local length = string.len(data.value)
		if not data.value or length < 2 or length > 8 then
			ESX.ShowNotification(_U('search_database_error_invalid'))
		else
			ESX.TriggerServerCallback('esx_jobs:getVehicleInfos', function(retrivedInfo)
				local elements = {{label = _U('plate', retrivedInfo.plate)}}
				menu.close()

				if not retrivedInfo.owner then
					table.insert(elements, {label = _U('owner_unknown')})
				else
					table.insert(elements, {label = _U('owner', retrivedInfo.owner)})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos', {
					title    = _U('vehicle_info'),
					align    = 'top-right',
					elements = elements
				}, nil, function(data2, menu2)
					menu2.close()
				end)
			end, data.value)

		end
	end, function(data, menu)
		menu.close()
	end)
end

function ShowPlayerLicense(player)
	local elements = {}

	ESX.TriggerServerCallback('esx_jobs:getOtherPlayerData', function(playerData)
		if playerData.licenses then
			for i=1, #playerData.licenses, 1 do
				if playerData.licenses[i].label and playerData.licenses[i].type then
					table.insert(elements, {
						label = playerData.licenses[i].label,
						type = playerData.licenses[i].type
					})
				end
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_license', {
			title    = _U('license_revoke'),
			align    = 'top-right',
			elements = elements,
		}, function(data, menu)
			ESX.ShowNotification(_U('licence_you_revoked', data.current.label, playerData.name))
			TriggerServerEvent('esx_jobs:message', GetPlayerServerId(player), _U('license_revoked', data.current.label))

			TriggerServerEvent('esx_license:removeLicense', GetPlayerServerId(player), data.current.type)

			ESX.SetTimeout(300, function()
				ShowPlayerLicense(player)
			end)
		end, function(data, menu)
			menu.close()
		end)

	end, GetPlayerServerId(player))
end

function OpenUnpaidBillsMenu(player)
	local elements = {}

	ESX.TriggerServerCallback('esx_billing:getTargetBills', function(bills)
		for k,bill in ipairs(bills) do
			table.insert(elements, {
				label = ('%s - <span style="color:red;">%s</span>'):format(bill.label, _U('armory_item', ESX.Math.GroupDigits(bill.amount))),
				billId = bill.id
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'billing', {
			title    = _U('unpaid_bills'),
			align    = 'top-right',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

function OpenVehicleInfosMenu(vehicleData)
	ESX.TriggerServerCallback('esx_jobs:getVehicleInfos', function(retrivedInfo)
		local elements = {{label = _U('plate', retrivedInfo.plate)}}

		if not retrivedInfo.owner then
			table.insert(elements, {label = _U('owner_unknown')})
		else
			table.insert(elements, {label = _U('owner', retrivedInfo.owner)})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos', {
			title    = _U('vehicle_info'),
			align    = 'top-right',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end, vehicleData.plate)
end

function ImpoundVehicle(vehicle)
	local plate = GetVehicleNumberPlateText(vehicle)
	ESX.TriggerServerCallback('esx_jobs:impound', function(isimpounded)
		if isimpounded then
			ESX.Game.DeleteVehicle(vehicle)
			ESX.ShowNotification(_U('impound_successful'))
			currentTask.busy = false
		else
			ESX.ShowNotification(_U('impound_decined'))
			currentTask.busy = false
		end
	end, plate)
end


function OpenIdentityCardMenu(player)
	ESX.TriggerServerCallback('esx_jobs:getOtherPlayerData', function(data)
		local elements = {
			{label = _U('name', data.name)},
			{label = _U('job', ('%s - %s'):format(data.job, data.grade))}
		}

		if data.sex ~= nil then
			table.insert(elements, {label = _U('sex', _U(data.sex))})
		end

		if data.job ~= nil then
			table.insert(elements, {label = _U('job', data.job)})
		end
		if data.height ~= nil then
			table.insert(elements, {label = _U('height', data.height)})
		end
		if data.drunk ~= nil then
			table.insert(elements, {label = _U('bac', data.drunk)})
		end

		table.insert(elements, {label = _U('license_label')})


		for i=1, #data.licenses, 1 do
			table.insert(elements, {label = data.licenses[i].label})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
			title    = _U('citizen_interaction'),
			align    = 'top-right',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

function OpenBodySearchMenu(player)
	ESX.TriggerServerCallback('esx_jobs:getOtherPlayerData', function(data)
		local elements = {}

		for i=1, #data.accounts, 1 do
			if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
				table.insert(elements, {
					label    = _U('confiscate_dirty', ESX.Math.Round(data.accounts[i].money)),
					value    = 'black_money',
					itemType = 'item_account',
					amount   = data.accounts[i].money
				})
				break
			end
		end

		table.insert(elements, {label = _U('guns_label')})

		for i=1, #data.weapons, 1 do
			table.insert(elements, {
				label    = _U('confiscate_weapon', ESX.GetWeaponLabel(data.weapons[i].name), data.weapons[i].ammo),
				value    = data.weapons[i].name,
				itemType = 'item_weapon',
				amount   = data.weapons[i].ammo
			})
		end

		table.insert(elements, {label = _U('inventory_label')})

		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(elements, {
					label    = _U('confiscate_inv', data.inventory[i].count, data.inventory[i].label),
					value    = data.inventory[i].name,
					itemType = 'item_standard',
					amount   = data.inventory[i].count
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
			title    = _U('search'),
			align    = 'top-right',
			elements = elements
		}, function(data, menu)
			if data.current.value then

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'body_search_dialog', {
					title = _U('quantity')
				}, function(data2, menu2)
					local count = tonumber(data2.value)

					if count == nil then
						ESX.ShowNotification(_U('quantity_invalid'))
					else
						TriggerServerEvent('esx_jobs:confiscatePlayerItem', GetPlayerServerId(player), data.current.itemType, data.current.value, count)
						OpenBodySearchMenu(player)
						menu2.close()
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end