local standardVolumeOutput = 0.3;
local hasPlayerLoaded = true


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    hasPlayerLoaded = true
end)

RegisterNetEvent('InteractSound_CL:PlayOnOne', function(soundFile, soundVolume)
    if hasPlayerLoaded then
        SendNUIMessage({
            transactionType = 'playSound',
            transactionFile  = soundFile,
            transactionVolume = soundVolume
        })
    end
end)

RegisterNetEvent('InteractSound_CL:PlayOnAll', function(soundFile, soundVolume)
    if hasPlayerLoaded then
        SendNUIMessage({
            transactionType = 'playSound',
            transactionFile = soundFile,
            transactionVolume = soundVolume or standardVolumeOutput
        })
    end
end)

RegisterNetEvent('InteractSound_CL:PlayWithinDistance', function(otherPlayerCoords, maxDistance, soundFile, soundVolume)
	if hasPlayerLoaded then
		local myCoords = GetEntityCoords(PlayerPedId())
		local distance = #(myCoords - otherPlayerCoords)

		if distance < maxDistance then
			SendNUIMessage({
				transactionType = 'playSound',
				transactionFile  = soundFile,
				transactionVolume = soundVolume or standardVolumeOutput
			})
		end
	end
end)

RegisterNetEvent('InteractSound_CL:PlayOnCoord', function(coords, maxDistance, soundFile, soundVolume)
	if hasPlayerLoaded then
		local myCoords = GetEntityCoords(PlayerPedId())
		local distance = GetDistanceBetweenCoords(myCoords, coords)
		local volume = soundVolume - 1 * (distance - 1) / (maxDistance - 1)
		
		if distance < maxDistance then
			SendNUIMessage({
				transactionType = 'playSound',
				transactionFile  = soundFile,
				transactionVolume = volume or standardVolumeOutput
			})
		end
	end
end)

