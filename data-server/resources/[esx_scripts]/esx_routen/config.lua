Config = {}
Config.PlayAnimations = true
Config.ControlKey = 38
routen = {
	{ 
		Tabakroute = {
			illegal = false,
			tobacco_harvest = {
				name = "Tabak sammeln | Zigarettenroute",
				item = {item = "tabacco", count = 1},
				need = {},
				time = 5,
				animation = "WORLD_HUMAN_GARDENER_PLANT",
				blip = {sprite = 501, color = 21, scale = 0.8},
				marker = {type = 27, range = 15.0, red = 50, green = 50, blue = 204, show = true},
				coord = vector3(480.00, 6486.80, 30.00),
				npc = false
			},
			tobacco_process = {
				name = "Zigaretten stopfen | Zigarettenroute",
				time = 3,
				item = {item = "cigarette", count = 1},
				need = {item = "tabacco", count = 2, removeItem = true},
				animation = "WORLD_HUMAN_GARDENER_PLANT",
				blip = {sprite = 501, color = 21, scale = 0.8},
				marker = {type = 1, range = 5.0, red = 50, green = 50, blue = 204, show = false},
				coord = vector3(1465.50, 6548.00, 13.16),
				npc = {model = "a_m_m_hillbilly_01", heading = 90.0}
			},
			tobacco_sell = {
				name = "Zigaretten verkaufen | Zigarettenroute",
				time = 3,
				item = {item = "money", count = 200},
				need = {item = "cigarette", count = 1, removeItem = true},
				animation = "WORLD_HUMAN_GARDENER_PLANT",
				blip = {sprite = 501, color = 21, scale = 0.8},
				marker = {type = 1, range = 5.0, red = 50, green = 50, blue = 204, show = false},
				coord = vector3(2195.00, 5595.00, 52.8),
				npc = {model = "a_m_m_hillbilly_01", heading = 348.0}
			}
		}	
	},
	{ 
		Weinroute = {
			illegal = false,
			grape_harvest = {
				name = "Weintraube sammeln | Weinroute",
				item = {item = "grape", count = 1},
				need = {},
				time = 5,
				animation = "WORLD_HUMAN_GARDENER_PLANT",
				blip = {sprite = 93, color = 1, scale = 0.8},
				marker = {type = 27, range = 80.0, red = 50, green = 50, blue = 204, show = false},
				coord = vector3(-1751.50, 1917.80, 143.00),
				npc = false
			},
			grape_process = {
				name = "Wein erstellen | Weinroute",
				time = 3,
				item = {item = "wine", count = 1},
				need = {item = "tabacco", count = 2, removeItem = true},
				animation = "WORLD_HUMAN_GARDENER_PLANT",
				blip = {sprite = 93, color = 1, scale = 0.8},
				marker = {type = 1, range = 5.0, red = 50, green = 50, blue = 204, show = false},
				coord = vector3(-1905.90, 2281.30, 63.6),
				npc = {model = "a_f_o_soucent_01", heading = 227.50}
			},
			grape_sell = {
				name = "Wein verkaufen | Weinroute",
				time = 3,
				item = {item = "money", count = 200},
				need = {item = "wine", count = 1, removeItem = true},
				animation = "WORLD_HUMAN_GARDENER_PLANT",
				blip = {sprite = 93, color = 1, scale = 0.8},
				marker = {type = 1, range = 5.0, red = 50, green = 50, blue = 204, show = false},
				coord = vector3(-2080.40, 2611.50, 2.10),
				npc = {model = "a_f_o_soucent_01", heading = 115.65}
			}
		}
	},
	{ 
		Westenroute = {
			illegal = false,
			kevlar_harvest = {
				name = "Kevlarfasern sammeln | Westenroute",
				item = {item = "kevlar_fibers", count = 1},
				need = {},
				time = 5,
				animation = "WORLD_HUMAN_GARDENER_PLANT",
				blip = {sprite = 366, color = 40, scale = 0.8},
				marker = {type = 27, range = 15.0, red = 50, green = 50, blue = 204, show = true},
				coord = vector3(84.80, 6505.10, 31.40),
				npc = false
			},
			kevler_process = {
				name = "Kevlar verarbeiten | Westenroute",
				time = 3,
				item = {item = "kevlar", count = 1},
				need = {item = "kevlar_fibers", count = 2, removeItem = true},
				animation = "WORLD_HUMAN_GARDENER_PLANT",
				blip = {sprite = 366, color = 40, scale = 0.8},
				marker = {type = 1, range = 5.0, red = 50, green = 50, blue = 204, show = false},
				coord = vector3(-155.00, 6139.00, 31.35),
				npc = {model = "a_m_m_soucent_04", heading = 0.68}
			},
			kevler_sell = {
				name = "Schutzweste herstellen | Westenroute",
				time = 3,
				item = {item = "gun_vest", count = 200},
				need = {item = "kevlar", count = 5, removeItem = true},
				animation = "WORLD_HUMAN_GARDENER_PLANT",
				blip = {sprite = 366, color = 40, scale = 0.8},
				marker = {type = 1, range = 5.0, red = 50, green = 50, blue = 204, show = false},
				coord = vector3(-2212.60, 4236.75, 46.60),
				npc = {model = "a_m_m_soucent_04", heading = 37.40}
			}
		}
	}	
}