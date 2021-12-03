ESX = nil

-- 	search in es_extended for:
--  userData.job.grade_salary = gradeObject.salary
--  add under this:
--  userData.job.can_invite = gradeObject.can_invite
--
--  search in es_extended for:
--  self.job.grade_salary = gradeObject.salary
--  add under this:
--  self.job.can_invite   = gradeObject.can_invite

Citizen.CreateThread(function()
	while ESX == nil do
			TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
			Citizen.Wait(0)
	end
end)

RegisterCommand("invite", function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(tonumber(args[1]))
	if xTarget == nil then
		TriggerClientEvent('dopeNotify:Alert', source, "FRAKTION", "Ungültige ID.", 5000, 'error')
	else
		if xPlayer.job.can_invite then 
			if xTarget.job.name == xPlayer.job.name then
				TriggerClientEvent('dopeNotify:Alert', source, "FRAKTION", "Dieser Spieler ist bereits in deiner Fraktion.", 5000, 'error')
			else
				TriggerClientEvent("esx_frakinvite:show", xTarget.source, xPlayer.job.label, xPlayer.job.name)
			end
		else
			TriggerClientEvent('dopeNotify:Alert', source, "FRAKTION", "Du hast dazu keine Rechte.", 5000, 'error')
		end
	end
end, false)

RegisterNetEvent("esx_frakinvite:accept")
AddEventHandler("esx_frakinvite:accept", function(data)
	local xTarget = ESX.GetPlayerFromId(source)

	xTarget.setJob(data, 0)

	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

			if xPlayer.job.name == data and xPlayer.job.can_invite then
					TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "FRAKTION", "Der Spieler " .. xTarget.name .. " hat die Einladung angenommen", 5000, 'success')
			end
	end
end)

RegisterNetEvent("esx_frakinvite:deny")
AddEventHandler("esx_frakinvite:deny", function(data)
	local xTarget = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

			if xPlayer.job.name == data and xPlayer.job.can_invite then
				TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "FRAKTION", "Der Spieler " .. xTarget.name .. " hat die Einladung abgelehnt", 5000, 'error')
			end
	end
end)