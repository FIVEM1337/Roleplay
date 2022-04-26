ESX = nil
AesxAdmin = {}
local display, frozen, isSpectating, noclip  = false, false, false, false
playerID = 0

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNUICallback("exit", function(data)
    SetDisplay(false)
end)

RegisterNUICallback("ban", function(data)
    TriggerServerEvent("AesxAdmin:Ban", data.playerid, tonumber(data.inputData), "You have been put on a timeout")
end)

RegisterNUICallback("permaban", function(data)
    TriggerServerEvent("AesxAdmin:Ban", data.playerid, 0, data.inputData)
end)

RegisterNUICallback("unban", function(data)
    TriggerServerEvent("AesxAdmin:Unban", data.confirmoutput)
    AesxAdmin.GetPlayers()
end)

RegisterNUICallback("addCash", function(data)
    local amnt = tonumber(data.inputData)
    TriggerServerEvent("AesxAdmin:AddCash", data.playerid, amnt)
end)

RegisterNUICallback("addBank", function(data)
    local amnt = tonumber(data.inputData)
    TriggerServerEvent("AesxAdmin:AddBank", data.playerid, amnt)
end)

RegisterNUICallback("inventory", function(data)
	otherinventory = {type = 'player',
                                    label = data.playerid,
                                    identifier = data.playerid,
                                    maxWeight = 34,
                                    save = true}
    TriggerEvent("chezz-inventory:open", otherinventory)
    SetDisplay(false)
end)

RegisterNUICallback("giveitem", function(data)
    local amnt = tonumber(data.amount)
    print("id: "..data.playerid.." name: "..data.name.." amount: "..data.amount)
    TriggerServerEvent("AesxAdmin:AddItem", data.playerid, data.name, amnt)
end)

RegisterNUICallback("error", function(data)
    chat(data.error, {255,0,0})
    SetDisplay(false)
end)

RegisterNUICallback("tp-wp", function(data)
    AesxAdmin.TeleportToWaypoint()
end)

RegisterNUICallback("bring", function(data)
    TriggerServerEvent("AesxAdmin:Teleport", data.playerid, "bring")
end)

RegisterNUICallback("goto", function(data)
    TriggerServerEvent("AesxAdmin:Teleport", data.playerid, "goto")
end)

RegisterNUICallback("kick", function(data)
    TriggerServerEvent("AesxAdmin:Kick", data.playerid, data.inputData)
end)

RegisterNUICallback("spectate", function(data)
	playerID = data.playerid
	AesxAdmin.Spectate(playerID, true)
	isSpectating = true
	SetDisplay(false)
end)

RegisterNUICallback("freeze", function(data)
	TriggerServerEvent("AesxAdmin:Freeze", data.playerid)
end)

RegisterNUICallback("kill", function(data)
	TriggerServerEvent("AesxAdmin:Slay", data.playerid)
end)

RegisterNUICallback("promote", function(data)
	TriggerServerEvent("AesxAdmin:Promote", data.playerid, data.level)
end)

RegisterNUICallback("weapon", function(data)
	TriggerServerEvent("AesxAdmin:GiveWeapon", data.playerid, data.weapon)
end)

RegisterNUICallback("noclip", function(data)
	AesxAdmin.Noclip()
	SetDisplay(false)
end)

RegisterNUICallback("god", function(data)
	TriggerServerEvent("AesxAdmin:God", data.playerid)
end)

RegisterNUICallback("spawnvehicle", function(data)
	AesxAdmin.SpawnVehicle(data.model)
end)

RegisterNUICallback("announce", function(data)
	TriggerServerEvent("AesxAdmin:Announcement", data.inputData)
end)

RegisterNUICallback("setJob", function(data)
	TriggerServerEvent("AesxAdmin:setJob", data.playerid, data.job, data.rank)
end)

RegisterNUICallback("revive", function(data)
	TriggerServerEvent("AesxAdmin:revive", data.playerid)
end)

RegisterNUICallback("setTime", function(data)
	TriggerServerEvent("AesxAdmin:Time", data.inputData)
end)

RegisterNUICallback("freezeTime", function(data)
	TriggerServerEvent("AesxAdmin:freezeTime")
end)

RegisterNUICallback("changeWeather", function(data)
	TriggerServerEvent("AesxAdmin:Weather", data.weather)
end)

RegisterNUICallback("freezeWeather", function(data)
	TriggerServerEvent("AesxAdmin:freezeWeather")
end)

RegisterNUICallback("blackout", function(data)
	TriggerServerEvent("AesxAdmin:Blackout")
end)

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

---Teleport To Waypoint
AesxAdmin.TeleportToWaypoint = function()
    ESX.TriggerServerCallback("esx_marker:fetchUserRank", function(playerRank)
        if Config.Perms[playerRank] and Config.Perms[playerRank].CanTpWp then
            local WaypointHandle = GetFirstBlipInfoId(8)

            if DoesBlipExist(WaypointHandle) then
                local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

                for height = 1, 1000 do
                    SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                    local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

                    if foundGround then
                        SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                        break
                    end

                    Citizen.Wait(5)
                end
                ESX.ShowNotification("Teleported.")
            else
                ESX.ShowNotification("Please place your waypoint.")
            end
        else
            TriggerEvent('chat:addMessage', {args = {"AesxAdmin", " You do not have permission for this."}})
        end
    end)
end

AesxAdmin.GetPlayers = function()
    ESX.TriggerServerCallback("AesxAdmin:getPlayers", function(players) 
        SendNUIMessage({type = "data", data = players})
    end)

	ESX.TriggerServerCallback("AesxAdmin:getBanList", function(bans) 
	    SendNUIMessage({type = "bans", banlist = bans})
	end)
end

AesxAdmin.GetItemList = function()
	local weapons = ESX.GetWeaponList()
	ESX.TriggerServerCallback("AesxAdmin:getJobs", function(jobs) 
	    ESX.TriggerServerCallback("AesxAdmin:getItemList", function(results) 
	        SendNUIMessage({type = "items", itemslist = results, weaponlist = weapons, vehiclelist = Config.Vehicles, joblist = jobs })

	    end)
	end)
end

RegisterNetEvent('AesxAdmin:Freeze')
AddEventHandler('AesxAdmin:Freeze', function(targetPed)
	local player = PlayerId()
	local ped = PlayerPedId()

	frozen = not frozen

	if not frozen then
		if not IsEntityVisible(ped) then
			SetEntityVisible(ped, true)
		end

		if not IsPedInAnyVehicle(ped) then
			SetEntityCollision(ped, true)
		end

		FreezeEntityPosition(ped, false)
		SetPlayerInvincible(player, false)
	else
		SetEntityCollision(ped, false)
		FreezeEntityPosition(ped, true)
		SetPlayerInvincible(player, true)

		if not IsPedFatallyInjured(ped) then
			ClearPedTasksImmediately(ped)
		end
	end
end)

RegisterNetEvent('AesxAdmin:Slay')
AddEventHandler('AesxAdmin:Slay', function(targetPed)
	SetEntityHealth(PlayerPedId(), 0)
end)

local hasGodmode = false
RegisterNetEvent('AesxAdmin:God')
AddEventHandler('AesxAdmin:God', function(targetPed)
	if not hasGodmode then
		hasGodmode = not hasGodmode
		SetEntityInvincible(PlayerPedId(), true)
	else
		SetEntityInvincible(PlayerPedId(), false)
	end
end)

AesxAdmin.SpawnVehicle = function(model)
    ESX.TriggerServerCallback("esx_marker:fetchUserRank", function(playerRank)
        if Config.Perms[playerRank] and Config.Perms[playerRank].CanSpawnVehicle then
			local coords = GetEntityCoords(PlayerPedId())
			local closestVehicle = ESX.Game.GetClosestVehicle(coords)

			ESX.Game.DeleteVehicle(closestVehicle)

			ESX.Game.SpawnVehicle(model, vector3(coords.x + 2.0, coords.y, coords.z), 0.0, function(vehicle) --get vehicle info
				if DoesEntityExist(vehicle) then
					ESX.ShowNotification("Spawned "..model)			
				end		
			end)
		else
            TriggerEvent('chat:addMessage', {args = {"AesxAdmin", " You do not have permission for this."}})
        end
	end)
end

AesxAdmin.Spectate = function(target, bool)
    ESX.TriggerServerCallback("esx_marker:fetchUserRank", function(playerRank)
        if Config.Perms[playerRank] and Config.Perms[playerRank].CanSpectate then
			local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
			local name = GetPlayerName(GetPlayerFromServerId(target))

			if targetPed ~= PlayerPedId() then
				if (bool) then
					if (not IsScreenFadedOut() and not IsScreenFadingOut()) then
						DoScreenFadeOut(1000)
						while (not IsScreenFadedOut()) do
							Wait(0)
						end

						local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))

						RequestCollisionAtCoord(targetx,targety,targetz)
						NetworkSetInSpectatorMode(true, targetPed)

						ESX.ShowNotification("Spectating "..name)

						if(IsScreenFadedOut()) then
							DoScreenFadeIn(1000)
						end
					end
				else
					if(not IsScreenFadedOut() and not IsScreenFadingOut()) then
						DoScreenFadeOut(1000)
						while (not IsScreenFadedOut()) do
							Wait(0)
						end

						local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))

						RequestCollisionAtCoord(targetx,targety,targetz)
						NetworkSetInSpectatorMode(false, targetPed)
						ESX.ShowNotification("Stopped spectating "..name)

						if(IsScreenFadedOut()) then
							DoScreenFadeIn(1000)
						end
					end
				end
			else
				ESX.ShowNotification("You can not spectate yourself.")
			end
	    else
            TriggerEvent('chat:addMessage', {args = {"AesxAdmin ", " You do not have permission for this."}})
        end
    end)
end

AesxAdmin.Noclip = function()
    ESX.TriggerServerCallback("esx_marker:fetchUserRank", function(playerRank)
        if Config.Perms[playerRank] and Config.Perms[playerRank].CanNoClip then
		    local player = PlayerId()
			
		    local msg = "disabled"
			if(noclip == false)then
				noclip_pos = GetEntityCoords(PlayerPedId(), false)
			end

			noclip = not noclip

			if(noclip)then
				msg = "enabled"
			end

			TriggerEvent('chat:addMessage', {args = {"AesxAdmin ", " Noclip has been " .. msg}})
			ESX.ShowNotification(" Noclip has been " .. msg)
			
			local heading = 0
			Citizen.CreateThread(function()
				while true do
					Citizen.Wait(0)

					if(noclip)then
						SetEntityCoordsNoOffset(PlayerPedId(), noclip_pos.x, noclip_pos.y, noclip_pos.z, 0, 0, 0)

						if(IsControlPressed(1, 34))then
							heading = heading + 1.5
							if(heading > 360)then
								heading = 0
							end

							SetEntityHeading(PlayerPedId(), heading)
						end

						if(IsControlPressed(1, 9))then
							heading = heading - 1.5
							if(heading < 0)then
								heading = 360
							end

							SetEntityHeading(PlayerPedId(), heading)
						end

						if(IsControlPressed(1, 8))then
							noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 0.0)
						end

						if(IsControlPressed(1, 32))then
							noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -1.0, 0.0)
						end

						if(IsControlPressed(1, 27))then
							noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 1.0)
						end

						if(IsControlPressed(1, 173))then
							noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, -1.0)
						end
					else
						Citizen.Wait(200)
					end
				end
			end)
		else
            TriggerEvent('chat:addMessage', {args = {"AesxAdmin ", " You do not have permission for this."}})
        end
    end)
end


RegisterKeyMapping("admin", "TESX Admin Menu", "keyboard", 'HOME')

RegisterCommand("admin", function(source,args)
	ESX.TriggerServerCallback("esx_marker:fetchUserRank", function(playerRank)
        if Config.Perms[playerRank] then
        	local coords = round(GetEntityCoords(PlayerPedId()), 2)
        	SendNUIMessage({type = "coords", coordData = coords})
    		AesxAdmin.GetPlayers()
    		AesxAdmin.GetItemList()
    		SetDisplay(true)
    	else
    		TriggerEvent('chat:addMessage', {args = {"AesxAdmin", " You do not have permissions for this"}})
    	end
    end)
end)

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end


Citizen.CreateThread(function() 
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(0, 322) and isSpectating then
			AesxAdmin.Spectate(playerID, false)
			isSpectating = false
			playerID = nil
		elseif IsControlJustPressed(0, 322) and noclip then
			AesxAdmin.Noclip()
		end
	end
end)
