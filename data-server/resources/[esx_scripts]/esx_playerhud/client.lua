local isTalking, isMuted, IsConnected, currentRange, markerOn, markerTimer = false, false, true, 3.5, false, 0
local postals = json.decode(LoadResourceFile(GetCurrentResourceName(), "json/postals.json"))
local Spawned = false
local show = false
local minimap_show = false
CreateThread(function()

	while true do
		if Spawned then
			if show then
				if IsPauseMenuActive() then
					SendNUIMessage({action = "show", show = false})
					show = false
				end
			else
				if not IsPauseMenuActive() then
					SendNUIMessage({action = "show", show = true})
					show = true
				end
			end
			Wait(1)
		else
			Wait(100)
		end
	end
end)


CreateThread(function()
	while true do
	
		Wait(1)
		if Spawned then
			if IsPedInAnyVehicle(PlayerPedId()) then
				if not IsMinimapRendering() then
					DisplayRadar(true)
				end
			else
				if IsMinimapRendering() then
					DisplayRadar(false)
				end
			end
		else
			if IsMinimapRendering() then
				DisplayRadar(false)
			end
		end
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer) 
	TriggerEvent("esx_playerhud:LoadPlayerDataHUD", xPlayer)
	UpdateMinimapLocation()
	Wait(100)
	Spawned = true
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		UpdateMinimapLocation()
		Wait(100)
		Spawned = true

		TriggerEvent("esx_playerhud:LoadPlayerDataHUD")
	end
end)

function UpdateMinimapLocation()
	CreateThread(function()
		-- Get screen aspect ratio
		local ratio = GetScreenAspectRatio()

		-- Default values for 16:9 monitors
		local posX = -0.0045
		local posY = -0.020

		if tonumber(string.format("%.2f", ratio)) >= 2.3 then
			-- Ultra wide 3440 x 1440 (2.39)
			-- Ultra wide 5120 x 2160 (2.37)
			posX = -0.185
			posY = -0.020
			print('Ultra Wide Monitor found adjust Minimap position')
		else 
			posX = -0.0045
			posY = -0.020

		end

		SetMinimapComponentPosition('minimap', 'L', 'B', posX, posY, 0.150, 0.188888)
		SetMinimapComponentPosition('minimap_mask', 'L', 'B', posX + 0.0155, posY + 0.03, 0.111, 0.159)
		SetMinimapComponentPosition('minimap_blur', 'L', 'B', posX - 0.0255, posY + 0.02, 0.266, 0.237)

		SetRadarBigmapEnabled(true, false)
		Wait(500)
		SetRadarBigmapEnabled(false, false)
	end)
end
  
  RegisterCommand('reload-map', function(src, args)
	UpdateMinimapLocation()
  end, false)


RegisterNetEvent("esx_playerhud:LoadPlayerDataHUD") 
AddEventHandler("esx_playerhud:LoadPlayerDataHUD", function()
	local PlayerData = ESX.GetPlayerData()

	for k,v in pairs(PlayerData.accounts) do
		local account = v
		if account.name == "money" then
			SendNUIMessage({action = "setValue", key = "money", value = ESX.Math.GroupDigits(account.money)})
		end
	end
	-- Job
	SendNUIMessage({action = "setValue", key = "job", value = PlayerData.job.label.." - "..PlayerData.job.grade_label, icon = PlayerData.job.name})

	-- Player ID
	SendNUIMessage({action = "setValue", key = "player_id", value = "ID: "..GetPlayerServerId(NetworkGetEntityOwner(PlayerPedId()))})


    TriggerEvent('esx_status:getStatusPercent', 'hunger', function(hunger) 
		currenthunger = hunger
    end)

    TriggerEvent('esx_status:getStatusPercent', 'thirst', function(thirst)
		currentthirst = thirst
    end)
	    
    TriggerEvent('esx_status:getStatusPercent', 'stress', function(stress)
		currentstress = stress
    end)

	SendNUIMessage({action = "updateStatus", hunger = currenthunger, thirst = currentthirst, stress = currentstress})
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	if account.name == "money" then
		SendNUIMessage({action = "setValue", key = "money", value = ESX.Math.GroupDigits(account.money)})
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  SendNUIMessage({action = "setValue", key = "job", value = job.label.." - "..job.grade_label, icon = job.name})
end)

RegisterNetEvent('esx_playerhud:updateStatus')
AddEventHandler('esx_playerhud:updateStatus', function(status)

	for k, v in ipairs(status) do
		if v.name == 'hunger' then
			currenthunger = v.percent
		elseif v.name == 'thirst' then
			currentthirst = v.percent
		elseif v.name == 'stress' then
			currentstress = v.percent
		end
	end

	SendNUIMessage({action = "updateStatus", hunger = currenthunger, thirst = currentthirst, stress = currentstress})
end)


-- Disable Afk Cam
CreateThread(function()
	while true do
		InvalidateIdleCam()
		InvalidateVehicleIdleCam()
		Wait(1000)
	end
end)
-- Disable Afk Cam End

-- Voice
AddEventHandler("SaltyChat_VoiceRangeChanged", function(range)
	currentRange = range

	MarkerTimer()
	SetVoice()
end)

AddEventHandler("SaltyChat_TalkStateChanged", function(talking)
	isTalking = talking
	SetVoice()
end)

AddEventHandler("SaltyChat_MicStateChanged", function(muted)
	if muted then
		isMuted = true
	else
		isMuted = false
	end
	SetVoice()
end)

AddEventHandler("SaltyChat_PluginStateChanged", function(pluginState)
	if pluginState ~= 2 then
		IsConnected = false
	else
		IsConnected = true
	end
	SetVoice()
end)

AddEventHandler("SaltyChat_RadioChannelChanged", function(radioChannel, isPrimaryChannel)
	if radioChannel then
		SendNUIMessage({action = "setValue", key = "radio", value = radioChannel.." MHZ"})
	else
		SendNUIMessage({action = "setValue", key = "radio", value = "--- MHZ"})
	end
end)

CreateThread(function()
	Wait(1)
	currentRange = exports.saltychat:GetVoiceRange()
	SetVoice()
end)

function SetVoice()
	SendNUIMessage({action = "setVoice", range = currentRange, muted = isMuted, talking = isTalking, connected = IsConnected})
end

CreateThread(function()
	while true do
		Wait(1)
		if markerOn == true then
			coords = GetEntityCoords(PlayerPedId())
			Marker(1, coords.x, coords.y, coords.z, currentRange)
		end
	end
end)

function MarkerTimer()
	markerOn = true
	CreateThread(function()
		markerTimer = 10

		while markerTimer > 0 do
			Wait(1000)
			markerTimer = markerTimer - 1
		end

		if markerTimer <= 0 then
			markerOn = false
		end
	end)
end

function Marker(type, x, y, z, range)
	if range ~= nil then
		DrawMarker(type, x, y, z - 0.5, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, range, range, 2.0, 3, 252, 28, 60, false, true, 2, nil, nil, false)
	end
end

--Voice End

-- Clock
function CalculateTimeToDisplay()
	if month <= 9 then
		month = 0 .. month
	end
	if dayOfWeek <= 9 then
		dayOfWeek = 0 .. dayOfWeek
	end
	if hour <= 9 then
		hour = 0 .. hour
	end
	if minute <= 9 then
		minute = 0 .. minute
	end

	if secound <= 9 then
		secound = 0 .. secound
	end
end

CreateThread(function()
	while true do
		Wait(1000)
		year, month, dayOfWeek, hour, minute, secound = GetLocalTime()
		timeString = ""
		dateString = ""
		CalculateTimeToDisplay()

		dateString = "" .. dayOfWeek .. "." .. month .. "." .. year .. ""
		timeString = "" .. hour + 2 .. ":" .. minute .. ":" .. secound .. ""


		SendNUIMessage({action = "setValue", key = "date", value = dateString})
		SendNUIMessage({action = "setValue", key = "time", value = timeString})
	end
end)
--Clock end

-- Postal Code
CreateThread(function()
	local ped = PlayerPedId()
	while true do
		local nearest = nil
	
		local playerCoords = GetEntityCoords(ped)
	
		local ndm = -1
		local ni = -1
		for i, p in ipairs(postals) do
			local dm = (playerCoords.x - p.x) ^ 2 + (playerCoords.y - p.y) ^ 2
			if ndm == -1 or dm < ndm then
				ni = i
				ndm = dm
			end
		end
	
		if ni ~= -1 then
			local nd = math.sqrt(ndm)
			nearest = {i = ni, d = nd}
		end
		_nearest = postals[nearest.i].code
		SendNUIMessage({action = "setValue", key = "postal", value = "PLZ-".._nearest})
		Wait(1000)
	end
end)
--Postal Code End


CreateThread(function()
    while true do
        Wait(500)
		SendNUIMessage({action = "updateStatus2", health = (GetEntityHealth(GetPlayerPed(-1))-100), armor = GetPedArmour(GetPlayerPed(-1))})
    end
end)