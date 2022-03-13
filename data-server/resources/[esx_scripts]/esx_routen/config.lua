-- Animation List:		https://pastebin.com/6mrYTdQv
-- Model List:			https://wiki.altv.mp/wiki/GTA:Ped_Models


Config = {}
Config.PlayAnimations = true
Config.ControlKey = 38
Config.TeleporterMarker = {type = 1, range = 4.0, red = 50, green = 50, blue = 204}
routen = {
--Legale Routen
	{ 
		{
			illegal = false,
			{
				name = "Zigarettenroute | Tabak ernten",
				title = "Tabak Marken",
				time = 3,
				dosomething = {
					{
						label = "Tabak ernten",		--Anzeige Name 
						chance = 100,				--Chance das man Items bekommt in "reciveitems"
						removeonfail = false,		--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "tabacco", count = 1},
						},
						neededitems = {
							{item = "teeee", count = 2},
							{item = "black_money", count = 1},
				

						},
					},
				},
				animation = "WORLD_HUMAN_GARDENER_PLANT",
				blip = {sprite = 501, color = 21, scale = 0.8},
				marker = {type = 27, range = 15.0, red = 50, green = 50, blue = 204, show = true},
				coord = vector3(480.00, 6486.80, 30.00),
				npc = false,
			},


			{
				name = "Zigarettenroute | Tabak eintauschen",
				title = "Zigaretten Marken",
				time = 3,
				dosomething = {
					{
						label = "Tabak eintauschen",	--Anzeige Name 
						chance = 100,					--Chance das man Items bekommt in "reciveitems"
						removeonfail = false,			--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "np_cigarette", count = 1},
						},
						neededitems = {
										{item = "tabacco", count = 15},
						},
					},
				},
				animation = "WORLD_HUMAN_SMOKING",
				blip = {sprite = 501, color = 21, scale = 0.8},
				marker = {type = 1, range = 5.0, red = 50, green = 50, blue = 204, show = true},
				coord = vector3(1465.50, 6548.00, 13.16),
				npc = {model = "a_m_m_hillbilly_01", heading = 90.0},
			},


			{
				name = "Zigarettenroute | Zigaretten verkaufen",
				title = "Zigaretten Marken",
				time = 3,
				dosomething = {
					{
						label = "Zigaretten verkaufen",		--Anzeige Name 
						chance = 100,						--Chance das man Items bekommt in "reciveitems"
						removeonfail = false,				--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "money", count = 1500},
						},
						neededitems = {
										{item = "np_cigarette", count = 15},
						},
					},
				},
				animation = "WORLD_HUMAN_SMOKING",
				blip = {sprite = 501, color = 21, scale = 0.8},
				marker = {type = 1, range = 4.0, red = 50, green = 50, blue = 204, show = true},
				coord = vector3(-383.3, 6199.99, 31.06),
				npc = {model = "a_m_m_salton_01", heading = 45.69},
			},
		},
	}
}