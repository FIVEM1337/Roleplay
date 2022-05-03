local _menuPool                 = NativeUI.CreatePool()
local JobUI                  = nil
local BossUI = nil
local PlayerData = {}
local blips_list = {}
local HasAlreadyEnteredMarker = false
local CurrentAction
local CurrentActionMsg
local CurrentActionData = {}
local npc_list = {}
local RestirctedZones = {}

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
	GetRestirctedZones()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	LoadDefaults()
	GetRestirctedZones()
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
							OpenJobBossMenu(v)
						elseif CurrentAction == 'menu_cloackroom' then
							OpenCloakroomMenu(PlayerData.job.name)
						end
					end
				end
			end
		end
	end
end)


RegisterCommand('openjobmenu', function()
	if PlayerData.job then
		if jobs[PlayerData.job.name] then
			v = jobs[PlayerData.job.name]
			OpenJobActionsMenu(jobs[PlayerData.job.name])
		end
	end
end)

RegisterKeyMapping('openjobmenu', "Job Menü öffnen", 'keyboard', 'F6')

function OpenJobActionsMenu(JobConfig)
	local playerPed = PlayerPedId()
    _menuPool:CloseAllMenus()
	if JobUI ~= nil and JobUI:Visible() then
		JobUI:Visible(false)
	end

	JobUI = NativeUI.CreateMenu("Job Menü", nil, nil)
	_menuPool:Add(JobUI)

	if JobConfig.citizen_interaction_items then
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
	end

	if JobConfig.vehicle_interaction_items then
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
	end

	if JobConfig.restricted_zone then
		local restricted_zone_menu = _menuPool:AddSubMenu(JobUI, "Sperrzone")
		local create_restricted_zone_item = _menuPool:AddSubMenu(restricted_zone_menu.SubMenu, "Erstellen", "Sperrzone erstellen")
	
		local remove = NativeUI.CreateItem("Entfernen", "Sperrzone entfernen")
		restricted_zone_menu.SubMenu:AddItem(remove)
	
		restricted_zone_menu.SubMenu.OnItemSelect = function(sender, item, index)
			if item == remove then
				TriggerServerEvent('esx_jobs:removeRestrictedZone', GetEntityCoords(PlayerPedId()))
			end
		end
	
		range_values = {25.0, 50.0, 75.0, 100.0, 125.0, 150.0}
		local range = NativeUI.CreateListItem('Radius: ', range_values, 0, 'Gebe den Radius an, in der die Sperrzone erstellt werden soll')		
		create_restricted_zone_item.SubMenu:AddItem(range)
	
		duration_values = {5, 10, 15, 20, 25}
		local duration = NativeUI.CreateListItem('Dauer in Minuten: ', duration_values, 0, 'Gebe eine Zeit an wie lange die Sperrzone erhalten soll')		
		create_restricted_zone_item.SubMenu:AddItem(duration)
	
		local send = NativeUI.CreateItem("Erstellen", "Sperrzone erstellen")
		create_restricted_zone_item.SubMenu:AddItem(send)
	
		restricted_zone_menu.SubMenu.OnMenuChanged = function(menu, newmenu, forward)
			if newmenu == create_restricted_zone_item.SubMenu then
				_menuPool:RefreshIndex()
	
				create_restricted_zone_item.SubMenu.OnItemSelect = function(sender, item, index)
					if item == send then
						local data = {
							coords = GetEntityCoords(PlayerPedId()),
							radius = range_values[range._Index],
							duration = duration_values[duration._Index] * 60,
							label = JobConfig.restricted_zone.label,
							color = JobConfig.restricted_zone.color,
						}
						TriggerServerEvent('esx_jobs:createRestrictedZone', data)
					end
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
				if HasPedGotWeapon(PlayerPedId(), weaponHash, false) then

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


function OpenJobBossMenu(JobConfig)
	_menuPool:CloseAllMenus()
	if BossUI ~= nil and BossUI:Visible() then
		BossUI:Visible(false)
	end

    BossUI = NativeUI.CreateMenu(_U('bossmenulabel'), nil, nil)
    _menuPool:Add(BossUI)


	local withdraw = NativeUI.CreateItem(_U("withdraw_society_money"), "")
	BossUI:AddItem(withdraw)

	local deposit = NativeUI.CreateItem(_U("deposit_society_money"), "")
	BossUI:AddItem(deposit)


	BossUI.OnItemSelect = function(sender, item, index)
		if item == withdraw then
			local input = KeyboardInput(_U("withdraw_society_money"), "", 10)
			local amount = tonumber(input)
			if tostring(amount) then
				if not amount then return end
				if amount < 0 then
					TriggerEvent('dopeNotify:Alert', "", _U('quantity_invalid'), 5000, 'error')
				else
					TriggerServerEvent('esx_jobs:withdraw_society_money', 'society_'..PlayerData.job.name, amount)
				end
			end

		elseif item == deposit then
			local input = KeyboardInput(_U("deposit_society_money"), "", 10)
			local amount = tonumber(input)
			if tostring(amount) then
				if not amount then return end
				if amount < 0 then
					TriggerEvent('dopeNotify:Alert', "", _U('quantity_invalid'), 5000, 'error')
				else
					TriggerServerEvent('esx_jobs:deposit_society_money', 'society_'..PlayerData.job.name, amount)
				end
			end
		end
	end


	local employee_menu = _menuPool:AddSubMenu(BossUI, "Angestellte")
	ESX.TriggerServerCallback('esx_society:getEmployees', function(employees)
		for k,v in pairs(employees) do
			local employee = _menuPool:AddSubMenu(employee_menu.SubMenu, v.name, "~y~"..v.name.. "`s~s~ aktueller Rang: ~b~".. v.job.grade_label)

			local promote_employee = _menuPool:AddSubMenu(employee.SubMenu,"Befördern / Degradieren", "~y~"..v.name.. "`s~s~ aktueller Rang: ~b~".. v.job.grade_label)

			local grade_list = {}
			local current_grade = 0
			local jobs = {}
			ESX.TriggerServerCallback('esx_society:getJob', function(job)
				jobs = job
				for k, grade in pairs(jobs.grades) do
					table.insert(grade_list, grade.label)
					if grade.label == v.job.grade_label then
						current_grade = k
					end
				end

				local grade_list_item = NativeUI.CreateListItem('Neuer Rang: ', grade_list, current_grade, "Wähle den neuen Rang für ~y~"..v.name.."~s~ aus")		
				promote_employee.SubMenu:AddItem(grade_list_item)

				grade_list_item.OnListSelected = function(sender, item, index)
					for k, grade in pairs(grade_list) do
						if k == index then
							for k, t in pairs(jobs.grades) do
								if t.label == grade then
									ESX.TriggerServerCallback('esx_society:setJob', function()
										OpenJobBossMenu(JobConfig)
									end, v.identifier, v.job.name, t.grade, 'promote', v.name, v.job.grade)
								end
							end
						end
					end
				end
			end, PlayerData.job.name)

			local fire_employee = _menuPool:AddSubMenu(employee.SubMenu,"Entlassen", "~y~"..v.name.. "`s~s~ aktueller Rang: ~b~".. v.job.grade_label)
			local fire_employee_yes = NativeUI.CreateItem("Ja", "Willst du wirklich ~y~"..v.name.."~s~ aus dem Job entlassen?")
			fire_employee.SubMenu:AddItem(fire_employee_yes)
			local fire_employee_no = NativeUI.CreateItem("Nein", "Willst du wirklich ~y~"..v.name.."~s~ aus dem Job entlassen?")
			fire_employee.SubMenu:AddItem(fire_employee_no)

			fire_employee.SubMenu.OnItemSelect = function(sender, item, index)
				if item == fire_employee_yes then
					ESX.TriggerServerCallback('esx_society:setJob', function()
						OpenJobBossMenu(JobConfig)
					end, v.identifier, 'unemployed', 0, 'fire', v.name, v.job.grade)
				elseif item == fire_employee_no then
					OpenJobBossMenu(JobConfig)
				end
			end

			_menuPool:RefreshIndex()
			_menuPool:MouseControlsEnabled(false)
			_menuPool:MouseEdgeEnabled(false)
			_menuPool:ControlDisablingEnabled(false)
		end
		_menuPool:RefreshIndex()
	end, PlayerData.job.name)

	
    BossUI:Visible(true)
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

function GetRestirctedZones()
	ESX.TriggerServerCallback('esx_jobs:GetRestirctedZones', function(zones)
		TriggerEvent('esx_jobs:createRestrictedZone', zones)
	end)
end

RegisterNetEvent('esx_jobs:removerestictedzone')
AddEventHandler('esx_jobs:removerestictedzone', function(coord)
	for k, v in pairs(RestirctedZones) do
		if v.coord == coord then
			RemoveBlip(v.blip)
			RemoveBlip(v.radiusblip)
			RestirctedZones[k] = nil
		end	
	end
end)

RegisterNetEvent('esx_jobs:createRestrictedZone')
AddEventHandler('esx_jobs:createRestrictedZone', function(new_zone)
	for k, v in pairs(RestirctedZones) do
		RemoveBlip(v.blip)
		RemoveBlip(v.radiusblip)
		RestirctedZones[k] = nil
	end

	for k, v in pairs(new_zone) do
		print(v.radius)
		local blip = AddBlipForCoord(v.coords)
		local radiusblip = AddBlipForRadius(v.coords, v.radius)
		SetBlipSprite(blip, 161)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 1)
		SetBlipColour(blip, v.color)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString(v.label)
		EndTextCommandSetBlipName(blip)
		SetBlipAlpha(radiusblip, 80)
		SetBlipColour(radiusblip, v.color)
		table.insert(RestirctedZones, {coord = v.coords, blip = blip, radiusblip = radiusblip})
	end
end)

AddEventHandler('esx:onPlayerDeath', function(data) isDead = true end)
AddEventHandler('esx:onPlayerSpawn', function(spawn) isDead = false end)
