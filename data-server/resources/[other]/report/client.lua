Citizen.CreateThread(function()
	Wait(1000)
	TriggerServerEvent("reports:FetchFeedbackTable")
end)

-------------------------- VARS

local oneSync = false
local staff = false
local FeedbackTable = {}
local canFeedback = true
local timeLeft = Config.FeedbackCooldown

-------------------------- COMMANDS

RegisterCommand(Config.FeedbackClientCommand, function(source, args, rawCommand)
	if canFeedback then
		FeedbackMenu(false)
	else
		FeedbackMenu(false)
		TriggerEvent('dopeNotify:Alert', "Support", "DU kannst noch keine Support anfrage stellen!", 10000, 'error')
	end
end, false)

RegisterCommand(Config.FeedbackAdminCommand, function(source, args, rawCommand)
	if staff then
		FeedbackMenu(true)
	end
end, false)

-------------------------- MENU

function FeedbackMenu(showAdminMenu)
	SetNuiFocus(true, true)
	if showAdminMenu then
		SendNUIMessage({
			action = "updateFeedback",
			FeedbackTable = FeedbackTable
		})
		SendNUIMessage({
			action = "OpenAdminFeedback",
		})
	else
		SendNUIMessage({
			action = "ClientFeedback",
		})
	end
end

-------------------------- EVENTS

RegisterNetEvent('reports:NewFeedback')
AddEventHandler('reports:NewFeedback', function(newFeedback)
	if staff then
		FeedbackTable[#FeedbackTable+1] = newFeedback
		TriggerEvent('dopeNotify:Alert', "Support", "Es liegt eine Support anfrage vor!", 10000, 'info')
		SendNUIMessage({
			action = "updateFeedback",
			FeedbackTable = FeedbackTable
		})
	end
end)

RegisterNetEvent('reports:FetchFeedbackTable')
AddEventHandler('reports:FetchFeedbackTable', function(feedback, admin, oneS)
	FeedbackTable = feedback
	staff = admin
	oneSync = oneS
end)

RegisterNetEvent('reports:FeedbackConclude')
AddEventHandler('reports:FeedbackConclude', function(feedbackID, info)
	local feedbackid = FeedbackTable[feedbackID]
	feedbackid.concluded = info

	SendNUIMessage({
		action = "updateFeedback",
		FeedbackTable = FeedbackTable
	})
end)

-------------------------- ACTIONS

RegisterNUICallback("action", function(data)
	if data.action ~= "concludeFeedback" then
		SetNuiFocus(false, false)
	end

	if data.action == "newFeedback" then
		TriggerEvent('dopeNotify:Alert', "Support", "Support wurde abgesendet!", 10000, 'success')
		
		local feedbackInfo = {subject = data.subject, information = data.information, category = data.category}
		TriggerServerEvent("reports:NewFeedback", feedbackInfo)

		local time = Config.FeedbackCooldown * 60
		local pastTime = 0
		canFeedback = false

		while (time > pastTime) do
			Citizen.Wait(1000)
			pastTime = pastTime + 1
			timeLeft = time - pastTime
		end
		canFeedback = true
	elseif data.action == "assistFeedback" then
		if FeedbackTable[data.feedbackid] then
			if oneSync then
				TriggerServerEvent("reports:AssistFeedback", data.feedbackid, true)
			else
				local playerFeedbackID = FeedbackTable[data.feedbackid].playerid
				local playerID = GetPlayerFromServerId(playerFeedbackID)
				local playerOnline = NetworkIsPlayerActive(playerID)
				if playerOnline then
					SetEntityCoords(PlayerPedId(), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerFeedbackID))))
					TriggerServerEvent("reports:AssistFeedback", data.feedbackid, true)
				else
					TriggerEvent('dopeNotify:Alert', "Support", "Dieser Spieler ist nicht mehr auf dem Server!", 10000, 'error')
				end
			end
		end
	elseif data.action == "concludeFeedback" then
		local feedbackID = data.feedbackid
		local canConclude = data.canConclude
		local feedbackInfo = FeedbackTable[feedbackID]
		if feedbackInfo then
			if feedbackInfo.concluded ~= true or canConclude then
				TriggerServerEvent("reports:FeedbackConclude", feedbackID, canConclude)
				TriggerEvent('dopeNotify:Alert', "Support", "Anfrage #"..feedbackID.." abgeschlossen!", 10000, 'success')
			end
		end
	end
end)