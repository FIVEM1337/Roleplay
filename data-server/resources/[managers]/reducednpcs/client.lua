-- Density values from 0.0 to 1.0.
DensityMultiplier = 0.0
-- NPC Control
CreateThread(function()
	while true do
		Wait(0) 
        SetVehicleDensityMultiplierThisFrame(DensityMultiplier) -- Traffic Density
		SetPedDensityMultiplierThisFrame(DensityMultiplier) -- NPC Density
		SetRandomVehicleDensityMultiplierThisFrame(DensityMultiplier) -- Random Vehicle Density
		SetParkedVehicleDensityMultiplierThisFrame(DensityMultiplier) -- Parked Density
		SetScenarioPedDensityMultiplierThisFrame(DensityMultiplier, DensityMultiplier) -- Walking NPC Density
		SetGarbageTrucks(false) -- Enable/Disable Garbage Trucks
		SetRandomBoats(false) -- Enable/Disable Boats
        SetCreateRandomCops(false) -- Enable/Disable Random Cops
		SetCreateRandomCopsNotOnScenarios(false) --- Enable/Disable Spawn Cops Off Scenarios
		SetCreateRandomCopsOnScenarios(false) -- Enable/Disable Spawn Cops On Scenarios
        local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
		ClearAreaOfVehicles(x, y, z, 1000, false, false, false, false, false)
		RemoveVehiclesFromGeneratorsInArea(x - 500.0, y - 500.0, z - 500.0, x + 500.0, y + 500.0, z + 500.0);
	 end
end)


-- Disable Dispatch
CreateThread(function()
	for i = 1, 15 do
		EnableDispatchService(i, false)
	 end
end)