ESX = nil
local isTalking = false
local isMuted = false
local currentRange = 3.5

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPauseMenuActive() then
			SendNUIMessage({action = "toggle", show = false})
		else
			SendNUIMessage({action = "toggle", show = true})
		end
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer) 
	TriggerEvent("esx_playerhud:LoadPlayerDataHUD", xPlayer)
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
			SendNUIMessage({action = "setValue", key = "money", value = "$"..account.money})
		elseif account.name == "bank" then
			SendNUIMessage({action = "setValue", key = "bankmoney", value = "$"..account.money})
		elseif account.name == "black_money" then
			SendNUIMessage({action = "setValue", key = "dirtymoney", value = "$"..account.money})
		elseif account.name == "crypto" then
			SendNUIMessage({action = "setValue", key = "cryptomoney", value = account.money .." BTC"})
		end
	end
	-- Job
	local job = data.job
	SendNUIMessage({action = "setValue", key = "job", value = job.label.." - "..job.grade_label, icon = job.name})

	-- Player ID
	SendNUIMessage({action = "setValue", key = "player_id", value = "Deine ID: "..GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1)))})


    TriggerEvent('esx_status:getStatusPercent', 'hunger', function(hunger) 
		currenthunger = hunger
    end)

    TriggerEvent('esx_status:getStatusPercent', 'thirst', function(thirst)
		currentthirst = thirst
    end)
	    
    TriggerEvent('esx_status:getStatusPercent', 'stress', function(stress)
		currentstress = stress
		print("heee")
    end)

	SendNUIMessage({action = "updateStatus", hunger = currenthunger, thirst = currentthirst, stress = currentstress})


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
	elseif account.name == "crypto" then
		SendNUIMessage({action = "setValue", key = "cryptomoney", value = account.money .." BTC"})
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  SendNUIMessage({action = "setValue", key = "job", value = job.label.." - "..job.grade_label, icon = job.name})
end)

RegisterNetEvent('esx_playerhud:updateStatus')
AddEventHandler('esx_playerhud:updateStatus', function(status)
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