ESX = nil
local isTalking = false
local isMuted = false
local currentRange = 3.5

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer) 
	TriggerEvent("playerhud:LoadPlayerData", xPlayer)
end)

RegisterNetEvent("reload_playerhud") 
AddEventHandler("reload_playerhud", function(xPlayer)
	TriggerEvent("playerhud:LoadPlayerData", xPlayer)
end)

RegisterNetEvent("playerhud:LoadPlayerData") 
AddEventHandler("playerhud:LoadPlayerData", function(xPlayer)
	local data = xPlayer
	local accounts = data.accounts
	for k,v in pairs(accounts) do
		local account = v
		if account.name == "money" then
			SendNUIMessage({action = "setValue", key = "money", value = "$"..account.money})
		elseif account.name == "bank" then
			SendNUIMessage({action = "setValue", key = "bankmoney", value = "$"..account.money})
		elseif account.name == "black_money" then
			SendNUIMessage({action = "setValue", key = "dirtymoney", value = "$"..account.money})
		end
	end

	-- Job
	local job = data.job
	SendNUIMessage({action = "setValue", key = "job", value = job.label.." - "..job.grade_label, icon = job.name})

	-- Player ID
	SendNUIMessage({action = "setValue", key = "player_id", value = "Deine ID: "..xPlayer.source})
end)


RegisterNetEvent('ui:toggle')
AddEventHandler('ui:toggle', function(show)
	SendNUIMessage({action = "toggle", show = show})
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	if account.name == "money" then
		SendNUIMessage({action = "setValue", key = "money", value = "$"..account.money})
	elseif account.name == "bank" then
		SendNUIMessage({action = "setValue", key = "bankmoney", value = "$"..account.money})
	elseif account.name == "black_money" then
		SendNUIMessage({action = "setValue", key = "dirtymoney", value = "$"..account.money})
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  SendNUIMessage({action = "setValue", key = "job", value = job.label.." - "..job.grade_label, icon = job.name})
end)

RegisterNetEvent('playerhud:updateStatus')
AddEventHandler('playerhud:updateStatus', function(status)
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


AddEventHandler("SaltyChat_VoiceRangeChanged", function(range)
	currentRange = range

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

AddEventHandler("SaltyChat_MicStateChanged", function(muted)
	isMuted = muted

	if isMuted then
		SendNUIMessage({action = "setVoiceRange", range = exports.saltychat:GetVoiceRange(), muted = true})
	else
		SendNUIMessage({action = "setVoiceRange", range = exports.saltychat:GetVoiceRange(), muted = false})
	end

end)