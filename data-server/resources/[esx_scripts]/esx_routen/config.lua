-- Animation List:		https://pastebin.com/6mrYTdQv
-- Model List:			https://wiki.altv.mp/wiki/GTA:Ped_Models


Config = {}
Config.PlayAnimations = true
Config.ControlKey = 38
Config.TeleporterMarker = {type = 1, range = 4.0, red = 50, green = 50, blue = 204}
routen = {
--Legale Routen
	{
--[[
	Zigarettenroute
]]--
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
										{item = "craft_tabacco", count = 1},
						},
						neededitems = {
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
										{item = "craft_cigarette", count = 1},
						},
						neededitems = {
										{item = "craft_tabacco", count = 15, remove = true},
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
										{item = "craft_cigarette", count = 15, remove = true},
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
-----------------------------------------------------------------------------------------------------------------------------------------------------
--[[
	Weinroute
]]--
		{
			illegal = false,
			{
				name = "Weinnroute | Weintrauben ernten",
				title = "Wein Marken",
				time = 3,
				dosomething = {
					{
						label = "Weintrauben ernten",		--Anzeige Name 
						chance = 100,				--Chance das man Items bekommt in "reciveitems"
						removeonfail = false,		--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "craft_grape", count = 1},
						},
						neededitems = {
						},
					},
				},
				animation = "WORLD_HUMAN_GARDENER_PLANT",
				blip = {sprite = 93, color = 1, scale = 0.8},
				marker = {type = 27, range = 80.0, red = 50, green = 50, blue = 204, show = false},
				coord = vector3(-1751.50, 1917.80, 143.00),
				npc = false
			},


			{
				name = "Weinnroute | Weintrauben eintauschen",
				title = "Wein Marken",
				time = 3,
				dosomething = {
					{
						label = "Weintrauben eintauschen",	--Anzeige Name 
						chance = 100,					--Chance das man Items bekommt in "reciveitems"
						removeonfail = false,			--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "craft_wine", count = 1},
						},
						neededitems = {
										{item = "craft_grape", count = 15, remove = true},
						},
					},
				},
				animation = "WORLD_HUMAN_SMOKING",
				blip = {sprite = 93, color = 1, scale = 0.8},
				marker = {type = 1, range = 5.0, red = 50, green = 50, blue = 204, show = false},
				coord = vector3(-1905.90, 2281.30, 63.6),
				npc = {model = "a_f_o_soucent_01", heading = 227.50},
			},


			{
				name = "Weinnroute | Wein verkaufen",
				title = "Wein Marken",
				time = 3,
				dosomething = {
					{
						label = "Wein verkaufen",			--Anzeige Name 
						chance = 100,						--Chance das man Items bekommt in "reciveitems"
						removeonfail = false,				--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "money", count = 1500},
						},
						neededitems = {
										{item = "craft_wine", count = 15, remove = true},
						},
					},
				},
				animation = "WORLD_HUMAN_SMOKING",
				blip = {sprite = 93, color = 1, scale = 0.8},
				marker = {type = 1, range = 5.0, red = 50, green = 50, blue = 204, show = false},
				coord = vector3(-2080.40, 2611.50, 2.10),
				npc = {model = "a_f_o_soucent_01", heading = 115.65},
			},
		},
-----------------------------------------------------------------------------------------------------------------------------------------------------
--[[
	Westenroute
]]--
		{
			illegal = false,
			{
				name = "Westenroute | Kevlarfasern sammeln",
				title = "Westen",
				time = 3,
				dosomething = {
					{
						label = "Kevlarfasern sammeln",		--Anzeige Name 
						chance = 100,				--Chance das man Items bekommt in "reciveitems"
						removeonfail = false,		--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "craft_kevlar_fibers", count = 1},
						},
						neededitems = {
						},
					},
				},
				animation = "WORLD_HUMAN_GARDENER_PLANT",
				blip = {sprite = 366, color = 40, scale = 0.8},
				marker = {type = 27, range = 15.0, red = 50, green = 50, blue = 204, show = true},
				coord = vector3(84.80, 6505.10, 31.40),
				npc = false
			},
		
		
			{
				name = "Westennroute | Kevlar verarbeiten",
				title = "Westen",
				time = 3,
				dosomething = {
					{
						label = "Kevlar verarbeiten",	--Anzeige Name 
						chance = 100,					--Chance das man Items bekommt in "reciveitems"
						removeonfail = false,			--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "craft_kevlar", count = 1},
						},
						neededitems = {
										{item = "craft_kevlar_fibers", count = 15, remove = true},
						},
					},
				},
				animation = "WORLD_HUMAN_GARDENER_PLANT",
				blip = {sprite = 366, color = 40, scale = 0.8},
				marker = {type = 1, range = 5.0, red = 50, green = 50, blue = 204, show = false},
				coord = vector3(-155.00, 6139.00, 31.35),
				npc = {model = "a_m_m_soucent_04", heading = 0.68}
			},
		
		
			{
				name = "Westenroute | Schutzweste herstellen",
				title = "Westen",
				time = 3,
				dosomething = {
					{
						label = "Schutzweste herstellen",		--Anzeige Name 
						chance = 100,						--Chance das man Items bekommt in "reciveitems"
						removeonfail = false,				--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "use_kevlar_west", count = 1},
						},
						neededitems = {
										{item = "craft_kevlar", count = 15, remove = true},
						},
					},
				},
				animation = "WORLD_HUMAN_GARDENER_PLANT",
				blip = {sprite = 366, color = 40, scale = 0.8},
				marker = {type = 1, range = 5.0, red = 50, green = 50, blue = 204, show = false},
				coord = vector3(-2212.60, 4236.75, 46.60),
				npc = {model = "a_m_m_soucent_04", heading = 37.40}
			},
		},
-----------------------------------------------------------------------------------------------------------------------------------------------------
		--[[
	Weedroute -Illegale Routen
]]--
{
			illegal = false,
			{
				name = "Weedroute | Weed sammeln",
				title = "Weed",
				time = 3,
				dosomething = {
					{
						label = "Weed sammeln",		--Anzeige Name 
						chance = 100,				--Chance das man Items bekommt in "reciveitems"
						removeonfail = false,		--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "craft_weed", count = 1},
						},
						neededitems = {
						},
					},
				},
				animation = "WORLD_HUMAN_GARDENER_PLANT",
				blip = {sprite = 496, color = 2, scale = 0.8},
				marker = {type = 27, range = 50.0, red = 50, green = 50, blue = 204, show = false},
				coord = vector3(5373.04, -5245.00, 34.10),
				npc = false
			},
		
		
			{
				name = "Weedroute | Joints herstellen",
				title = "Weed",
				time = 3,
				dosomething = {
					{
						label = "Joints herstellen",	--Anzeige Name 
						chance = 100,					--Chance das man Items bekommt in "reciveitems"
						removeonfail = false,			--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "craft_joint", count = 1},
						},
						neededitems = {
										{item = "craft_weed", count = 15, remove = true},
						},
					},
				},
				animation = "WORLD_HUMAN_GARDENER_PLANT",
				blip = {sprite = 496, color = 2, scale = 0.8},
				marker = {type = 1, range = 5.0, red = 50, green = 50, blue = 204, show = false},
				coord = vector3(5011.20, -5750.90, 27.85),
				npc = {model = "a_m_y_soucent_02", heading = 152.85}
			},
		
		
			{
				name = "Weedroute | Joints verkaufen",
				title = "Weed",
				time = 3,
				dosomething = {
					{
						label = "Joints verkaufen",		--Anzeige Name 
						chance = 100,						--Chance das man Items bekommt in "reciveitems"
						removeonfail = false,				--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "black_money", count = 1500},
						},
						neededitems = {
										{item = "craft_joint", count = 15, remove = true},
						},
					},
				},
				animation = "WORLD_HUMAN_GARDENER_PLANT",
				blip = {sprite = 496, color = 2, scale = 0.8},
				marker = {type = 1, range = 5.0, red = 50, green = 50, blue = 204, show = false},
				coord = vector3(4447.55, -4443.70, 6.24),
				npc = {model = "a_m_y_soucent_02", heading = 108.50}
			},
		},
-----------------------------------------------------------------------------------------------------------------------------------------------------
--[[
	Koksroute
]]--
		{
			illegal = false,
			{
				name = "Koksroute | Blüten sammeln",
				title = "Koks",
				time = 3,
				dosomething = {
					{
						label = "Blüten sammeln",		--Anzeige Name 
						chance = 100,				--Chance das man Items bekommt in "reciveitems"
						removeonfail = false,		--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "craft_cocainplant", count = 1},
						},
						neededitems = {
						},
					},
				},
				animation = "WORLD_HUMAN_GARDENER_PLANT",
				blip = {sprite = 514, color = 0, scale = 0.8},
				marker = {type = 27, range = 50.0, red = 50, green = 50, blue = 204, show = false},
				coord = vector3(2219.5, 5576.54, 53.66),
				npc = false
			},
		
		
			{
				name = "Koksroute | Koks verarbeiten ",
				title = "Koks",
				time = 3,
				dosomething = {
					{
						label = "Koks verarbeiten ",	--Anzeige Name 
						chance = 100,					--Chance das man Items bekommt in "reciveitems"
						removeonfail = false,			--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "craft_coke", count = 1},
						},
						neededitems = {
										{item = "craft_cocainplant", count = 15, remove = true},
						},
					},
				},
				animation = "WORLD_HUMAN_WINDOW_SHOP_BROWSE",
				blip = {sprite = 514, color = 0, scale = 0.8},
				marker = {type = 1, range = 5.0, red = 50, green = 50, blue = 204, show = true},
				coord = vector3(-7.92, -759.28, -103.28),
				npc = false,
				teleporters = {
                    {enter = vector3(-144.64, -835.37, 30.04), exit = vector3(-11.00,-763.14, -103.68), showmarker = true, distance = 5.00, shownotification = true},
                    {enter = vector3(-11.00,-763.14, -103.68), exit = vector3(-144.64, -835.37, 30.04), showmarker = true, distance = 5.00, shownotification = true},
                },
			},
		
		
			{
				name = "Koksroute | Koks verkaufen",
				title = "Koks",
				time = 3,
				dosomething = {
					{
						label = "Koks verkaufen",		--Anzeige Name 
						chance = 100,						--Chance das man Items bekommt in "reciveitems"
						removeonfail = false,				--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "black_money", count = 1500},
						},
						neededitems = {
										{item = "craft_coke", count = 15, remove = true},
						},
					},
				},
				animation = "WORLD_HUMAN_GARDENER_PLANT",
				blip = {sprite = 514, color = 0, scale = 0.8},
				marker = {type = 1, range = 5.0, red = 50, green = 50, blue = 204, show = false},
				coord = vector3(1832.29, 3868.24, 34.3),
				npc = {model = "a_m_y_soucent_02", heading = 108.50}
			},
		},
-----------------------------------------------------------------------------------------------------------------------------------------------------
--[[
	Waffenroute
]]--
		{
			illegal = false,
			{
				name = "Waffenroute | Metall sammeln",
				title = "Metall",
				time = 3,
				dosomething = {
					{
						label = "Metall sammeln",		--Anzeige Name 
						chance = 100,				--Chance das man Items bekommt in "reciveitems"
						removeonfail = false,		--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "craft_ironplate", count = 1},
						},
						neededitems = {
						},
					},
				},
				animation = "WORLD_HUMAN_WELDING",
				blip = {sprite = 150, color = 1, scale = 0.8},
				marker = {type = 27, range = 10.00, red = 50, green = 50, blue = 204, show = true},
				coord = vector3(-497.6, -1745.5, 18.97),
				npc = false
			},
		},
		
		{
			illegal = false,
			{
				name = "Waffenroute | Aluminium sammeln",
				title = "Waffen",
				time = 3,
				dosomething = {
					{
						label = "Aluminium sammeln",		--Anzeige Name 
						chance = 100,				--Chance das man Items bekommt in "reciveitems"
						removeonfail = false,		--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "craft_aluminum", count = 1},
						},
						neededitems = {
						},
					},
				},
				animation = "WORLD_HUMAN_WELDING",
				blip = {sprite = 150, color = 1, scale = 0.8},
				marker = {type = 27, range = 10.00, red = 50, green = 50, blue = 204, show = true},
				coord = vector3(2420.89, 3092.61, 48.24),
				npc = false
			},
		},
		{
			illegal = false,
			{
				name = "Waffenroute | craft_weaponparte herstellen",
				title = "Waffen",
				time = 3,
				dosomething = {
					{
						label = "craft_weaponpart 1 herstellen",		--Anzeige Name 
						chance = 100,				--Chance das man Items bekommt in "reciveitems"
						removeonfail = false,		--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "craft_weaponpart1", count = 1},
						},
						neededitems = {
							{item = "craft_aluminum", count = 1, remove = true},
							{item = "craft_ironplate", count = 1, remove = true},
						},
					},
					{
						label = "craft_weaponpart 2 herstellen",		--Anzeige Name 
						chance = 100,				--Chance das man Items bekommt in "reciveitems"
						removeonfail = false,		--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "craft_weaponpart2", count = 1},
						},
						neededitems = {
							{item = "craft_aluminum", count = 1, remove = true},
							{item = "craft_ironplate", count = 1, remove = true},
						},
					},
					{
						label = "craft_weaponpart 3 herstellen",		--Anzeige Name 
						chance = 100,				--Chance das man Items bekommt in "reciveitems"
						removeonfail = false,		--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "craft_weaponpart3", count = 1},
						},
						neededitems = {
							{item = "craft_aluminum", count = 1, remove = true},
							{item = "craft_ironplate", count = 1, remove = true},
						},
					},
					{
						label = "craft_weaponpart 4 herstellen",		--Anzeige Name 
						chance = 100,				--Chance das man Items bekommt in "reciveitems"
						removeonfail = false,		--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "craft_weaponpart4", count = 1},
						},
						neededitems = {
							{item = "craft_aluminum", count = 1, remove = true},
							{item = "craft_ironplate", count = 1, remove = true},
						},
					},
					{
						label = "craft_weaponpart 5 herstellen",		--Anzeige Name 
						chance = 80,				--Chance das man Items bekommt in "reciveitems"
						removeonfail = false,		--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "craft_weaponpart5", count = 1},
						},
						neededitems = {
							{item = "craft_aluminum", count = 1, remove = true},
							{item = "craft_ironplate", count = 1, remove = true},
						},
					},
				},
				animation = "WORLD_HUMAN_SMOKING",
				blip = {sprite = 150, color = 1, scale = 0.8},
				marker = {type = 27, range = 10.00, red = 50, green = 50, blue = 204, show = true},
				coord = vector3(596.68, -448.96, 23.78),
				npc = {model = "s_m_y_armymech_01", heading = 270.1}
			},
		},
		{
			illegal = false,
			{
				name = "Pistolen Händler",
				title = "Pistolen Händler",
				time = 3,
				dosomething = {
					{
						label = "Pistole",		--Anzeige Name 
						chance = 50,				--Chance das man Items bekommt in "reciveitems"
						removeonfail = true,		--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "WEAPON_PISTOL", count = 1},
						},
						neededitems = {
							{item = "craft_weaponpart1", count = 1, remove = true},
							{item = "craft_weaponpart2", count = 1, remove = true},
						},
					},
										{
						label = "50er Pistole",		--Anzeige Name 
						chance = 40,				--Chance das man Items bekommt in "reciveitems"
						removeonfail = true,		--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "WEAPON_PISTOL50", count = 1},
						},
						neededitems = {
							{item = "craft_weaponpart1", count = 1, remove = true},
							{item = "craft_weaponpart2", count = 1, remove = true},
							{item = "craft_weaponpart3", count = 1, remove = true},
						},
					},
				},
				animation = "",
				blip = {sprite = 150, color = 1, scale = 0.8},
				marker = {type = 27, range = 4.00, red = 50, green = 50, blue = 204, show = true},
				coord = vector3(2553.08, 4665.34, 33.10),
				npc = {model = "s_m_y_blackops_03", heading = 242.09}
			},
		},
		{
			illegal = false,
			{
				name = "SMG Händler",
				title = "SMG Händler",
				time = 3,
				dosomething = {
					{
						label = "Mini-SMG",		--Anzeige Name 
						chance = 40,				--Chance das man Items bekommt in "reciveitems"
						removeonfail = true,		--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "WEAPON_MINISMG", count = 1},
						},
						neededitems = {
							{item = "craft_weaponpart1", count = 1, remove = true},
							{item = "craft_weaponpart2", count = 1, remove = true},
							{item = "craft_weaponpart3", count = 1, remove = true},
							{item = "craft_weaponpart4", count = 1, remove = true},
						},
					},
					{
						label = "Micro-SMG",		--Anzeige Name 
						chance = 40,				--Chance das man Items bekommt in "reciveitems"
						removeonfail = true,		--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "WEAPON_MICROSMG", count = 1},
						},
						neededitems = {
							{item = "craft_weaponpart1", count = 1, remove = true},
							{item = "craft_weaponpart2", count = 1, remove = true},
							{item = "craft_weaponpart3", count = 1, remove = true},
							{item = "craft_weaponpart4", count = 1, remove = true},
						},
					},
				},
				animation = "",
				blip = {sprite = 150, color = 1, scale = 0.8},
				marker = {type = 27, range = 4.00, red = 50, green = 50, blue = 204, show = true},
				coord = vector3(2556.18, 4661.17, 33.10),
				npc = {model = "s_m_y_blackops_02", heading = 200.09}
			},
		},
		{
			illegal = false,
			{
				name = "Special Händler",
				title = "SMG Händler",
				time = 3,
				dosomething = {
					{
						label = "Crabiner",		--Anzeige Name 
						chance = 20,				--Chance das man Items bekommt in "reciveitems"
						removeonfail = true,		--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "WEAPON_CARBINERIFLE", count = 1},
						},
						neededitems = {
							{item = "craft_weaponpart1", count = 1, remove = true},
							{item = "craft_weaponpart2", count = 1, remove = true},
							{item = "craft_weaponpart3", count = 1, remove = true},
							{item = "craft_weaponpart4", count = 1, remove = true},
							{item = "craft_weaponpart5", count = 1, remove = true},
						},
					},
					{
						label = "Shotgun",		--Anzeige Name 
						chance = 40,				--Chance das man Items bekommt in "reciveitems"
						removeonfail = true,		--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "WEAPON_BULLPUPSHOTGUN", count = 1},
						},
						neededitems = {
							{item = "craft_weaponpart1", count = 1, remove = true},
							{item = "craft_weaponpart2", count = 1, remove = true},
							{item = "craft_weaponpart3", count = 1, remove = true},
							{item = "craft_weaponpart4", count = 1, remove = true},
							{item = "craft_weaponpart5", count = 1, remove = true},
						},
					},
				},
				animation = "",
				blip = {sprite = 150, color = 1, scale = 0.8},
				marker = {type = 27, range = 4.00, red = 50, green = 50, blue = 204, show = true},
				coord = vector3(2557.52, 4666.06, 32.98),
				npc = {model = "s_m_y_blackops_01", heading = 131.2}
			},
		},
-----------------------------------------------------------------------------------------------------------------------------------------------------
	}
}