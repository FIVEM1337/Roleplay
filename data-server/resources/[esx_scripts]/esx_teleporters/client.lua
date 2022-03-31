local _menuPool = NativeUI.CreatePool()
local TeleporterUI                  = nil
local PlayerData = {}
local CurrentAction
local CurrentActionMsg
local CurrentActionData = {}
local HasAlreadyEnteredMarker = false
local isDead = false

CreateThread(function()
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData = ESX.GetPlayerData()
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
		if PlayerData.job and not isDead then
			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)
			local isInMarker = false

			for k, v in ipairs(Config.Teleporters) do
				teleporters = v
				if v.allowed_jobs["all"] or v.allowed_jobs[PlayerData.job.name] then
					for k,v in ipairs(v.teleporters) do
						local distance = GetDistanceBetweenCoords(coords, v.coords, true)
						if teleporters.Marker.DrawDistance.show then
							if distance < teleporters.Marker.DrawDistance then
								DrawMarker(teleporters.Marker.type, v.coords.x, v.coords.y, v.coords.z + teleporters.Marker.Offset, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, teleporters.Marker.size, teleporters.Marker.size, teleporters.Marker.height, teleporters.Marker.color.red, teleporters.Marker.color.green, teleporters.Marker.color.blue, teleporters.Marker.color.alpha, false, true, 2, true, false, false, false)
							end
						end
						if distance < teleporters.Marker.size then
							isInMarker = true
							teleporter = v
						end
					end
				end
			end
			if isInMarker and not HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = true
				TriggerEvent('esx_jobs:hasEnteredMarker', teleporters, teleporter)
			end
			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_jobs:hasExitedMarker', teleporters, teleporter)
			end
		end
		Wait(3)
	end
end)

AddEventHandler('esx_jobs:hasEnteredMarker', function(teleporters, teleporter)
	CurrentAction     = teleporters
	CurrentActionMsg  = teleporters.notification
	CurrentActionData = {teleporters = teleporters, teleporter = teleporter}
end)

AddEventHandler('esx_jobs:hasExitedMarker', function(teleporters, teleporter)
	_menuPool:CloseAllMenus()
	CurrentAction = nil
	CurrentActionMsg = nil
	CurrentActionData = {}
end)

-- Key Controls
CreateThread(function()
	while true do
		if CurrentAction and not isDead then
			if CurrentActionMsg then
				ESX.ShowHelpNotification(CurrentActionMsg)
			end
			if IsControlJustReleased(0, 38) then
				if tablelength(CurrentActionData.teleporters.teleporters) > 2 then
					OpenTeleportMenu()
				else
					for k,v in ipairs(CurrentActionData.teleporters.teleporters) do
						if v.coords ~= CurrentActionData.teleporter.coords then
							SetEntityCoords(PlayerPedId(), v.coords)
							SetEntityHeading(PlayerPedId(), v.heading)
							HasAlreadyEnteredMarker = false
						end
					end
				end
			end
		end
		Wait(1)
	end
end)

function OpenTeleportMenu()
    _menuPool:CloseAllMenus()
	if TeleporterUI ~= nil and TeleporterUI:Visible() then
		TeleporterUI:Visible(false)
	end

	if CurrentAction and not isDead then
		TeleporterUI = NativeUI.CreateMenu(CurrentActionData.teleporters.menu_title, CurrentActionData.teleporters.menu_desc or "", nil)
		_menuPool:Add(TeleporterUI)
	
		for k,v in ipairs(CurrentActionData.teleporters.teleporters) do
			if v.coords ~= CurrentActionData.teleporter.coords then
				local TelportItem = NativeUI.CreateItem(v.label, v.description or "")
				TeleporterUI:AddItem(TelportItem)
				_menuPool:RefreshIndex()
	
				TelportItem.Activated = function(sender, index)
					SetEntityCoords(PlayerPedId(), v.coords)
					SetEntityHeading(PlayerPedId(), v.heading)
					HasAlreadyEnteredMarker = false
					_menuPool:CloseAllMenus()
				end
			end
		end
		TeleporterUI:Visible(true)
		_menuPool:RefreshIndex()
		_menuPool:MouseControlsEnabled(false)
		_menuPool:MouseEdgeEnabled(false)
		_menuPool:ControlDisablingEnabled(false)
	end
end

AddEventHandler('esx:onPlayerDeath', function(data) isDead = true end)
AddEventHandler('esx:onPlayerSpawn', function(spawn) isDead = false end)

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end