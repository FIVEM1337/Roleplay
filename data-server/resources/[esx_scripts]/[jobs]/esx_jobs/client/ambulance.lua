ESX = nil
local isDead = false
local firstSpawn = true

CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(100)
	end
end)

-- Disable most inputs when dead
CreateThread(function()
	while true do
		Wait(0)

		if isDead then
			DisableAllControlActions(0)
			EnableControlAction(0, 47, true)
			EnableControlAction(0, 245, true)
			EnableControlAction(0, 38, true)
		else
			Wait(500)
		end
	end
end)


CreateThread(function()
	while true do
	  Wait(100)
	  SetPlayerHealthRechargeMultiplier(PlayerId(), 0)
	end
end)

AddEventHandler('onResourceStart', function (resourceName)
	if(GetCurrentResourceName() ~= resourceName) then
		return
	end
    Wait(100)
	CheckifDead()
end)

AddEventHandler('esx:onPlayerSpawn', function()
    CheckifDead()
end)

function CheckifDead()
    isDead = false

	if firstSpawn then
		firstSpawn = false

		ESX.TriggerServerCallback('esx_jobs:getDeathStatus', function(dead)
			if dead then
				SetEntityHealth(PlayerPedId(), 0)
			end
		end)
	end
end

AddEventHandler('esx:onPlayerDeath', function(data)
	OnPlayerDeath()
end)

function OnPlayerDeath()
	isDead = true
	ESX.UI.Menu.CloseAll()
	TriggerServerEvent('esx_jobs:setDeathStatus', true)

	StartDeathTimer()
	StartScreenEffect('DeathFailOut', 0, false)
end

RegisterNetEvent('esx_jobs:revive')
AddEventHandler('esx_jobs:revive', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	TriggerServerEvent('esx_jobs:setDeathStatus', false)

	DoScreenFadeOut(800)

	while not IsScreenFadedOut() do
		Wait(50)
	end

	local formattedCoords = {
		x = ESX.Math.Round(coords.x, 1),
		y = ESX.Math.Round(coords.y, 1),
		z = ESX.Math.Round(coords.z, 1)
	}

	RespawnPed(playerPed, formattedCoords, 0.0)

	StopScreenEffect('DeathFailOut')
	DoScreenFadeIn(800)
end)

RegisterNetEvent('esx_jobs:useItem')
AddEventHandler('esx_jobs:useItem', function(itemName)
	ESX.UI.Menu.CloseAll()

	if itemName == 'medikit' then
		local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01' -- TODO better animations
		local playerPed = PlayerPedId()

		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)

			Wait(500)
			while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
				Wait(0)
				DisableAllControlActions(0)
			end

			TriggerEvent('esx_jobs:heal', 'big', true)
			ESX.ShowNotification(_U('used_medikit'))
		end)

	elseif itemName == 'bandage' then
		local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01' -- TODO better animations
		local playerPed = PlayerPedId()

		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)

			Wait(500)
			while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
				Wait(0)
				DisableAllControlActions(0)
			end

			TriggerEvent('esx_jobs:heal', 'small', true)
			ESX.ShowNotification(_U('used_bandage'))
		end)
	end
end)

RegisterNetEvent('esx_jobs:heal')
AddEventHandler('esx_jobs:heal', function(healType, quiet)
	local playerPed = PlayerPedId()
	local maxHealth = GetEntityMaxHealth(playerPed)

	if healType == 'small' then
		local health = GetEntityHealth(playerPed)
		local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 8))
		SetEntityHealth(playerPed, newHealth)
	elseif healType == 'big' then
		SetEntityHealth(playerPed, maxHealth)
	end

	if not quiet then
		ESX.ShowNotification(_U('healed'))
	end
end)

function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)

	TriggerServerEvent('esx:onPlayerSpawn')
	TriggerEvent('esx:onPlayerSpawn')
	TriggerEvent('playerSpawned') -- compatibility with old scripts, will be removed soon
end


function RevivePlayer(closestPlayer)
	if currentTask.busy then
		return
	end
	ESX.TriggerServerCallback('esx_jobs:getItemAmount', function(quantity)
		if quantity > 0 then
			local closestPlayerPed = GetPlayerPed(closestPlayer)

			if IsPedDeadOrDying(closestPlayerPed, 1) then
				currentTask.busy = true

				local playerPed = PlayerPedId()
				local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'
				ESX.ShowNotification(_U('revive_inprogress'))

				for i=1, 15 do
					Wait(900)

					ESX.Streaming.RequestAnimDict(lib, function()
						TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
					end)
				end

				TriggerServerEvent('esx_jobs:removeItem', 'medikit')
				TriggerServerEvent('esx_jobs:revive', GetPlayerServerId(closestPlayer))
				currentTask.busy = false
			else
				ESX.ShowNotification(_U('player_not_unconscious'))
			end
		else
			ESX.ShowNotification(_U('not_enough_medikit'))
		end
	end, 'medikit')
end

function HealPlayer(closestPlayer, healtype)
	if currentTask.busy then
		return
	end

	local item = nil
	if healtype == "small" then
		item = "bandage"
	else
		item = "medikit"
	end
	ESX.TriggerServerCallback('esx_jobs:getItemAmount', function(quantity)
		if quantity > 0 then
			local closestPlayerPed = GetPlayerPed(closestPlayer)
			local health = GetEntityHealth(closestPlayerPed)

			if health > 0 then
				local playerPed = PlayerPedId()

				currentTask.busy = true
				ESX.ShowNotification(_U('heal_inprogress'))
				TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
				Wait(10000)
				ClearPedTasks(playerPed)

				TriggerServerEvent('esx_jobs:removeItem', 'bandage')
				TriggerServerEvent('esx_jobs:heal', GetPlayerServerId(closestPlayer), healtype)
				ESX.ShowNotification(_U('heal_complete'))
				currentTask.busy = false
			else
				ESX.ShowNotification(_U('player_not_conscious'))
			end
		else
			if healtype == "small" then
				ESX.ShowNotification(_U('not_enough_bandage'))
			else
				ESX.ShowNotification(_U('not_enough_medikit'))
			end
		end
	end, 'bandage')
end

function StartDeathTimer()
	local canPayFine = false

	ESX.TriggerServerCallback('esx_jobs:checkBalance', function(canPay)
		canPayFine = canPay
	end)

	local earlySpawnTimer = ESX.Math.Round(Config.EarlyRespawnTimer / 1000)
	local bleedoutTimer = ESX.Math.Round(Config.BleedoutTimer / 1000)

	CreateThread(function()
		-- early respawn timer
		while earlySpawnTimer > 0 and isDead do
			Wait(1000)

			if earlySpawnTimer > 0 then
				earlySpawnTimer = earlySpawnTimer - 1
			end
		end

		-- bleedout timer
		while bleedoutTimer > 0 and isDead do
			Wait(1000)

			if bleedoutTimer > 0 then
				bleedoutTimer = bleedoutTimer - 1
			end
		end
	end)

	CreateThread(function()
		local text, timeHeld

		-- early respawn timer
		while earlySpawnTimer > 0 and isDead do
			Wait(0)
			text = _U('respawn_available_in', secondsToClock(earlySpawnTimer))

			DrawGenericTextThisFrame()

			SetTextEntry('STRING')
			AddTextComponentString(text)
			DrawText(0.5, 0.8)
		end

		-- bleedout timer
		while bleedoutTimer > 0 and isDead do
			Wait(0)
			text = _U('respawn_bleedout_in', secondsToClock(bleedoutTimer))

			if canPayFine then
				text = text .. _U('respawn_bleedout_fine', ESX.Math.GroupDigits(Config.EarlyRespawnFineAmount))

				if IsControlPressed(0, 38) and timeHeld > 60 then
					TriggerServerEvent('esx_jobs:payFine')
					RemoveItemsAfterRPDeath()
					break
				end
			end

			if IsControlPressed(0, 38) then
				timeHeld = timeHeld + 1
			else
				timeHeld = 0
			end

			DrawGenericTextThisFrame()
			SetTextEntry('STRING')
			AddTextComponentString(text)
			DrawText(0.5, 0.8)
		end

		if bleedoutTimer < 1 and isDead then
			RemoveItemsAfterRPDeath()
		end
	end)
end

function RemoveItemsAfterRPDeath()
	TriggerServerEvent('esx_jobs:setDeathStatus', false)

	CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Wait(10)
		end

		ESX.TriggerServerCallback('esx_jobs:removeItemsAfterRPDeath', function()
			local formattedCoords = {
				x = Config.RespawnPoint.coords.x,
				y = Config.RespawnPoint.coords.y,
				z = Config.RespawnPoint.coords.z
			}

			ESX.SetPlayerData('loadout', {})
			RespawnPed(PlayerPedId(), formattedCoords, Config.RespawnPoint.heading)

			StopScreenEffect('DeathFailOut')
			DoScreenFadeIn(800)
		end)
	end)
end

function DrawGenericTextThisFrame()
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
end

function secondsToClock(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format('%02.f', math.floor(seconds / 3600))
		local mins = string.format('%02.f', math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format('%02.f', math.floor(seconds - hours * 3600 - mins * 60))

		return mins, secs
	end
end