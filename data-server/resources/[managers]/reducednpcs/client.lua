-- Density values from 0.0 to 1.0.
DensityMultiplier = 0.0
Citizen.CreateThread(function()
	while true do
		SetVehicleDensityMultiplierThisFrame(DensityMultiplier)
		SetPedDensityMultiplierThisFrame(DensityMultiplier)
		SetRandomVehicleDensityMultiplierThisFrame(DensityMultiplier)
		SetParkedVehicleDensityMultiplierThisFrame(DensityMultiplier)
		SetScenarioPedDensityMultiplierThisFrame(DensityMultiplier, DensityMultiplier)
		
		local playerPed = PlayerPedId()
		local pos = GetEntityCoords(playerPed)
		RemoveVehiclesFromGeneratorsInArea(pos['x'] - 500.0, pos['y'] - 500.0, pos['z'] - 500.0, pos['x'] + 500.0, pos['y'] + 500.0, pos['z'] + 500.0);
		
		SetGarbageTrucks(0)
		SetRandomBoats(0)


		for i = 1, 12 do
			EnableDispatchService(i, false)
		end

		SetPlayerWantedLevel(PlayerId(), 0, false)
		SetPlayerWantedLevelNow(PlayerId(), false)
		SetPlayerWantedLevelNoDrop(PlayerId(), 0, false)
		
		Citizen.Wait(1)
	end
end)