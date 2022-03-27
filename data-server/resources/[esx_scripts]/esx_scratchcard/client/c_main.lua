local cooldown = 0

RegisterNetEvent("esx_scratchcard:isActiveCooldown", function()
	TriggerServerEvent("esx_scratchcard:handler", cooldown > 0 and true or false, cooldown)
end)

RegisterNetEvent("esx_scratchcard:setCooldown", function()
  cooldown = Config.ScratchCooldownInSeconds
	CreateThread(function()
		while (cooldown ~= 0) do
			Wait(1000)
			cooldown = cooldown - 1
		end
	end)
end)

RegisterNetEvent("esx_scratchcard:startScratchingEmote", function()
	TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_PARKING_METER", 0, true)
end)

RegisterNetEvent("esx_scratchcard:stopScratchingEmote", function()
	ClearPedTasksImmediately(PlayerPedId())
end)

RegisterNUICallback('deposit', function(data)
	TriggerServerEvent('esx_scratchcard:deposit', data.key, data.price, data.amount, data.type)
end)