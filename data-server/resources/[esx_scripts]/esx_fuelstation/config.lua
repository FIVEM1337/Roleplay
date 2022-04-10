Config = {}

Config.RefillCost = 50

Config.ShowNearestGasStationOnly = true
Config.ShowAllGasStations = false

Config.JerryCanMaxFuel = 20 

Config.Price = 5.00 --Price per Liters
Config.FillPerTick = 1.4 -- liters per second from pump

Config.DisableKeys = {0, 22, 23, 24, 29, 30, 31, 37, 44, 56, 82, 140, 166, 167, 168, 170, 288, 289, 311, 323}

-- Fuel decor - No need to change this, just leave it.
Config.FuelDecor = "_FUEL_LEVEL"

Config.PumpModels = {
	[-2007231801] = true,
	[1339433404] = true,
	[1694452750] = true,
	[1933174915] = true,
	[-462817101] = true,
	[-469694731] = true,
	[-164877493] = true
}

Config.FuelClassesMax = {
	[0] = 100.0, -- Compacts
	[1] = 100.0, -- Sedans
	[2] = 100.0, -- SUVs
	[3] = 100.0, -- Coupes
	[4] = 100.0, -- Muscle
	[5] = 100.0, -- Sports Classics
	[6] = 100.0, -- Sports
	[7] = 100.0, -- Super
	[8] = 100.0, -- Motorcycles
	[9] = 100.0, -- Off-road
	[10] = 100.0, -- Industrial
	[11] = 100.0, -- Utility
	[12] = 100.0, -- Vans
	[13] = 0.0, -- Cycles
	[14] = 100.0, -- boats
	[15] = 100.0, -- Helicopters
	[16] = 100.0, -- Planes
	[17] = 100.0, -- Service
	[18] = 100.0, -- Emergency
	[19] = 100.0, -- Military
	[20] = 100.0, -- Commercial
	[21] = 100.0, -- Trains
}

-- The left part is at percentage RPM, and the right is how much fuel (divided by 10) you want to remove from the tank every second
Config.FuelUsage = {
	[1.0] = 1.4,
	[0.9] = 1.2,
	[0.8] = 1.0,
	[0.7] = 0.9,
	[0.6] = 0.8,
	[0.5] = 0.7,
	[0.4] = 0.5,
	[0.3] = 0.4,
	[0.2] = 0.2,
	[0.1] = 0.1,
	[0.0] = 0.0,
}

Config.Classes = {
	[0] = 1.0, -- Compacts
	[1] = 1.0, -- Sedans
	[2] = 1.0, -- SUVs
	[3] = 1.0, -- Coupes
	[4] = 1.0, -- Muscle
	[5] = 1.0, -- Sports Classics
	[6] = 1.0, -- Sports
	[7] = 1.0, -- Super
	[8] = 1.0, -- Motorcycles
	[9] = 1.0, -- Off-road
	[10] = 1.0, -- Industrial
	[11] = 1.0, -- Utility
	[12] = 1.0, -- Vans
	[13] = 0.0, -- Cycles
	[14] = 1.0, -- boats
	[15] = 1.0, -- Helicopters
	[16] = 1.0, -- Planes
	[17] = 1.0, -- Service
	[18] = 1.0, -- Emergency
	[19] = 1.0, -- Military
	[20] = 1.0, -- Commercial
	[21] = 1.0, -- Trains
}


Config.GasStations = {

	{blipname = "Tankstelle", coords =  vector3(49.4187, 2778.793, 58.043), allowed_type = "car"},
	{blipname = "Tankstelle", coords =  vector3(263.894, 2606.463, 44.983), allowed_type = "car"},
	{blipname = "Tankstelle", coords =  vector3(1039.958, 2671.134, 39.550), allowed_type = "car"},
	{blipname = "Tankstelle", coords =  vector3(1207.260, 2660.175, 37.899), allowed_type = "car"},
	{blipname = "Tankstelle", coords =  vector3(2539.685, 2594.192, 37.944), allowed_type = "car"},
	{blipname = "Tankstelle", coords =  vector3(2679.858, 3263.946, 55.240), allowed_type = "car"},
	{blipname = "Tankstelle", coords =  vector3(2005.055, 3773.887, 32.403), allowed_type = "car"},
	{blipname = "Tankstelle", coords =  vector3(1687.156, 4929.392, 42.078), allowed_type = "car"},
	{blipname = "Tankstelle", coords =  vector3(1701.314, 6416.028, 32.763), allowed_type = "car"},
	{blipname = "Tankstelle", coords =  vector3(179.857, 6602.839, 31.868), allowed_type = "car"},
	{blipname = "Tankstelle", coords =  vector3(-94.4619, 6419.594, 31.489), allowed_type = "car"},
	{blipname = "Tankstelle", coords =  vector3(-2554.996, 2334.40, 33.078), allowed_type = "car"},
	{blipname = "Tankstelle", coords =  vector3(-1800.375, 803.661, 138.651), allowed_type = "car"},
	{blipname = "Tankstelle", coords =  vector3(-1437.622, -276.747, 46.207), allowed_type = "car"},
	{blipname = "Tankstelle", coords =  vector3(-2096.243, -320.286, 13.168), allowed_type = "car"},
	{blipname = "Tankstelle", coords =  vector3(-724.619, -935.1631, 19.213), allowed_type = "car"},
	{blipname = "Tankstelle", coords =  vector3(-526.019, -1211.003, 18.184), allowed_type = "car"},
	{blipname = "Tankstelle", coords =  vector3(-70.2148, -1761.792, 29.534), allowed_type = "car"},
	{blipname = "Tankstelle", coords =  vector3(265.648, -1261.309, 29.292), allowed_type = "car"},
	{blipname = "Tankstelle", coords =  vector3(819.653, -1028.846, 26.403), allowed_type = "car"},
	{blipname = "Tankstelle", coords =  vector3(1208.951, -1402.567,35.224), allowed_type = "car"},
	{blipname = "Tankstelle", coords =  vector3(1181.381, -330.847, 69.316), allowed_type = "car"},
	{blipname = "Tankstelle", coords =  vector3(620.843, 269.100, 103.089), allowed_type = "car"},
	{blipname = "Tankstelle", coords =  vector3(2581.321, 362.039, 108.468), allowed_type = "car"},
	{blipname = "Tankstelle", coords =  vector3(176.631, -1562.025, 29.263), allowed_type = "car"},
	{blipname = "Tankstelle", coords =  vector3(176.631, -1562.025, 29.263), allowed_type = "car"},
	{blipname = "Tankstelle", coords =  vector3(-319.292, -1471.715, 30.549), allowed_type = "car"},
	{blipname = "Tankstelle", coords =  vector3(1784.324, 3330.55, 41.253), allowed_type = "aircraft"},
	{blipname = "Tankstelle (Flugzeug)", coords = vector3(-1031.8656005859,-3023.1201171875,13.94438457489), allowed_type = "aircraft"},
	{blipname = "Tankstelle (Flugzeug)", coords = vector3(1592.3149414063,3172.5358886719,40.533790588379), allowed_type = "aircraft"},
	{blipname = "Tankstelle (Flugzeug)", coords = vector3(-2058.3647460938,2849.6594238281,32.810401916504), allowed_type = "aircraft"},
	{blipname = "Tankstelle (Boote)", coords = vector3(11.903608322144,-2800.8916015625,2.5259504318237), allowed_type = "boat"},
}
