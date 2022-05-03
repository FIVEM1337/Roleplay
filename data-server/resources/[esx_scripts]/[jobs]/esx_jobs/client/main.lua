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
