local _menuPool                 = NativeUI.CreatePool()
local JobUI                  = nil
local PlayerData = {}
local blips_list = {}
local HasAlreadyEnteredMarker = false
local CurrentAction
local CurrentActionMsg
local CurrentActionData = {}
local isHandcuffed = false
local dragStatus = {}
local npc_list = {}
currentTask = {}
isDead = false

CreateThread(function()
	while PlayerData.job == nil do
		PlayerData = ESX.GetPlayerData()
		Wait(1)
	end

	while true do
        Wait(100)
        if npc_list then
            for i, ped in ipairs(npc_list) do
		        TaskSetBlockingOfNonTemporaryEvents(ped, true)
            end
        end
	end
end)

AddEventHandler('onResourceStart', function (resourceName)
	PlayerData = ESX.GetPlayerData()
	LoadDefaults()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	LoadDefaults()
end)

function LoadDefaults()
	SetBlips()
	SpawnNpc()
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData = ESX.GetPlayerData()
	SetBlips()
end)

CreateThread(function()
    while true do
        if _menuPool:IsAnyMenuOpen() then 
            _menuPool:ProcessMenus()
        else
            _menuPool:CloseAllMenus()
        end
        Wait(1)
    end
end)

CreateThread(function()
	while true do
		Wait(3)
		if PlayerData.job and not isDead then
			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)

			local isInMarker = false 
			local hasExited = false
			local currentPart
			local LastPart
			local menu_config

			if jobs[PlayerData.job.name] then
				v = jobs[PlayerData.job.name]
				for k, v in ipairs(v.armory) do
					local distance = GetDistanceBetweenCoords(coords, v.coords, true)
					if not v.npc then
						if distance < Config.DrawDistance then
							DrawMarker(21, v.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
						end
					end
					if distance < Config.MarkerSize.x then
						isInMarker = true
						currentPart = 'Armory'
						menu_config = v
					end
				end

				for k, v in ipairs(v.boss) do
					if v.min_grade <= PlayerData.job.grade then
						local distance = GetDistanceBetweenCoords(coords, v.coords, true)
						if not v.npc then
							if distance < Config.DrawDistance then
								DrawMarker(22, v.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
							end
						end
						if distance < Config.MarkerSize.x then
							isInMarker = true
							currentPart = 'Boss'
							menu_config = v
						end
					end
				end

				for k, v in ipairs(v.cloak) do
				local distance = GetDistanceBetweenCoords(coords, v.coords, true)
					if not v.npc then
						if distance < Config.DrawDistance then
							DrawMarker(22, v.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
						end
					end
					if distance < Config.MarkerSize.x then
						isInMarker = true
						currentPart = 'Cloack'
						menu_config = v
					end
				end
			end
	
			if isInMarker and not HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = true
				LastPart = currentPart
				TriggerEvent('esx_jobs:hasEnteredMarker', currentPart, v.job, menu_config)
			end
			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_jobs:hasExitedMarker', LastPart, v.job, menu_config)
			end
		end
	end
end)

AddEventHandler('esx_jobs:hasEnteredMarker', function(currentPart, station, menu_config)
	if currentPart == 'Armory' then
		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station, menu_config = menu_config}
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
	_menuPool:CloseAllMenus()

	CurrentAction = nil
end)

-- Key Controls
CreateThread(function()
	while true do
		Wait(1)

		if CurrentAction and not isDead then
			ESX.ShowHelpNotification(CurrentActionMsg)
			if IsControlJustReleased(0, 38) then
				if PlayerData.job then
					if jobs[PlayerData.job.name] then
						v = jobs[PlayerData.job.name]
						if CurrentAction == 'menu_armory' then
							OpenJobArmoryMenu()
						elseif CurrentAction == 'menu_boss_actions' then
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

		if IsControlJustReleased(0, 167) then
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

	CreateThread(function()
		local playerPed = PlayerPedId()
		if isHandcuffed then
			RequestAnimDict('mp_arresting')

			while not HasAnimDictLoaded('mp_arresting') do
				Wait(100)
			end

			TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
			SetEnableHandcuffs(playerPed, true)
			DisablePlayerFiring(playerPed, true)
			SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
			SetPedCanPlayGestureAnims(playerPed, false)
			FreezeEntityPosition(playerPed, true)
		else
			ClearPedSecondaryTask(playerPed)
			SetEnableHandcuffs(playerPed, false)
			DisablePlayerFiring(playerPed, false)
			SetPedCanPlayGestureAnims(playerPed, true)
			FreezeEntityPosition(playerPed, false)
		end
	end)
end)

RegisterNetEvent('esx_jobs:drag')
AddEventHandler('esx_jobs:drag', function(SourceID)
	dragStatus.isDragged = not dragStatus.isDragged
	dragStatus.SourceID = SourceID
end)

CreateThread(function()
	local playerPed = PlayerPedId()
	local targetPed

	while true do
		Wait(1)
		if dragStatus.isDragged then
			targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.SourceID))

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
	end
end)

RegisterNetEvent('esx_jobs:putInVehicle')
AddEventHandler('esx_jobs:putInVehicle', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

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
CreateThread(function()
	while true do
		Wait(0)
		local playerPed = PlayerPedId()
		if isHandcuffed then

			if isDead then
				isHandcuffed = false
				ClearPedSecondaryTask(playerPed)
				SetEnableHandcuffs(playerPed, false)
				DisablePlayerFiring(playerPed, false)
				SetPedCanPlayGestureAnims(playerPed, true)
				FreezeEntityPosition(playerPed, false)
			else
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
			end
		else
			Wait(500)
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

	if isHandcuffed then
		ClearPedSecondaryTask(playerPed)
		Wait(200)
		TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
	end
end)

function OpenJobActionsMenu(JobConfig)
	local playerPed = PlayerPedId()
    _menuPool:CloseAllMenus()
	if JobUI ~= nil and JobUI:Visible() then
		JobUI:Visible(false)
	end

	JobUI = NativeUI.CreateMenu("Job Menü", nil, nil)
	_menuPool:Add(JobUI)

	if not rawequal(next(JobConfig.citizen_interaction_items), nil) then
		citizen_interaction_menu = _menuPool:AddSubMenu(JobUI, _U('citizen_interaction'))
        for k, v in pairs(JobConfig.citizen_interaction_items) do
			Item = NativeUI.CreateItem(_U(v.label), "")
			citizen_interaction_menu.SubMenu:AddItem(Item)

			Item.Activated = function(sender, index)
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
					if v.label == 'identity_card' then
						TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(closestPlayer), GetPlayerServerId(PlayerId()))
					elseif v.label == 'body_search' then
						ESX.TriggerServerCallback('esx_jobs:getOtherPlayerData', function(data)
							if data then
								OpenBodySearchMenu(closestPlayer, data)
							else
								TriggerEvent('dopeNotify:Alert', "", _U('player_not_found'), 5000, 'error')
							end
						end, GetPlayerServerId(closestPlayer))
					elseif v.label == 'handcuff' then
						TriggerServerEvent('esx_jobs:handcuff', GetPlayerServerId(closestPlayer))
					elseif v.label == 'drag' then
						TriggerServerEvent('esx_jobs:drag', GetPlayerServerId(closestPlayer))
					elseif v.label == 'put_in_vehicle' then
						TriggerServerEvent('esx_jobs:putInVehicle', GetPlayerServerId(closestPlayer))
					elseif v.label == 'out_the_vehicle' then
						TriggerServerEvent('esx_jobs:OutVehicle', GetPlayerServerId(closestPlayer))
					elseif v.label == 'license' then
						ESX.TriggerServerCallback('esx_jobs:getOtherPlayerData', function(playerData)
							if playerData then
								if not rawequal(next(playerData.licenses), nil) then
									ShowPlayerLicense(closestPlayer, playerData.licenses)
								else
									TriggerEvent('dopeNotify:Alert', "", _U('no_licenses_owned'), 5000, 'info')
								end
							else
								TriggerEvent('dopeNotify:Alert', "", _U('player_not_found'), 5000, 'error')
							end
						end, GetPlayerServerId(closestPlayer))
					elseif v.label == 'unpaid_bills' then
						ESX.TriggerServerCallback('esx_billing:getTargetBills', function(bills)
							if not rawequal(next(bills), nil) then
								OpenUnpaidBillsMenu(closestPlayer, bills)
							else
								TriggerEvent('dopeNotify:Alert', "", _U('no_bills'), 5000, 'info')
							end
						end, GetPlayerServerId(closestPlayer))
					elseif v.label == 'ems_menu_revive' then
						RevivePlayer(closestPlayer)
					elseif v.label == 'ems_menu_small' then
						HealPlayer(closestPlayer, "bandage")
					elseif v.label == 'ems_menu_big' then
						HealPlayer(closestPlayer, "medikit")
					elseif v.label == 'billing' then
						local input = KeyboardInput("Rechnungs betrag", "", 20)
						local amount = tonumber(input)
						if tostring(amount) then
							if amount == nil or amount < 0 then
								TriggerEvent('dopeNotify:Alert', "", _U('quantity_invalid'), 5000, 'error')
								return
							end
							TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_'..PlayerData.job.name , PlayerData.job.label, amount)
						end
					end
				else
					TriggerEvent('dopeNotify:Alert', "", _U('no_players_nearby'), 5000, 'error')
				end
			end
        end
	end

	if not rawequal(next(JobConfig.vehicle_interaction_items), nil) then
		vehicle_interaction_menu = _menuPool:AddSubMenu(JobUI, _U('vehicle_interaction'))
		for k, v in pairs(JobConfig.vehicle_interaction_items) do
			Item = NativeUI.CreateItem(_U(v.label), "")
			vehicle_interaction_menu.SubMenu:AddItem(Item)

			Item.Activated = function(sender, index)
				local coords  = GetEntityCoords(playerPed)
				vehicle = ESX.Game.GetVehicleInDirection()

				if currentTask.busy then
					return
				end

				if v.label == 'search_database' then
					local plate = KeyboardInput(_U('search_database_title'), "", 7)
					if tostring(plate) then
						if plate then
							ESX.TriggerServerCallback('esx_jobs:getVehicleInfos', function(retrivedInfo)
								if retrivedInfo then
									LookupVehicle(retrivedInfo)
								else
									TriggerEvent('dopeNotify:Alert', "", _U('search_database_error_invalid'), 5000, 'error')
								end
							end, plate)
						else
							TriggerEvent('dopeNotify:Alert', "", _U('quantity_invalid'), 5000, 'error')
						end
					else
						TriggerEvent('dopeNotify:Alert', "", _U('quantity_invalid'), 5000, 'error')
					end
				elseif DoesEntityExist(vehicle) then
					if v.label == 'vehicle_infos' then
						ESX.TriggerServerCallback('esx_jobs:getVehicleInfos', function(retrivedInfo)
							if retrivedInfo then
								LookupVehicle(retrivedInfo)
							else
								TriggerEvent('dopeNotify:Alert', "", _U('search_database_error_invalid'), 5000, 'error')
							end
						end, ESX.Game.GetVehicleProperties(vehicle).plate)
					elseif v.label == 'hijack_vehicle' then
						if IsPedSittingInAnyVehicle(playerPed) then
							TriggerEvent('dopeNotify:Alert', "", _U('inside_vehicle'), 5000, 'error')
							return
						end

						if GetVehicleDoorLockStatus(vehicle) == 2 then
							currentTask.busy = true
							if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
								TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
								Wait(20000)
								ClearPedTasksImmediately(playerPed)
								SetVehicleDoorsLocked(vehicle, 1)
								SetVehicleDoorsLockedForAllPlayers(vehicle, false)
								TriggerEvent('dopeNotify:Alert', "", _U('vehicle_unlocked'), 5000, 'info')
								currentTask.busy = false
							end
						else
							TriggerEvent('dopeNotify:Alert', "", _U('vehicle_is_already_open'), 5000, 'error')
						end
					elseif v.label == 'fix_vehicle' then
						if IsPedSittingInAnyVehicle(playerPed) then
							TriggerEvent('dopeNotify:Alert', "", _U('inside_vehicle'), 5000, 'error')
							return
						end

						currentTask.busy = true
						TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
						CreateThread(function()
							Wait(20000)
							SetVehicleFixed(vehicle)
							SetVehicleDeformationFixed(vehicle)
							SetVehicleUndriveable(vehicle, false)
							SetVehicleEngineOn(vehicle, true, true)
							ClearPedTasksImmediately(playerPed)
							TriggerEvent('dopeNotify:Alert', "", _U('vehicle_repaired'), 5000, 'succes')
							currentTask.busy = false
						end)

					elseif v.label == 'clean_vehicle' then
						if IsPedSittingInAnyVehicle(playerPed) then
							TriggerEvent('dopeNotify:Alert', "", _U('inside_vehicle'), 5000, 'error')
							return
						end

						currentTask.busy = true
						TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
						CreateThread(function()
							Wait(10000)
							SetVehicleDirtLevel(vehicle, 0)
							ClearPedTasksImmediately(playerPed)
							TriggerEvent('dopeNotify:Alert', "", _U('vehicle_cleaned'), 5000, 'succes')
							currentTask.busy = false
						end)
					end
				else
					TriggerEvent('dopeNotify:Alert', "", _U('no_vehicles_nearby'), 5000, 'error')
				end
			end
		end
	end

    JobUI:Visible(true)
	_menuPool:RefreshIndex()
	_menuPool:MouseControlsEnabled(false)
	_menuPool:MouseEdgeEnabled(false)
	_menuPool:ControlDisablingEnabled(false)
end

function OpenCloakroomMenu(job)
	_menuPool:CloseAllMenus()
	local grade = ESX.PlayerData.job.grade_name

	if JobUI ~= nil and JobUI:Visible() then
		JobUI:Visible(false)
	end

	JobUI = NativeUI.CreateMenu(_U('cloakroom'), nil, nil)
	_menuPool:Add(JobUI)


	local citizen_wear = NativeUI.CreateItem(_U('citizen_wear'), "")
	JobUI:AddItem(citizen_wear)

	local job_wear1 = NativeUI.CreateItem(_U('job_wear1'), "")
	JobUI:AddItem(job_wear1)

	local job_wear2 = NativeUI.CreateItem(_U('job_wear2'), "")
	JobUI:AddItem(job_wear2)

	local job_wear3 = NativeUI.CreateItem(_U('job_wear3'), "")
	JobUI:AddItem(job_wear3)


	JobUI.OnItemSelect = function(sender, item, index)
		if item == citizen_wear then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
        elseif item == job_wear1 then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				ESX.TriggerServerCallback('esx_jobs:getjobskin', function(jobskin)
					TriggerEvent('skinchanger:loadClothes', skin, json.decode(jobskin))
				end, skin.sex, 1)
			end)
        elseif item == job_wear2 then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				ESX.TriggerServerCallback('esx_jobs:getjobskin', function(jobskin)
					TriggerEvent('skinchanger:loadClothes', skin, json.decode(jobskin))
				end, skin.sex, 2)
			end)
        elseif item == job_wear3 then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				ESX.TriggerServerCallback('esx_jobs:getjobskin', function(jobskin)
					TriggerEvent('skinchanger:loadClothes', skin, json.decode(jobskin))
				end, skin.sex, 3)
			end)
		end
	end

    JobUI:Visible(true)
	_menuPool:RefreshIndex()
	_menuPool:MouseControlsEnabled(false)
	_menuPool:MouseEdgeEnabled(false)
	_menuPool:ControlDisablingEnabled(false)
end


function cleanPlayer(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end


function OpenJobArmoryMenu()
	_menuPool:CloseAllMenus()
	if JobUI ~= nil and JobUI:Visible() then
		JobUI:Visible(false)
	end

    JobUI = NativeUI.CreateMenu(_U('armory'), nil, nil)
    _menuPool:Add(JobUI)


	local get_weapon, put_weapon, remove_object, deposit_object

	if CurrentActionData.menu_config.store_weapon then
		get_weapon = _menuPool:AddSubMenu(JobUI, _U('get_weapon'))
		put_weapon = _menuPool:AddSubMenu(JobUI, _U('put_weapon'))
	end

	if CurrentActionData.menu_config.store_items then
		remove_object = _menuPool:AddSubMenu(JobUI, _U('remove_object'))
		deposit_object = _menuPool:AddSubMenu(JobUI, _U('deposit_object'))
	end


	JobUI.OnMenuChanged = function(menu, newmenu, forward)
		if newmenu == get_weapon.SubMenu then
			ESX.TriggerServerCallback('esx_jobs:getArmoryWeapons', function(weapons)
				for k, v in pairs(weapons) do
					if v.count > 0 then
						local weapon_item = NativeUI.CreateItem('x' ..v.count .. ' ' .. ESX.GetWeaponLabel(v.name), "")
						get_weapon.SubMenu:AddItem(weapon_item)
						_menuPool:RefreshIndex()
		
						weapon_item.Activated = function(sender, index)
							ESX.TriggerServerCallback('esx_jobs:removeArmoryWeapon', function()
								_menuPool:CloseAllMenus()
								OpenJobArmoryMenu()
							end, v.name, CurrentActionData.station)
						end
					end
				end
			end, CurrentActionData.station)

		elseif newmenu == put_weapon.SubMenu then
			local weaponList = ESX.GetWeaponList()
			for k, v in pairs(weaponList) do
				local weaponHash = GetHashKey(v.name)
				if HasPedGotWeapon(playerPed, weaponHash, false) and v.name ~= 'WEAPON_UNARMED' then

					local inventory_weapon_item = NativeUI.CreateItem(v.label, "")
					put_weapon.SubMenu:AddItem(inventory_weapon_item)
					
					inventory_weapon_item.Activated = function(sender, index)
						ESX.TriggerServerCallback('esx_jobs:addArmoryWeapon', function()
							_menuPool:CloseAllMenus()
							OpenJobArmoryMenu()
						end, v.name, true, CurrentActionData.station)
					end
				end
			end
		elseif newmenu == remove_object.SubMenu then
			ESX.TriggerServerCallback('esx_jobs:getStockItems', function(items)
				for k, v in pairs(items) do
					if v.count > 0 then
						local job_inventory_item = NativeUI.CreateItem('x' .. v.count .. ' ' .. v.label, "")
						remove_object.SubMenu:AddItem(job_inventory_item)
						_menuPool:RefreshIndex()
						job_inventory_item.Activated = function(sender, index)
							local input = KeyboardInput("Anzahl", "", 20)
							local amount = tonumber(input)
							if tostring(amount) then
			
								if amount == nil or amount < 0 then
									TriggerEvent('dopeNotify:Alert', "", _U('quantity_invalid'), 5000, 'error')
								else
									TriggerServerEvent('esx_jobs:getStockItem', v.name, amount, CurrentActionData.station)
									_menuPool:CloseAllMenus()
									OpenJobArmoryMenu()
								end
							else
								TriggerEvent('dopeNotify:Alert', "", _U('quantity_invalid'), 5000, 'error')
							end
						end
					end
				end
			end, CurrentActionData.station)
		elseif newmenu == deposit_object.SubMenu then
			ESX.TriggerServerCallback('esx_jobs:getPlayerInventory', function(inventory)
				for k, v in pairs(inventory.items) do
					if v.count > 0 then
						local remove_inventory_item = NativeUI.CreateItem(v.label .. ' x' .. v.count, "")
						deposit_object.SubMenu:AddItem(remove_inventory_item)
						_menuPool:RefreshIndex()
						remove_inventory_item.Activated = function(sender, index)
							local input = KeyboardInput("Anzahl", "", 20)
							local amount = tonumber(input)
							if tostring(amount) then
			
								if amount == nil or amount < 0 then
									TriggerEvent('dopeNotify:Alert', "", _U('quantity_invalid'), 5000, 'error')
								else
									TriggerServerEvent('esx_jobs:putStockItems', v.name, amount, CurrentActionData.station)
									_menuPool:CloseAllMenus()
									OpenJobArmoryMenu()
								end
							else
								TriggerEvent('dopeNotify:Alert', "", _U('quantity_invalid'), 5000, 'error')
							end
						end
					end
				end
			end)
		end
	end

    JobUI:Visible(true)
	_menuPool:RefreshIndex()
	_menuPool:MouseControlsEnabled(false)
	_menuPool:MouseEdgeEnabled(false)
	_menuPool:ControlDisablingEnabled(false)
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

function LookupVehicle(info)
    _menuPool:CloseAllMenus()
	if JobUI ~= nil and JobUI:Visible() then
		JobUI:Visible(false)
	end

	JobUI = NativeUI.CreateMenu(_U('vehicle_infos'), nil, nil)
	_menuPool:Add(JobUI)

	local Owner = NativeUI.CreateItem("Besitzer: ".. info.owner, "")
	JobUI:AddItem(Owner)
	
	local Plate = NativeUI.CreateItem("Kennzeichen: ".. info.plate, "")
	JobUI:AddItem(Plate)



	JobUI.OnMenuClosed = function(menu)
		if jobs[PlayerData.job.name] then
			v = jobs[PlayerData.job.name]
			OpenJobActionsMenu(v)
		end
	end

    JobUI:Visible(true)
	_menuPool:RefreshIndex()
	_menuPool:MouseControlsEnabled(false)
	_menuPool:MouseEdgeEnabled(false)
	_menuPool:ControlDisablingEnabled(false)	
end

function ShowPlayerLicense(player, data)
    _menuPool:CloseAllMenus()
	if JobUI ~= nil and JobUI:Visible() then
		JobUI:Visible(false)
	end

    local JobUI = NativeUI.CreateMenu(_U('license_label'), nil, nil)
    _menuPool:Add(JobUI)

	for k, v in ipairs(data) do
		licence = _menuPool:AddSubMenu(JobUI, v.label)

		local revoke = NativeUI.CreateItem(_U('license_revoke'), "")
		local abort = NativeUI.CreateItem(_U('abort'), "")

		licence.SubMenu:AddItem(revoke)
		licence.SubMenu:AddItem(abort)

		revoke.Activated = function(sender, index)
			TriggerServerEvent('esx_license:removeLicense', GetPlayerServerId(player), v.type)
			_menuPool:CloseAllMenus()
			Wait(100)

			ESX.TriggerServerCallback('esx_jobs:getOtherPlayerData', function(playerData)
				if playerData then
					if not rawequal(next(playerData.licenses), nil) then
						ShowPlayerLicense(player, playerData.licenses)
					else
						if jobs[PlayerData.job.name] then
							v = jobs[PlayerData.job.name]
							OpenJobActionsMenu(v)
						end
					end
				else
					if jobs[PlayerData.job.name] then
						v = jobs[PlayerData.job.name]
						OpenJobActionsMenu(v)
					end
				end
			end, GetPlayerServerId(player))
		end

		abort.Activated = function(sender, index)
			ESX.TriggerServerCallback('esx_jobs:getOtherPlayerData', function(playerData)
				if playerData then
					if not rawequal(next(playerData.licenses), nil) then
						ShowPlayerLicense(player, playerData.licenses)
					else
						if jobs[PlayerData.job.name] then
							v = jobs[PlayerData.job.name]
							OpenJobActionsMenu(v)
						end
					end
				else
					if jobs[PlayerData.job.name] then
						v = jobs[PlayerData.job.name]
						OpenJobActionsMenu(v)
					end
				end
			end, GetPlayerServerId(player))
		end
	end

    JobUI:Visible(true)
	_menuPool:RefreshIndex()
	_menuPool:MouseControlsEnabled(false)
	_menuPool:MouseEdgeEnabled(false)
	_menuPool:ControlDisablingEnabled(false)
end

function OpenUnpaidBillsMenu(player, bills)
    _menuPool:CloseAllMenus()
	if JobUI ~= nil and JobUI:Visible() then
		JobUI:Visible(false)
	end

    JobUI = NativeUI.CreateMenu("Garage", nil, nil)
    _menuPool:Add(JobUI)

	for k, v in ipairs(bills) do
		local Item = NativeUI.CreateItem(v.label..' - ~r~$'..ESX.Math.GroupDigits(v.amount)..'~s~', "")
		JobUI:AddItem(Item)
	end

    JobUI:Visible(true)
	_menuPool:RefreshIndex()
	_menuPool:MouseControlsEnabled(false)
	_menuPool:MouseEdgeEnabled(false)
	_menuPool:ControlDisablingEnabled(false)
end

function OpenBodySearchMenu(player, data)
    _menuPool:CloseAllMenus()
	if JobUI ~= nil and JobUI:Visible() then
		JobUI:Visible(false)
	end

	JobUI = NativeUI.CreateMenu(PlayerData.job.label.. "-Garage", nil, nil)
	_menuPool:Add(JobUI)

	local weaponlabel, standartlabel, accountlabel

	for k, v in ipairs(data.accounts) do
		if not accountlabel then
			Item = NativeUI.CreateItem(_U('account_label'), "")
			accountlabel = true
			JobUI:AddItem(Item)
		end

		if v.name == 'black_money' and v.money > 0 then
			Item = NativeUI.CreateItem(_U('confiscate_dirty', ESX.Math.Round(data.accounts[i].money)), "")
			JobUI:AddItem(Item)

			Item.Activated = function(sender, index)
				Confiscate(player, v.name, 'item_account', v.money)
			end
		end
	end

	for k, v in ipairs(data.weapons) do
		if not weaponlabel then
			Item = NativeUI.CreateItem(_U('guns_label'), "")
			weaponlabel = true
			JobUI:AddItem(Item)
		end
		Item = NativeUI.CreateItem(_U('confiscate_weapon', ESX.GetWeaponLabel(v.name), v.ammo), "")
		JobUI:AddItem(Item)

		Item.Activated = function(sender, index)
			Confiscate(player, v.name, 'item_weapon', v.ammo)
		end
	end

	for k, v in ipairs(data.inventory) do
		if v.count > 0 then
			if not standartlabel then
				Item = NativeUI.CreateItem(_U('inventory_label'), "")
				standartlabel = true
				JobUI:AddItem(Item)
			end

			Item = NativeUI.CreateItem(_U('confiscate_inv', v.count, v.label), "")
			JobUI:AddItem(Item)

			Item.Activated = function(sender, index)
				Confiscate(player, v.name, 'item_standard', v.count)
			end
		end
	end

    JobUI:Visible(true)
	_menuPool:RefreshIndex()
	_menuPool:MouseControlsEnabled(false)
	_menuPool:MouseEdgeEnabled(false)
	_menuPool:ControlDisablingEnabled(false)
end

function Confiscate(player, name, itemtype, count)
	if itemtype == 'item_standard' then
		local input = KeyboardInput("Anzahl", "", 20)
		local amount = tonumber(input)
		if tostring(amount) then
			if amount and amount >= 0 and count >= amount then
				TriggerServerEvent('esx_jobs:confiscatePlayerItem', GetPlayerServerId(player), itemtype, name, amount)
				ESX.TriggerServerCallback('esx_jobs:getOtherPlayerData', function(data)
					if data then
						OpenBodySearchMenu(player, data)
					else
						if jobs[PlayerData.job.name] then
							v = jobs[PlayerData.job.name]
							OpenJobActionsMenu(v)
						end
					end
				end, GetPlayerServerId(player))
			else
				TriggerEvent('dopeNotify:Alert', "", _U('quantity_invalid'), 5000, 'error')
			end
		else
			TriggerEvent('dopeNotify:Alert', "", _U('quantity_invalid'), 5000, 'error')
		end
	else
		TriggerServerEvent('esx_jobs:confiscatePlayerItem', GetPlayerServerId(player), itemtype, name, count)
		ESX.TriggerServerCallback('esx_jobs:getOtherPlayerData', function(data)
			if data then
				OpenBodySearchMenu(player, data)
			else
				if jobs[PlayerData.job.name] then
					v = jobs[PlayerData.job.name]
					OpenJobActionsMenu(v)
				end
			end
		end, GetPlayerServerId(player))
	end
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
	AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Wait(0)
	end
		
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Wait(500)
		blockinput = false 
		return result 
	else
		Wait(500) 
		blockinput = false
		return nil
	end
end

function SpawnNpc()
    for k, y in pairs(jobs) do
		for k, v in ipairs(y.armory) do
			if v.npc then
				RequestModel(v.npc.ped)
				LoadPropDict(v.npc.ped)
				local ped = CreatePed(5, v.npc.ped , v.coords.x, v.coords.y, v.coords.z - 1.0, v.npc.heading, false, true)
				PlaceObjectOnGroundProperly(ped)
				SetEntityAsMissionEntity(ped)
				SetPedDropsWeaponsWhenDead(ped, false)
				FreezeEntityPosition(ped, true)
				SetPedAsEnemy(ped, false)
				SetEntityInvincible(ped, true)
				SetModelAsNoLongerNeeded(v.npc.ped)
				SetPedCanBeTargetted(ped, false)
				table.insert(npc_list, ped)
			end
		end
		for k, v in ipairs(y.boss) do
			if v.npc then
				RequestModel(v.npc.ped)
				LoadPropDict(v.npc.ped)
				local ped = CreatePed(5, v.npc.ped , v.coords.x, v.coords.y, v.coords.z - 1.0, v.npc.heading, false, true)
				PlaceObjectOnGroundProperly(ped)
				SetEntityAsMissionEntity(ped)
				SetPedDropsWeaponsWhenDead(ped, false)
				FreezeEntityPosition(ped, true)
				SetPedAsEnemy(ped, false)
				SetEntityInvincible(ped, true)
				SetModelAsNoLongerNeeded(v.npc.ped)
				SetPedCanBeTargetted(ped, false)
				table.insert(npc_list, ped)
			end
		end
		for k, v in ipairs(y.cloak) do
			if v.npc then
				RequestModel(v.npc.ped)
				LoadPropDict(v.npc.ped)
				local ped = CreatePed(5, v.npc.ped , v.coords.x, v.coords.y, v.coords.z - 1.0, v.npc.heading, false, true)
				PlaceObjectOnGroundProperly(ped)
				SetEntityAsMissionEntity(ped)
				SetPedDropsWeaponsWhenDead(ped, false)
				FreezeEntityPosition(ped, true)
				SetPedAsEnemy(ped, false)
				SetEntityInvincible(ped, true)
				SetModelAsNoLongerNeeded(v.npc.ped)
				SetPedCanBeTargetted(ped, false)
				table.insert(npc_list, ped)
			end
		end
	end
end

function LoadPropDict(model)
	while not HasModelLoaded(GetHashKey(model)) do
	  RequestModel(GetHashKey(model))
	  Wait(10)
	end
end

AddEventHandler("onResourceStop",function(resourceName)
    if resourceName == GetCurrentResourceName() then
        if npc_list then
            for i, ped in ipairs(npc_list) do
	            DeletePed(ped)
            end
            npc_list = {}
        end
    end
end)

AddEventHandler('esx:onPlayerDeath', function(data) isDead = true end)
AddEventHandler('esx:onPlayerSpawn', function(spawn) isDead = false end)
