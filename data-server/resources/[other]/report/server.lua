local oneSync = false
ESX = nil

Citizen.CreateThread(function()
	if GetConvar("onesync") ~= 'off' then
		oneSync = true
	end
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj; end)
end)

-------------------------- VARS
local staffs = {}
local FeedbackTable = {}

-------------------------- NEW FEEDBACK

RegisterNetEvent("reports:NewFeedback")
AddEventHandler("reports:NewFeedback", function(data)
	local identifierlist = ExtractIdentifiers(source)
	local newFeedback = {
		feedbackid = #FeedbackTable+1,
		playerid = source,
		identifier = identifierlist.license:gsub("license2:", ""),
		subject = data.subject,
		information = data.information,
		category = data.category,
		concluded = false,
		discord = "<@"..identifierlist.discord:gsub("discord:", "")..">"
	}

	FeedbackTable[#FeedbackTable+1] = newFeedback

	TriggerClientEvent("reports:NewFeedback", -1, newFeedback)

end)

-------------------------- FETCH FEEDBACK

RegisterNetEvent("reports:FetchFeedbackTable")
AddEventHandler("reports:FetchFeedbackTable", function()
	local staff = hasPermission(source)
	if staff then
		staffs[source] = true
		TriggerClientEvent("reports:FetchFeedbackTable", source, FeedbackTable, staff, oneSync)
	end
end)

-------------------------- ASSIST FEEDBACK

RegisterNetEvent("reports:AssistFeedback")
AddEventHandler("reports:AssistFeedback", function(feedbackId, canAssist)
	if staffs[source] then
		if canAssist then
			local id = FeedbackTable[feedbackId].playerid
			if GetPlayerPing(id) > 0 then
				local ped = GetPlayerPed(id)
				local playerCoords = GetEntityCoords(ped)
				local pedSource = GetPlayerPed(source)
				local identifierlist = ExtractIdentifiers(source)
				local assistFeedback = {
					feedbackid = feedbackId,
					discord = "<@"..identifierlist.discord:gsub("discord:", "")..">"
				}

				SetEntityCoords(pedSource, playerCoords.x, playerCoords.y, playerCoords.z)
				TriggerClientEvent('dopeNotify:Alert', id , "Support", "Ein Admin ist angekommen!", 10000, 'success')

			else
				TriggerClientEvent('dopeNotify:Alert', id , "Support", "Dieser Spieler ist nicht mehr auf dem Server!", 10000, 'success')
			end
			if not FeedbackTable[feedbackId].concluded then
				FeedbackTable[feedbackId].concluded = "assisting"
			end
			TriggerClientEvent("reports:FeedbackConclude", -1, feedbackId, FeedbackTable[feedbackId].concluded)
		end
	end
end)

-------------------------- CONCLUDE FEEDBACK

RegisterNetEvent("reports:FeedbackConclude")
AddEventHandler("reports:FeedbackConclude", function(feedbackId, canConclude)
	if staffs[source] then
		local feedback = FeedbackTable[feedbackId]
		local identifierlist = ExtractIdentifiers(source)
		local concludeFeedback = {
			feedbackid = feedbackId,
			discord = "<@"..identifierlist.discord:gsub("discord:", "")..">"
		}

		if feedback then
			if feedback.concluded ~= true or canConclude then
				if canConclude then
					if FeedbackTable[feedbackId].concluded == true then
						FeedbackTable[feedbackId].concluded = false
					else
						FeedbackTable[feedbackId].concluded = true
					end
				else
					FeedbackTable[feedbackId].concluded = true
				end
				TriggerClientEvent("reports:FeedbackConclude", -1, feedbackId, FeedbackTable[feedbackId].concluded)

			end
		end
	end
end)

-------------------------- HAS PERMISSION

function hasPermission(id)
	local staff = false
	local player = ESX.GetPlayerFromId(id)
	local playerGroup = player.getGroup()

	if playerGroup ~= nil and playerGroup == "superadmin" or playerGroup == "admin" or playerGroup == "mod" then 
		staff = true
	end

	return staff
end

-------------------------- IDENTIFIERS

function ExtractIdentifiers(id)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(id) - 1 do
        local playerID = GetPlayerIdentifier(id, i)

        if string.find(playerID, "steam") then
            identifiers.steam = playerID
        elseif string.find(playerID, "ip") then
            identifiers.ip = playerID
        elseif string.find(playerID, "discord") then
            identifiers.discord = playerID
        elseif string.find(playerID, "license") then
            identifiers.license = playerID
        elseif string.find(playerID, "xbl") then
            identifiers.xbl = playerID
        elseif string.find(playerID, "live") then
            identifiers.live = playerID
        end
    end

    return identifiers
end