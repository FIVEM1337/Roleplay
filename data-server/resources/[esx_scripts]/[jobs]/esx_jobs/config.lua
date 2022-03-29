Config                            = {}
Config.Locale = 'de'

Config.DrawDistance               = 20.0
Config.MarkerType                 = 1
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 0.5 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }


Config.EarlyRespawnTimer          = 1000  -- time til respawn is available
Config.BleedoutTimer              = 200000 -- time til the player bleeds out
Config.RespawnPoint = {coords = vector3(-458.89, -283.25, 34.91), heading = 70.69}
Config.EarlyRespawnFineAmount     = 5000
Config.RemoveWeaponsAfterRPDeath  = true
Config.RemoveCashAfterRPDeath     = true
Config.RemoveItemsAfterRPDeath    = true
Config.ReviveReward				  = 200

--[[ 
functions for jobmenu:

citizen_interaction:
	identity_card
	body_search
	handcuff
	drag
	put_in_vehicle
	out_the_vehicle
	fine
	unpaid_bills

vehicle_interaction:
	vehicle_infos
	hijack_vehicle
	search_database
	vehicle_interaction

--]]



jobs = {
	police = {
			job = "police",
			society = true,
			Blip = {name = "Polizeistation", color = 2, sprite = 543, scale = 0.8, alwayshow = true},
			pos = vector3(106.15, -1941.8, 20.80),
			armory = vector3(432.42, -1023.84, 28.68),
			boss = vector3(437.42, -1023.84, 28.68),
			cloak = vector3(-1342, -1279.84, 4.82),
			identity_card = true,
			body_search = true,
			handcuff = true,
			drag = true,
			put_in_vehicle = true,
			out_the_vehicle = true,
			fine = true,
			unpaid_bills = true,
			vehicle_infos = true,
			hijack_vehicle = true,
			search_database = true,
			vehicle_interaction = true,
			ems_menu_revive = true,
			ems_menu_small = true,
			ems_menu_big = true,
			fix_vehicle = true,
			clean_vehicle = true,
			billing = true,
		},


	grove = {
			job = "grove",
			Blip = {name = "Grove", color = 2, sprite = 543, scale = 0.8},
			pos = vector3(106.15, -1941.8, 20.80),
			armory = vector3(92.25, -1962.90, 20.94),
			boss = vector3(90.25, -1960.90, 20.94),
			identity_card = true,
			body_search = true,
			handcuff = true,
			drag = true,
			put_in_vehicle = true,
			out_the_vehicle = true,
			fine = true,
			unpaid_bills = true,
			vehicle_infos = true,
			hijack_vehicle = true,
			search_database = true,
			vehicle_interaction = true
		},
	bloods = {
			job = "bloods",
			Blip = {name = "Bloods", color = 1, sprite = 543, scale = 0.8},
			pos = vector3(-1573.30, -281.20, 48.28),
			armory = vector3(-1560.36, -274.18, 48.28),
			boss = vector3(-1562.31, -272.42, 48.28)
		},
	vagos= {
			job = "vagos",
			Blip = {name = "Vagos", color = 5, sprite = 543, scale = 0.8},
			pos = vector3(-1136.13, -1578.90, 4.43),
			armory = vector3(-1128.16, -1614.16, 4.40),
			boss = vector3(-1130.35, -1611.62, 4.40)
		},
	lost = {
			job = "lost",
			Blip = {name = "Lost", color = 40, sprite = 543, scale = 0.8},
			pos = vector3(2001.25, 3065.75, 47.05),
			armory = vector3(1999.20, 3030.68, 47.03),
			boss = vector3(1995.10, 3024.32, 47.06)
		},
	yakuza = {
			job = "yakuza",
			Blip = {name = "Yakuza", color = 1, sprite = 543, scale = 0.8},
			pos = vector3(-1473.55, 884.63, 182.95),
			armory = vector3(-1530.50, 832.00, 181.60),
			boss = vector3(-1529.00, 828.75, 181.60)
		},
	ballas = {
			job = "ballas",
			Blip = {name = "Ballas", color = 83, sprite = 543, scale = 0.8},
			pos = vector3(1365.05, -578.95, 74.35),
			armory = vector3(1342.75, -610.35, 74.40),
			boss = vector3(1344.90, -611.75, 74.40)
		},
	marabunta = {
			job = "marabunta",
			Blip = {name = "Marabunta", color = 84, sprite = 543, scale = 0.8},
			pos = vector3(1201.25, -1758.57, 39.20),
			armory = vector3(1196.17, -1769.35, 39.50),
			boss = vector3(1193.26, -1766.98, 39.46)
		},
	midnight = {
			job = "midnight",
			Blip = {name = "Midnight", color = 45, sprite = 543, scale = 0.8},
			pos = vector3(-183.43, -1300.60, 30.60),
			armory = vector3(-152.77, -1302.90, 31.30),
			boss = vector3(-152.72, -1308.38, 31.30)
		}
}