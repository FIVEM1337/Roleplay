

Config = {}
Config.Locale = 'de'
Config.OpenKey = 'F5'
Config.MenuPosition = 'left'
Config.NoclipSpeed = 1.0

Config.HandsupKey = "h"
Config.PointKey = "b"

PersonalMenu = {
	DoorState = {
		FrontLeft = false,
		FrontRight = false,
		BackLeft = false,
		BackRight = false,
		Hood = false,
		Trunk = false
	},
}

Player = {
	isDead = false,
	noclip = false,
	godmode = false,
	ghostmode = false,
	group = 'user'
}


Config.Wallet = {
	{
		label = "wallet_show_idcard_button",
		command = 
		function()
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

			if closestDistance ~= -1 and closestDistance <= 3.0 then
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
			else
				TriggerEvent('dopeNotify:Alert', "", _U('players_nearby'), 5000, 'error')
			end	
		end
	},
	{
		label = "wallet_check_idcard_button",
		command = 
		function()
			TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
		end
	},

	{
		label = "wallet_show_driver_button",
		command = 
		function()
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

			if closestDistance ~= -1 and closestDistance <= 3.0 then
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'driver')
			else
				TriggerEvent('dopeNotify:Alert', "", _U('players_nearby'), 5000, 'error')
			end
		end
	},
	{
		label = "wallet_check_driver_button",
		command = 
		function()
			TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
		end
	},
	{
		label = "wallet_show_firearms_button",
		command = 
		function()
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

			if closestDistance ~= -1 and closestDistance <= 3.0 then
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'weapon')
			else
				TriggerEvent('dopeNotify:Alert', "", _U('players_nearby'), 5000, 'error')
			end
		end
	},
	{
		label = "wallet_check_firearms_button",
		command = 
		function()
			TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
		end
	},
}

Config.Vehicle = {
	{
		label = "vehicle_engine_button",
		command = 
		function()
			if not IsPedSittingInAnyVehicle(plyPed) then
				TriggerEvent('dopeNotify:Alert', "", _U('no_vehicle'), 5000, 'error')
			elseif IsPedSittingInAnyVehicle(plyPed) then
				local plyVeh = GetVehiclePedIsIn(plyPed, false)

				if GetIsVehicleEngineRunning(plyVeh) then
					SetVehicleEngineOn(plyVeh, false, false, true)
					SetVehicleUndriveable(plyVeh, true)
				elseif not GetIsVehicleEngineRunning(plyVeh) then
					SetVehicleEngineOn(plyVeh, true, false, true)
					SetVehicleUndriveable(plyVeh, false)
				end
			end
		end
	},
	{
		label = "vehicle_door_button",
		list = {_U('vehicle_door_frontleft'), _U('vehicle_door_frontright'), _U('vehicle_door_backleft'), _U('vehicle_door_backright')},
		command = 
		function(menu, item, newindex)
			plyPed = PlayerPedId()
			if not IsPedSittingInAnyVehicle(plyPed) then
				TriggerEvent('dopeNotify:Alert', "", _U('no_vehicle'), 5000, 'error')
			elseif IsPedSittingInAnyVehicle(plyPed) then
				local plyVeh = GetVehiclePedIsIn(plyPed, false)
				if newindex == 1 then
					if not PersonalMenu.DoorState.FrontLeft then
						PersonalMenu.DoorState.FrontLeft = true
						SetVehicleDoorOpen(plyVeh, 0, false, false)
					elseif PersonalMenu.DoorState.FrontLeft then
						PersonalMenu.DoorState.FrontLeft = false
						SetVehicleDoorShut(plyVeh, 0, false, false)
					end
				elseif newindex == 2 then
					if not PersonalMenu.DoorState.FrontRight then
						PersonalMenu.DoorState.FrontRight = true
						SetVehicleDoorOpen(plyVeh, 1, false, false)
					elseif PersonalMenu.DoorState.FrontRight then
						PersonalMenu.DoorState.FrontRight = false
						SetVehicleDoorShut(plyVeh, 1, false, false)
					end
				elseif newindex == 3 then
					if not PersonalMenu.DoorState.BackLeft then
						PersonalMenu.DoorState.BackLeft = true
						SetVehicleDoorOpen(plyVeh, 2, false, false)
					elseif PersonalMenu.DoorState.BackLeft then
						PersonalMenu.DoorState.BackLeft = false
						SetVehicleDoorShut(plyVeh, 2, false, false)
					end
				elseif newindex == 4 then
					if not PersonalMenu.DoorState.BackRight then
						PersonalMenu.DoorState.BackRight = true
						SetVehicleDoorOpen(plyVeh, 3, false, false)
					elseif PersonalMenu.DoorState.BackRight then
						PersonalMenu.DoorState.BackRight = false
						SetVehicleDoorShut(plyVeh, 3, false, false)
					end
				end
			end
		end
	},

}

Config.Admin = {
	{
		label = "admin_tpmarker_button",
		groups = {'owner', 'admin'},
		command = 
		function()
			local waypointHandle = GetFirstBlipInfoId(8)

			if DoesBlipExist(waypointHandle) then
				CreateThread(function()
					local waypointCoords = GetBlipInfoIdCoord(waypointHandle)
					local foundGround, zCoords, zPos = false, -500.0, 0.0

					while not foundGround do
						zCoords = zCoords + 10.0
						RequestCollisionAtCoord(waypointCoords.x, waypointCoords.y, zCoords)
						Wait(0)
						foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords.x, waypointCoords.y, zCoords)

						if not foundGround and zCoords >= 2000.0 then
							foundGround = true
						end
					end

					SetPedCoordsKeepVehicle(plyPed, waypointCoords.x, waypointCoords.y, zPos)
					TriggerEvent('dopeNotify:Alert', "", _U('admin_tpmarker'), 5000, 'info')
				end)
			else
				TriggerEvent('dopeNotify:Alert', "", _U('admin_nomarker'), 5000, 'error')
			end
		end
	},
	{
		label = "admin_noclip_button",
		groups = {'owner', 'admin', 'mod'},
		command = 
		function()
			Player.noclip = not Player.noclip

			if Player.noclip then
				FreezeEntityPosition(plyPed, true)
				SetEntityInvincible(plyPed, true)
				SetEntityCollision(plyPed, false, false)

				SetEntityVisible(plyPed, false, false)

				SetEveryoneIgnorePlayer(PlayerId(), true)
				SetPoliceIgnorePlayer(PlayerId(), true)
				TriggerEvent('dopeNotify:Alert', "", _U('admin_noclipon'), 5000, 'info')
			else
				FreezeEntityPosition(plyPed, false)
				SetEntityInvincible(plyPed, false)
				SetEntityCollision(plyPed, true, true)

				SetEntityVisible(plyPed, true, false)

				SetEveryoneIgnorePlayer(PlayerId(), false)
				SetPoliceIgnorePlayer(PlayerId(), false)
				TriggerEvent('dopeNotify:Alert', "", _U('admin_noclipoff'), 5000, 'info')
			end
		end
	},
	{
		label = "admin_changesound_button",
		groups = {'owner', 'admin', 'mod'},
		command = 
		function()
			plyPed = PlayerPedId()
			if IsPedSittingInAnyVehicle(plyPed) then
				local plyVeh = GetVehiclePedIsIn(plyPed, false)
				sound = KeyboardInput('KORIOZ_BOX_ID', _U('dialogbox_soundname'), '', 20)
				ForceVehicleEngineAudio(plyVeh, sound)
				Wait(5)
				SetVehRadioStation(plyVeh, "OFF")

				_menuPool:CloseAllMenus()
			else
				TriggerEvent('dopeNotify:Alert', "", _U('no_vehicle'), 5000, 'error')
			end
		end
	},
	{
		label = "admin_godmode_button",
		groups = {'owner', 'admin'},
		command = 
		function()
			Player.godmode = not Player.godmode

			if Player.godmode then
				SetEntityInvincible(plyPed, true)
				TriggerEvent('dopeNotify:Alert', "", _U('admin_godmodeon'), 5000, 'info')
			else
				SetEntityInvincible(plyPed, false)
				TriggerEvent('dopeNotify:Alert', "", _U('admin_godmodeoff'), 5000, 'info')
			end
		end
	},
	{
		label = "admin_goto_button",
		groups = {'owner', 'admin', 'mod'},
		command = 
		function()
			local plyId = KeyboardInput('KORIOZ_BOX_ID', _U('dialogbox_playerid'), '', 8)

			if plyId ~= nil then
				plyId = tonumber(plyId)
				
				if type(plyId) == 'number' then
					TriggerServerEvent('esx_personalmenu2:BringPlayer', GetPlayerServerId(PlayerId()), plyId)
				end
			end
		end
	},
	{
		label = "admin_bring_button",
		groups = {'owner', 'admin', 'mod'},
		command = 
		function()
			local plyId = KeyboardInput('KORIOZ_BOX_ID', _U('dialogbox_playerid'), '', 8)

			if plyId ~= nil then
				plyId = tonumber(plyId)
				
				if type(plyId) == 'number' then
					TriggerServerEvent('esx_personalmenu2:BringPlayer', plyId, GetPlayerServerId(PlayerId()))
				end
			end
		end
	},
	{
		label = "admin_spawnveh_button",
		groups = {'owner', 'admin'},
		command = 
		function()
			local modelName = KeyboardInput('KORIOZ_BOX_VEHICLE_NAME', _U('dialogbox_vehiclespawner'), '', 50)

			if modelName ~= nil then
				modelName = tostring(modelName)

				if type(modelName) == 'string' then
					ESX.Game.SpawnVehicle(modelName, GetEntityCoords(plyPed), GetEntityHeading(plyPed), function(vehicle)
						TaskWarpPedIntoVehicle(plyPed, vehicle, -1)
					end)
				end
			end
		end
	},
	{
		label = "admin_ghostmode_button",
		groups = {'owner', 'admin'},
		command = 
		function()
			Player.ghostmode = not Player.ghostmode

			if Player.ghostmode then
				SetEntityVisible(plyPed, false, false)
				TriggerEvent('dopeNotify:Alert', "", _U('admin_ghoston'), 5000, 'info')
			else
				SetEntityVisible(plyPed, true, false)
				TriggerEvent('dopeNotify:Alert', "", _U('admin_ghostoff'), 5000, 'info')
			end
		end
	},
	{
		label = "admin_repairveh_button",
		groups = {'owner', 'admin'},
		command = 
		function()
			local plyVeh = GetVehiclePedIsIn(plyPed, false)
			SetVehicleFixed(plyVeh)
			SetVehicleDirtLevel(plyVeh, 0.0)
		end
	},
	{
		label = "admin_flipveh_button",
		groups = {'owner', 'admin'},
		command = 
		function()
			local plyCoords = GetEntityCoords(plyPed)
			local newCoords = plyCoords + vector3(0.0, 2.0, 0.0)
			local closestVeh = GetClosestVehicle(plyCoords, 10.0, 0, 70)

			SetEntityCoords(closestVeh, newCoords)
			TriggerEvent('dopeNotify:Alert', "", _U('admin_vehicleflip'), 5000, 'info')
		end
	},
	{
		label = "admin_revive_button",
		groups = {'owner', 'admin'},
		command = 
		function()
			local plyId = KeyboardInput('KORIOZ_BOX_ID', _U('dialogbox_playerid'), '', 8)

			if plyId ~= nil then
				plyId = tonumber(plyId)
				
				if type(plyId) == 'number' then
					TriggerServerEvent('esx_jobs:revive', plyId)
				end
			end
		end
	},
}

