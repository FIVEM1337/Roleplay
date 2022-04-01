Config = {}

-- Are you using ESX? Turn this to true if you would like fuel & jerry cans to cost something.
Config.UseESX = true

-- What should the price of jerry cans be?
Config.JerryCanCost = 100
Config.RefillCost = 50 -- If it is missing half of it capacity, this amount will be divided in half, and so on.

-- Fuel decor - No need to change this, just leave it.
Config.FuelDecor = "_FUEL_LEVEL"

-- What keys are disabled while you're fueling.
Config.DisableKeys = {0, 22, 23, 24, 29, 30, 31, 37, 44, 56, 82, 140, 166, 167, 168, 170, 288, 289, 311, 323}

-- Want to use the HUD? Turn this to true.
Config.EnableHUD = fa

-- Configure blips here. Turn both to false to disable blips all together.
Config.ShowNearestGasStationOnly = false
Config.ShowAllGasStations = true

-- Modify the fuel-cost here, using a multiplier value. Setting the value to 2.0 would cause a doubled increase.
Config.CostMultiplier = 1.0

-- Configure the strings as you wish here.
Config.Strings = {
	ExitVehicle = "Verlasse das Fahrzeug, um zu tanken.",
	EToRefuel = "Drücke ~g~E~w~ um zu tanken.",
	JerryCanEmpty = "Benzinkanister ist leer",
	FullTank = "Der Tank ist voll",
	PurchaseJerryCan = "Drücke ~g~E~w~ um ein Benzinkanister für ~g~$" .. Config.JerryCanCost .." zu kaufen",
	CancelFuelingPump = "Drücke ~g~E~w~ um die Betankung abzubrechen",
	CancelFuelingJerryCan = "Drücke ~g~E ~w~um die Betankung abzubrechen",
	NotEnoughCash = "Du besitzt nicht genügend Geld.",
	RefillJerryCan = "Drücke ~g~E ~w~ zum Nachfüllen des Benzinkanister für ",
	NotEnoughCashJerryCan = "Nicht genug Geld, um den Benzinkanister nachzufüllen",
	JerryCanFull = "Benzinkanister ist voll",
	TotalCost = "Kosten",
}

if not Config.UseESX then
	Config.Strings.PurchaseJerryCan = "Drücke ~g~E~w~ einen Benzinkanister zu kaufen"
	Config.Strings.RefillJerryCan = "Drücke ~g~E~w~ um Benzinkanister zu befüllen"
end

Config.PumpModels = {
	[-2007231801] = true,
	[1339433404] = true,
	[1694452750] = true,
	[1933174915] = true,
	[-462817101] = true,
	[-469694731] = true,
	[-164877493] = true
}

-- Blacklist certain vehicles. Use names or hashes. https://wiki.gtanet.work/index.php?title=Vehicle_Models
Config.Blacklist = {
	--"Adder",
	--276773164
}

-- Do you want the HUD removed from showing in blacklisted vehicles?
Config.RemoveHUDForBlacklistedVehicle = true

-- Class multipliers. If you want SUVs to use less fuel, you can change it to anything under 1.0, and vise versa.

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

Config.GasStations = {

	{station_id = "Gasstation 1", name = "Tankstelle", name = "Tankstelle", coords =  vector3(49.4187, 2778.793, 58.043), allowedtypes = {'car'}},
	{station_id = "Gasstation 2", name = "Tankstelle", coords =  vector3(263.894, 2606.463, 44.983), allowedtypes = {'car'}},
	{station_id = "Gasstation 3", name = "Tankstelle", coords =  vector3(1039.958, 2671.134, 39.550), allowedtypes = {'car'}},
	{station_id = "Gasstation 4", name = "Tankstelle", coords =  vector3(1207.260, 2660.175, 37.899), allowedtypes = {'car'}},
	{station_id = "Gasstation 5", name = "Tankstelle", coords =  vector3(2539.685, 2594.192, 37.944), allowedtypes = {'car'}},
	{station_id = "Gasstation 6", name = "Tankstelle", coords =  vector3(2679.858, 3263.946, 55.240), allowedtypes = {'car'}},
	{station_id = "Gasstation 7", name = "Tankstelle", coords =  vector3(2005.055, 3773.887, 32.403), allowedtypes = {'car'}},
	{station_id = "Gasstation 8", name = "Tankstelle", coords =  vector3(1687.156, 4929.392, 42.078), allowedtypes = {'car'}},
	{station_id = "Gasstation 9", name = "Tankstelle", coords =  vector3(1701.314, 6416.028, 32.763), allowedtypes = {'car'}},
	{station_id = "Gasstation 10", name = "Tankstelle", coords =  vector3(179.857, 6602.839, 31.868), allowedtypes = {'car'}},
	{station_id = "Gasstation 11", name = "Tankstelle", coords =  vector3(-94.4619, 6419.594, 31.489), allowedtypes = {'car'}},
	{station_id = "Gasstation 12", name = "Tankstelle", coords =  vector3(-2554.996, 2334.40, 33.078), allowedtypes = {'car'}},
	{station_id = "Gasstation 13", name = "Tankstelle", coords =  vector3(-1800.375, 803.661, 138.651), allowedtypes = {'car'}},
	{station_id = "Gasstation 14", name = "Tankstelle", coords =  vector3(-1437.622, -276.747, 46.207), allowedtypes = {'car'}},
	{station_id = "Gasstation 15", name = "Tankstelle", coords =  vector3(-2096.243, -320.286, 13.168), allowedtypes = {'car'}},
	{station_id = "Gasstation 16", name = "Tankstelle", coords =  vector3(-724.619, -935.1631, 19.213), allowedtypes = {'car'}},
	{station_id = "Gasstation 17", name = "Tankstelle", coords =  vector3(-526.019, -1211.003, 18.184), allowedtypes = {'car'}},
	{station_id = "Gasstation 18", name = "Tankstelle", coords =  vector3(-70.2148, -1761.792, 29.534), allowedtypes = {'car'}},
	{station_id = "Gasstation 19", name = "Tankstelle", coords =  vector3(265.648, -1261.309, 29.292), allowedtypes = {'car'}},
	{station_id = "Gasstation 20", name = "Tankstelle", coords =  vector3(819.653, -1028.846, 26.403), allowedtypes = {'car'}},
	{station_id = "Gasstation 21", name = "Tankstelle", coords =  vector3(1208.951, -1402.567,35.224), allowedtypes = {'car'}},
	{station_id = "Gasstation 22", name = "Tankstelle", coords =  vector3(1181.381, -330.847, 69.316), allowedtypes = {'car'}},
	{station_id = "Gasstation 23", name = "Tankstelle", coords =  vector3(620.843, 269.100, 103.089), allowedtypes = {'car'}},
	{station_id = "Gasstation 24", name = "Tankstelle", coords =  vector3(2581.321, 362.039, 108.468), allowedtypes = {'car'}},
	{station_id = "Gasstation 25", name = "Tankstelle", coords =  vector3(176.631, -1562.025, 29.263), allowedtypes = {'car'}},
	{station_id = "Gasstation 26", name = "Tankstelle", coords =  vector3(176.631, -1562.025, 29.263), allowedtypes = {'car'}},
	{station_id = "Gasstation 27", name = "Tankstelle", coords =  vector3(-319.292, -1471.715, 30.549), allowedtypes = {'car'}},
	{station_id = "Gasstation 28", name = "Tankstelle", coords =  vector3(1784.324, 3330.55, 41.253), allowedtypes = {'car'}},
	{station_id = "Gasstation 28", name = "Tankstelle (Flugzeug)", coords = vector3(-994.85540771484,-2888.720703125,13.955413818359), allowedtypes = {'aircraft'}},
	{station_id = "Gasstation 28", name = "Tankstelle (Boote)", coords = vector3(-879.59161376953,-1418.8699951172,1.5953954458237), allowedtypes = {'boat'}},
}
