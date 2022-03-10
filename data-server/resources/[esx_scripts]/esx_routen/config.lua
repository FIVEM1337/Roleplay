Config = {}
Config.PlayAnimations = true
Config.ControlKey = 38
routen = {
	--Legale Routen
	{ 
		Tabakroute = {
			illegal = false,
			tobacco_process = {
				name = "Zigaretten stopfen | Zigarettenroute",
				title = "Zigaretten stopfen",
				time = 3,
				dosomething = {
					{
						label = "Waffe1",   --Anzeige Name 
						chance = 70,	--Chance das man Items bekommt in "reciveitems"
						removeonfail = true,	--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "Megageilewaffe", count = 2},
										{item = "koksundnutten", count = 2},
						},
						neededitems = {
										{item = "tabacco", count = 3, remove = true},
										{item = "tabacco", count = 2, remove = true},
						},
					},

					{
						label = "deinemom",   --Anzeige Name 
						chance = 10,		--Chance das man Items bekommt in "reciveitems"
						removeonfail = true,	--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "tabacco", count = 1},
										{item = "tabacco", count = 1},
						},
						neededitems = {
										{item = "tabacco", count = 1, remove = true},
										{item = "tabacco", count = 1, remove = true},
						},
					},
					{
						label = "Huhuu Stimmung",   --Anzeige Name 
						chance = 100,		--Chance das man Items bekommt in "reciveitems"
						reciveitems = {
										{item = "black_money", count = 1},
										{item = "money", count = 1},
										{item = "sMetal", count = 1, remove = true},
										{item = "scratch_ticket", count = 1, remove = true},
										{item = "smg_grip", count = 1, remove = true},
										{item = "spoon", count = 1, remove = true},
										{item = "tabacco", count = 1, remove = true},
										{item = "miniH", count = 1, remove = true},
										{item = "pistol_flashlight", count = 1, remove = true},
										{item = "wCloth", count = 1, remove = true},
										{item = "tablet", count = 1, remove = true},
										{item = "emerald", count = 1, remove = true},
										{item = "file", count = 1, remove = true},
										{item = "wCloth", count = 1, remove = true},
										{item = "fixkit", count = 1, remove = true},
										{item = "goldnecklace", count = 1, remove = true},
										{item = "np_whiskey", count = 1, remove = true},
										{item = "joint", count = 1, remove = true},
										{item = "np_tequila", count = 1, remove = true},
										{item = "np_shot1", count = 1, remove = true},
										{item = "np_cigarette", count = 1, remove = true},
						},
						neededitems = {
										{item = "money", count = 1, remove = true},
										{item = "tabacco", count = 1, remove = true},
						},
					},
				},
				animation = "WORLD_HUMAN_GARDENER_PLANT",
				blip = {sprite = 501, color = 21, scale = 0.8},
				marker = {type = 1, range = 5.0, red = 50, green = 50, blue = 204, show = false},
				coord = vector3(1465.50, 6548.00, 13.16),
				npc = {model = "a_m_m_hillbilly_01", heading = 90.0}
			},
		}
	},
}