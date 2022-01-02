Config = {}
Config.PlayAnimations = false
Config.ControlKey = 38
routen = {
	{ --Tabak
		route1 = {
			illegal = false,
			harvest = {
				type = "harvest",
				name = "harvest",
				item = {item = "bread", count = 2},
				need = {},
				time = 1 * 1000,
				animation = "WORLD_HUMAN_GARDENER_PLANT",
				blip = {sprite = 423, color = 38, scale = 0.8},
				marker = {type = 1, range = 20.0, red = 50, green = 50, blue = 204},
				coord = vector3(-1715.32, 4318.01, 66.37)
			},
			process = {
				type = "process",
				name = "process",
				time = 1 * 1000,
				item = {item = "dildo", count = 2},
				need = {item = "bread", count = 2, removeItem = true},
				animation = "WORLD_HUMAN_GARDENER_PLANT",
				blip = {sprite = 423, color = 38, scale = 0.8},
				marker = {type = 1, range = 20.0, red = 50, green = 50, blue = 204},
				coord = vector3(-1694.32, 4287.01, 71.37)
			},
			sell = {
				type = "sell",
				name = "sell",
				time = 1 * 1000,
				item = {item = "bread", count = 200},
				need = {item = "dildo", count = 2, removeItem = true},
				animation = "WORLD_HUMAN_GARDENER_PLANT",
				blip = {sprite = 423, color = 38, scale = 0.8},
				marker = {type = 1, range = 20.0, red = 50, green = 50, blue = 204},
				coord = vector3(-1683.32, 4259.01, 76.37)
			}
		}
	}
}