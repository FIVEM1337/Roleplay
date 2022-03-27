
local _menuPool = NativeUI.CreatePool()
local blips_list = {}
local npc_list = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local work  = false
local cantrigger = true
local InMarker = false
local HasAlreadyEnteredTeleporteMarker = false
local InTeleporterMarker = false


CreateThread(function()
	DeleteBlips()
	for k, v in pairs (routen) do
		for k, v in pairs (v) do
			if not v.illegal then
				for k, v in pairs (v) do
					if (type(v) == "table") then
						CreateBlip(v)
					end
				end
			end
		end
	end
	TriggerEvent('esx_routen:spawnnpcs')

	while true do
		Wait(100)
		if npc_list then
			for i, ped in ipairs(npc_list) do
				TaskSetBlockingOfNonTemporaryEvents(ped, true)
			end
		end
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	DeleteBlips()
	for k, v in pairs (routen) do
		for k, v in pairs (v) do
			for k, v in pairs (v) do
				if (type(v) == "table") then
					CreateBlip(v)
				end
			end
		end
	end
end)


AddEventHandler('esx_routen:spawnnpcs', function ()
	for k, v in pairs (routen) do
		for k, v in pairs (v) do
			for k, v in pairs (v) do
				if (type(v) == "table") then
					if v.npc then
						RequestModel(v.npc.model)
						LoadPropDict(v.npc.model)
						local ped = CreatePed(5, v.npc.model , v.coord, v.npc.heading, false, true)
						PlaceObjectOnGroundProperly(ped)
						SetEntityAsMissionEntity(ped)
						SetPedDropsWeaponsWhenDead(ped, false)
						FreezeEntityPosition(ped, true)
						SetPedAsEnemy(ped, false)
						SetEntityInvincible(ped, true)
						SetModelAsNoLongerNeeded(v.npc.model)
						SetPedCanBeTargetted(ped, false)
						table.insert(npc_list, ped)
					end
				end
			end
		end
	end
end)

-- Display markers
CreateThread(function()
	while true do
		Wait(3)
		coords = GetEntityCoords(PlayerPedId())
		for k, v in pairs (routen) do
			for k, v in pairs (v) do
				if not v.illegal then
					for k, v in pairs (v) do
						if (type(v) == "table") then
							if v.marker.show then
								if(GetDistanceBetweenCoords(coords, v.coord.x, v.coord.y, v.coord.z, true) < 30.0) then
									DrawMarker(v.marker.type, v.coord, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.marker.range, v.marker.range, 1.0, v.marker.red, v.marker.green, v.marker.blue, 100, false, true, 2, true, false, false, false)
								end
							end
							if v.teleporters then
								for k, v in ipairs(v.teleporters) do
									if v.showmarker then
										if(GetDistanceBetweenCoords(coords, v.enter, true) < v.distance) then
											DrawMarker(Config.TeleporterMarker.type, v.enter, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.TeleporterMarker.range,Config.TeleporterMarker.range, 1.0, Config.TeleporterMarker.red, Config.TeleporterMarker.green, Config.TeleporterMarker.blue, 100, false, true, 2, true, false, false, false)
										end
									end
								end
							end					
						end
					end
				end
			end
		end
	end
end)

-- Enter / Exit marker events
CreateThread(function ()
	while true do
		Wait(60)

		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local isInTeleporterMarker  = false
		local currentZone = nil
		local Teleporterdata = nil

		for k, v in pairs (routen) do
			for k, v in pairs (v) do
				for k, v in pairs (v) do
					zone = v
					if (type(v) == "table") then
						if(#(coords - v.coord) < (v.marker.range / 2)) then
							isInMarker  = true
							InMarker = true
							currentZone = zone
						else
							if v.teleporters then
								for k, v in pairs (v.teleporters) do
									if(#(coords - v.enter) < (Config.TeleporterMarker.range / 2)) then
										if v.shownotification then
											showInfobar("Drücke ~g~E~s~, den Teleporter zu benutzen")
										end
										InTeleporterMarker = true
										isInTeleporterMarker  = true
										Teleporterdata = v
										currentZone = zone
									end
								end
							end
						end
					end
				end
			end
		end
		if isInMarker and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
			LastZone = currentZone
			TriggerEvent('esx_routen:hasEnteredMarker', LastZone)
		elseif not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_routen:hasExitedMarker', LastZone)
			InMarker = false
		end


		if isInTeleporterMarker and not HasAlreadyEnteredTeleporteMarker then
			HasAlreadyEnteredTeleporteMarker = true
			LastZone = currentZone
			TriggerEvent('esx_routen:hasEnteredTeleporterMarker', LastZone, Teleporterdata)
		elseif not isInTeleporterMarker and HasAlreadyEnteredTeleporteMarker then
			HasAlreadyEnteredTeleporteMarker = false
			TriggerEvent('esx_routen:hasExitedMarker', LastZone)
			InMarker = false
		end
	end
end)


RegisterNetEvent('esx_routen:waittotrigger')
AddEventHandler('esx_routen:waittotrigger', function()
	cantrigger = false
	Wait(5000)
	cantrigger = true
end)


RegisterNetEvent('esx_routen:changestatus')
AddEventHandler('esx_routen:changestatus', function(status)
	work = status
	if status == false then
		ClearPedTasks(PlayerPedId())
	end
end)

AddEventHandler('esx_routen:hasEnteredMarker', function (zone, data)
	local PlayerData = ESX.GetPlayerData()
	CurrentAction     = zone
	CurrentActionMsg  = "route"
	CurrentActionData = {}
end)

AddEventHandler('esx_routen:hasExitedMarker', function (zone)
	ESX.TriggerServerCallback('esx_routen:done', function(running)
		if running then
			TriggerServerEvent('esx_routen:stopRoute', LastZone)
		end
	end)
	CurrentAction = nil
end)


AddEventHandler('esx_routen:hasEnteredTeleporterMarker', function (zone, data)
	CurrentAction     = zone
	CurrentActionMsg  = "porter"
	CurrentActionData = data
end)

AddEventHandler('esx_routen:hasExitedTeleporterMarker', function (zone)

	CurrentAction = nil
end)

-- Key controls
CreateThread(function()
	while true do
		Wait(1)

		if CurrentAction == nil then
			Wait(500)
		else
			tablesize = tablelength(LastZone.dosomething)
			if tablesize > 1 then
				_menuPool:ProcessMenus()
			end
			
			if IsControlJustReleased(0, Config.ControlKey) then
				if CurrentActionMsg == "route" then
					if cantrigger then
						if tablesize > 0 then
							TriggerEvent('esx_routen:waittotrigger')
							ESX.TriggerServerCallback('esx_routen:done', function(running)
								if running then
									TriggerServerEvent('esx_routen:stopRoute')
								else
									if tablesize > 1 then
										OpenSelectMenu(LastZone)
	
									else
										for k, v in ipairs(LastZone.dosomething) do
											TriggerServerEvent('esx_routen:startRoute', v.label)
											break
										end
									end
								end
							end)
						end
					else
						TriggerEvent('dopeNotify:Alert', "", "Du kannst das gerade noch nicht tun", 2000, 'error')
					end
				elseif CurrentActionMsg == "porter" then
					if cantrigger then
						TriggerEvent('esx_routen:waittotrigger')
						SetEntityCoords(PlayerPedId(), CurrentActionData.exit)
					else
						TriggerEvent('dopeNotify:Alert', "", "Du kannst das gerade noch nicht tun", 2000, 'error')
					end
				end
			end
		end
	end
end)


CreateThread(function()
	while true do
		Wait(50)
		if InMarker then
			if work then
				showInfobar("Drücke ~g~E~s~, um Interaktion zu beenden")
			else
				showInfobar("Drücke ~g~E~s~, um Interaktion zu starten")
			end
		end
	end
end)


CreateThread(function()
	while true do
		Wait(100)
		if work and Config.PlayAnimations then
			if not IsPedUsingScenario(PlayerPedId(), LastZone.animation) then
				TaskStartScenarioInPlace(PlayerPedId(), LastZone.animation, 0, true)
			end
		end
	end
end)


function OpenSelectMenu(zone)
	if selectItemMenu ~= nil and selectItemMenu:Visible() then
		selectItemMenu:Visible(false)
	end

	selectItemMenu = NativeUI.CreateMenu(zone.title, nil)

	for k, v in ipairs(zone.dosomething) do
		local item = NativeUI.CreateItem(v.label, "Du hast eine Chance von ~g~"..v.chance.."%~s~ um ~g~"..v.label.."~s~ herzustellen")
		selectItemMenu:AddItem(item)
		if tablelength(zone.dosomething) == k then
			_menuPool:Add(selectItemMenu)
		end
	end

	selectItemMenu.OnItemSelect = function(sender, item, index)
		_menuPool:CloseAllMenus()
		for k, v in ipairs(zone.dosomething) do
			if v.label == item.Text:Text() then
                ESX.TriggerServerCallback('esx_routen:done', function(running)
                    cantrigger = false
                    if running then
                        TriggerServerEvent('esx_routen:stopRoute', v.label)
                    else
                        TriggerServerEvent('esx_routen:startRoute', v.label)
                    end
                end)
				break
			end
		end
	end

	selectItemMenu:Visible(true)
	_menuPool:MouseControlsEnabled (false)
	_menuPool:MouseEdgeEnabled (false)
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

function CreateBlip(config)
	local blip = AddBlipForCoord(config.coord)
	SetBlipSprite(blip, config.blip.sprite)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, config.blip.scale)
	SetBlipColour(blip, config.blip.color)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName('STRING')	
	AddTextComponentSubstringPlayerName(config.name)
	EndTextCommandSetBlipName(blip)
	table.insert(blips_list, blip)
end


AddEventHandler('onResourceStop', function(resource)
	if resourceName == GetCurrentResourceName() then

		if npc_list then
			for i, ped in ipairs(npc_list) do
				DeletePed(ped)
			end
			npc_list = {}
		end
	end
end)    

function LoadPropDict(model)
	while not HasModelLoaded(GetHashKey(model)) do
	  RequestModel(GetHashKey(model))
	  Wait(10)
	end
end

function showInfobar(msg)
	SetTextComponentFormat('STRING')
	AddTextComponentString(msg)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
  end