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


jobs = {
	police = {
			job = "police",
			society = true,
			Blip = {name = "Polizeirevier", color = 29, sprite = 60, scale = 1.2, alwayshow = true},
			pos = vector3(456.88961791992,-1002.1945800781,30.721063613892),
			armory = {
				{coords = vector3(484.21737670898,-1005.8233032227,25.034621047974), store_weapon = true, store_items = true},
			},
			boss = {
				{coords = vector3(470.75274658203,-1005.5328979492,30.575220489502), min_grade = 1},
			},
			cloak = {
				{coords = vector3(473.35681152344,-987.79296875,25.034621047974)},
			},
			identity_card = true,
			body_search = true,
			handcuff = true,
			drag = true,
			put_in_vehicle = true,
			out_the_vehicle = true,
			unpaid_bills = true,
			vehicle_infos = true,
			hijack_vehicle = true,
			search_database = true,
			billing = true,
		},
		
	ambulance = {
			job = "ambulance",
			society = true,
			Blip = {name = "Krankenhaus", color = 2, sprite = 61, scale = 1.2, alwayshow = true},
			pos = vector3(-472.32846069336,-331.83459472656,35.202640533447),
			armory = {
				{coords = vector3(-430.45022583008,-318.55596923828,34.510556793213), store_weapon = false, store_items = true},
			},
			boss = {
				{coords = vector3(-430.95086669922,-325.10055541992,34.510556793213), min_grade = 1},
			},
			cloak = {
				{coords = vector3(-443.2724609375,-310.97348022461,34.510556793213)},
			},
			can_weapon = true,
			identity_card = true,
			body_search = true,
			drag = true,
			put_in_vehicle = true,
			out_the_vehicle = true,
			billing = true,
			ems_menu_revive = true,
			ems_menu_small = true,
			ems_menu_big = true,
		},

	mechanic = {
			job = "mechanic",
			society = true,
			Blip = {name = "Mechaniker HQ", color = 29, sprite = 68, scale = 1.2, alwayshow = true},
			pos = vector3(-164.31999206543,-1173.3905029297,23.07216835022),
			armory = {
				{coords = vector3(-131.02766418457,-1173.2042236328,23.869873046875), store_weapon = false, store_items = true},
			},
			boss = {
				{coords = vector3(-132.87945556641,-1172.0834960938,27.332204818726), min_grade = 1},
			},
			cloak = {
				{coords = vector3(-131.17268371582,-1184.4146728516,23.469874954224)},
			},
			billing = true,
			hijack_vehicle = true,
			fix_vehicle = true,
			clean_vehicle = true,
		},
}