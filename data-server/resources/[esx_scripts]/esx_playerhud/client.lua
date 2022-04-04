ESX = nil
local isTalking = false
local isMuted = false
local currentRange = 3.5

local markerOn = false
local markerTimer = 0
local show = false
local Spawned = false




function GetMinimapAnchor()
    -- Safezone goes from 1.0 (no gap) to 0.9 (5% gap (1/20))
    -- 0.05 * ((safezone - 0.9) * 10)
    local safezone = GetSafeZoneSize()
    local safezone_x = 1.0 / 20.0
    local safezone_y = 1.0 / 20.0
    local aspect_ratio = GetAspectRatio(0)
    local res_x, res_y = GetActiveScreenResolution()
    local xscale = 1.0 / res_x
    local yscale = 1.0 / res_y
    local Minimap = {}
    Minimap.width = xscale * (res_x / (4 * aspect_ratio))
    Minimap.height = yscale * (res_y / 5.674)
    Minimap.left_x = xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.bottom_y = 1.0 - yscale * (res_y * (safezone_y * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.right_x = Minimap.left_x + Minimap.width
    Minimap.top_y = Minimap.bottom_y - Minimap.height
    Minimap.x = Minimap.left_x
    Minimap.y = Minimap.top_y
    Minimap.xunit = xscale
    Minimap.yunit = yscale
    return Minimap
end

local hasMinimapChanged = false

function UpdateMinimapLocation()
  CreateThread(function()
    -- Get screen aspect ratio
    local ratio = GetScreenAspectRatio()

    -- Default values for 16:9 monitors
    local posX = -0.0045
    local posY = 0.002

	print(tonumber(string.format("%.2f", ratio)))

    if tonumber(string.format("%.2f", ratio)) >= 2.3 then
      -- Ultra wide 3440 x 1440 (2.39)
      -- Ultra wide 5120 x 2160 (2.37)
      posX = -0.185
      posY = 0.00
      print('Detected ultra-wide monitor, adjusted minimap')
    else 
      posX = -0.0045
      posY = 0.002
	  
    end

	SetMinimapComponentPosition('minimap', 'L', 'B', posX, posY, 0.150, 0.188888)
	SetMinimapComponentPosition('minimap_mask', 'L', 'B', posX + 0.0155, posY + 0.03, 0.111, 0.159)
	SetMinimapComponentPosition('minimap_blur', 'L', 'B', posX - 0.0255, posY + 0.02, 0.266, 0.237)

    SetRadarBigmapEnabled(true, false)
    Wait(1000)
    SetRadarBigmapEnabled(false, false)
  end)
end

RegisterCommand('reload-map', function(src, args)
  UpdateMinimapLocation()
end, false)

UpdateMinimapLocation()



CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(0)
	end

	while true do
		Wait(100)
		if Spawned then
			if IsPauseMenuActive() then
				if show then
					SendNUIMessage({action = "toggle", show = false})
					show = false
				end
			else
				if not show then
					SendNUIMessage({action = "toggle", show = true})
					show = true
				end
			end
		end
	end
end)


-- Disable Cinematic AFK Camera
CreateThread(function()
	while true do
		InvalidateIdleCam()
		InvalidateVehicleIdleCam()
		Wait(1000)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer) 
	TriggerEvent("esx_playerhud:LoadPlayerDataHUD", xPlayer)
	SendNUIMessage({action = "toggle", show = true})
	show = true
	Spawned = true
end)

RegisterNetEvent("reload_esx_playerhud") 
AddEventHandler("reload_esx_playerhud", function(xPlayer)
	TriggerEvent("esx_playerhud:LoadPlayerDataHUD", xPlayer)
end)

RegisterNetEvent("esx_playerhud:LoadPlayerDataHUD") 
AddEventHandler("esx_playerhud:LoadPlayerDataHUD", function(xPlayer)
	local data = xPlayer
	local accounts = data.accounts
	for k,v in pairs(accounts) do
		local account = v
		if account.name == "money" then
			SendNUIMessage({action = "setValue", key = "money", value = "$"..ESX.Math.GroupDigits(account.money)})
		elseif account.name == "bank" then
			SendNUIMessage({action = "setValue", key = "bankmoney", value = "$"..ESX.Math.GroupDigits(account.money)})
		elseif account.name == "black_money" then
			SendNUIMessage({action = "setValue", key = "dirtymoney", value = "$"..ESX.Math.GroupDigits(account.money)})
		elseif account.name == "crypto" then
			SendNUIMessage({action = "setValue", key = "cryptomoney", value = ESX.Math.GroupDigits(account.money) .." BTC"})
		end
	end
	-- Job
	local job = data.job
	SendNUIMessage({action = "setValue", key = "job", value = job.label.." - "..job.grade_label, icon = job.name})

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

CreateThread(function()
	while true do
		Wait(1000)
		location = getPlayerLocation()
		SendNUIMessage({action = "setValue", key = "postal", value = location})
	end
end)


RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	if account.name == "money" then
		SendNUIMessage({action = "setValue", key = "money", value = "$"..ESX.Math.GroupDigits(account.money)})
	elseif account.name == "bank" then
		SendNUIMessage({action = "setValue", key = "bankmoney", value = "$"..ESX.Math.GroupDigits(account.money)})
	elseif account.name == "black_money" then
		SendNUIMessage({action = "setValue", key = "dirtymoney", value = "$"..ESX.Math.GroupDigits(account.money)})
	elseif account.name == "crypto" then
		SendNUIMessage({action = "setValue", key = "cryptomoney", value = ESX.Math.GroupDigits(account.money) .." BTC"})
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


AddEventHandler("SaltyChat_VoiceRangeChanged", function(range)
	currentRange = range

	MarkerTimer()
	SendNUIMessage({action = "setVoiceRange", range = range, muted = isMuted})
end)

AddEventHandler("SaltyChat_TalkStateChanged", function(talking)
	isTalking = talking

    if isTalking then
        SendNUIMessage({action = "setTalking", value = true})
    else
        SendNUIMessage({action = "setTalking", value = false})
    end

end)

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

AddEventHandler("SaltyChat_MicStateChanged", function(muted)
	isMuted = muted

	if isMuted then
		SendNUIMessage({action = "setVoiceRange", range = exports.saltychat:GetVoiceRange(), muted = true})
	else
		SendNUIMessage({action = "setVoiceRange", range = exports.saltychat:GetVoiceRange(), muted = false})
	end

end)

AddEventHandler('onResourceStart', function(resource)
	SendNUIMessage({action = "toggle", show = true})
end)


function getPlayerLocation()
    local raw = LoadResourceFile(GetCurrentResourceName(), "json/postals.json")
    local postals = json.decode(raw)
    local nearest = nil


    local ped = PlayerPedId()
    local playerCoords = GetEntityCoords(ped)

    local x, y = table.unpack(playerCoords)

	local ndm = -1
	local ni = -1
	for i, p in ipairs(postals) do
		local dm = (x - p.x) ^ 2 + (y - p.y) ^ 2
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
	return _nearest
end