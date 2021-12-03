RegisterNetEvent('esx_frakinvite:show')
AddEventHandler('esx_frakinvite:show', function(title, job)
    print(title)
    print(job)
    SendNUIMessage({
        title = title,
        job = job
    })

    SetNuiFocus(true, true)
end)

RegisterNUICallback('exit', function(data)
    SetNuiFocus(false, false)
    TriggerServerEvent("esx_frakinvite:deny", data.job)
	PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
end)


RegisterNUICallback('join', function(data, cb)
    TriggerServerEvent("esx_frakinvite:accept", data.job)
    SetNuiFocus(false, false)
	PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
end)
