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
				{coords = vector3(480.40084838867,-996.75048828125,30.689800262451), store_weapon = true, store_items = true, npc = {ped = "s_m_y_cop_01", heading = 90.567893981934}},
			},
			boss = {
				{coords = vector3(460.73150634766,-985.55426025391,30.728080749512), min_grade = 1},
			},
			cloak = {
				{coords = vector3(462.22036743164,-996.58294677734,30.689569473267)},
			},


			citizen_interaction_items = {
				{label = "identity_card"},
				{label = "body_search"},
				{label = "handcuff"},
				{label = "drag"},
				{label = "put_in_vehicle"},
				{label = "out_the_vehicle"},
				{label = "unpaid_bills"},
				{label = "billing"},
				{label = "license"},
			},
			vehicle_interaction_items = {
				{label = "search_database"},
				{label = "vehicle_infos"},
				{label = "hijack_vehicle"},
			},
		},
	sheriff = {
			job = "sheriff",
			society = true,
			Blip = {name = "Sheriffrevier", color = 47, sprite = 58, scale = 0.8, alwayshow = true},
			pos = vector3(-446.57583618164,6014.7001953125,31.716331481934),
			armory = {
				{coords = vector3(-438.38311767578,5989.4423828125,31.716180801392), store_weapon = true, store_items = true},
			},
			boss = {
				{coords = vector3(-435.75357055664,6000.4501953125,31.716173171997), min_grade = 1},
			},
			cloak = {
				{coords = vector3(-451.22647094727,6011.703125,31.716356277466)},
			},


			citizen_interaction_items = {
				{label = "identity_card"},
				{label = "body_search"},
				{label = "handcuff"},
				{label = "drag"},
				{label = "put_in_vehicle"},
				{label = "out_the_vehicle"},
				{label = "unpaid_bills"},
				{label = "billing"},
				{label = "license"},
			},
			vehicle_interaction_items = {
				{label = "search_database"},
				{label = "vehicle_infos"},
				{label = "hijack_vehicle"},
			},
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
			citizen_interaction_items = {
				{label = "identity_card"},
				{label = "body_search"},
				{label = "handcuff"},
				{label = "drag"},
				{label = "put_in_vehicle"},
				{label = "out_the_vehicle"},
				{label = "unpaid_bills"},
				{label = "billing"},
				{label = "license"},
			},
			vehicle_interaction_items = {
				{label = "search_database"},
				{label = "vehicle_infos"},
				{label = "hijack_vehicle"},
			},
		},

	mechanic = {
			job = "mechanic",
			society = true,
			Blip = {name = "Mechaniker HQ", color = 29, sprite = 68, scale = 1.2, alwayshow = true},
			pos = vector3(-1194.2655029297,-1730.8325195313,4.4488468170166),
			armory = {
				{coords = vector3(-1134.0668945313,-1689.072265625,4.4494395256042), store_weapon = false, store_items = true},
				{coords = vector3(-337.84921264648,-142.48876953125,39.013008117676), store_weapon = false, store_items = true},
				
			},
			boss = {
				{coords = vector3(-1147.7520751953,-1683.4089355469,11.836005210876), min_grade = 1},
				{coords = vector3(-329.42004394531,-119.58020019531,39.012962341309), min_grade = 1},
			},
			cloak = {
				{coords = vector3(-1153.0550537109,-1679.1710205078,4.4494590759277)},
				{coords = vector3(-335.78967285156,-119.04692840576,39.012969970703)},
			},
			citizen_interaction_items = {
				{label = "identity_card"},
				{label = "body_search"},
				{label = "handcuff"},
				{label = "drag"},
				{label = "put_in_vehicle"},
				{label = "out_the_vehicle"},
				{label = "unpaid_bills"},
				{label = "billing"},
				{label = "license"},
			},
			vehicle_interaction_items = {
				{label = "search_database"},
				{label = "vehicle_infos"},
				{label = "hijack_vehicle"},
			},
		},
		government = {
			job = "government",
			society = true,
			Blip = {name = "Regierung", color = 40, sprite = 58, scale = 0.8, alwayshow = true},
			pos = vector3(-534.06964111328,-221.12033081055,37.649681091309),
			armory = {
				{coords = vector3(-553.20111083984,-182.4529876709,38.22110748291), store_weapon = false, store_items = true},
				
			},
			boss = {
				{coords = vector3(-520.29376220703,-170.75161743164,42.836582183838), min_grade = 1},
			},
			cloak = {
				{coords = vector3(-537.00866699219,-180.30082702637,38.221069335938)},
			},
		},
		taxi = {
			job = "taxi",
			society = true,
			Blip = {name = "Taxi HQ", color = 46, sprite = 198, scale = 0.8, alwayshow = true},
			pos = vector3(911.87017822266,-173.79040527344,74.279327392578),
			armory = {
				{coords = vector3(889.58233642578,-177.95397949219,81.595062255859), store_weapon = false, store_items = true},
				
			},
			boss = {
				{coords = vector3(906.84686279297,-151.99301147461,83.494972229004), min_grade = 1},
			},
			cloak = {
				{coords = vector3(896.50994873047,-162.76306152344,81.594970703125)},
			},
			citizen_interaction_items = {
				{label = "identity_card"},
				{label = "body_search"},
				{label = "handcuff"},
				{label = "drag"},
				{label = "put_in_vehicle"},
				{label = "out_the_vehicle"},
				{label = "unpaid_bills"},
				{label = "billing"},
				{label = "license"},
			},
			vehicle_interaction_items = {
				{label = "search_database"},
				{label = "vehicle_infos"},
				{label = "hijack_vehicle"},
			},
		},
	}