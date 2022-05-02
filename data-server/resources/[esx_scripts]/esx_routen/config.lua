-- Animation List:		https://pastebin.com/6mrYTdQv
-- Model List:			https://wiki.altv.mp/wiki/GTA:Ped_Models


Config = {}
Config.PlayAnimations = true
Config.ControlKey = 38
Config.TeleporterMarker = {type = 1, range = 4.0, red = 50, green = 50, blue = 204}
routen = 
{
	{ --Legale Routen
		{
			{
				title = "Tabak",
				time = 5,1,
				loop = true,
				dosomething = {
					{
						label = "Tabak",				--Anzeige Name 
						chance = 100,					--Chance das man Items bekommt in "reciveitems"
						removeonfail = false,			--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "craft_tabacco", count = 1},
						},
						neededitems = {
						},
					},
				},
				animation = "",
				coords = 
				{
					{
						blip = {label = "Zigarettenroute | Tabak sammeln", sprite = 501, color = 21, scale = 0.8, show = true},
						coord = vector3(480.00, 6486.80,29.40),
						marker = {type = 27, range = 15.0, red = 50, green = 50, blue = 204, show = true},
					},
				},
			},
			{
				title = "Tabak",
				time = 5,
				loop = true,
				dosomething = {
					{
						label = "Zigaretten stopfen", 
						chance = 100,					
						removeonfail = false,			
						reciveitems = {
										{item = "craft_cigarette", count = 1},
						},
						neededitems = {
										{item = "craft_tabacco", count = 2, remove = true},
						},
					},
				},
				animation = "",
				coords = 
				{
					{
						blip = {label = "Zigarettenroute | Zigaretten stopfen", sprite = 501, color = 21, scale = 0.8, show = true},
						coord = vector3(1466.2548828125, 6548.0712890625,13.30),
						marker = {type = 27, range = 4.0, red = 50, green = 50, blue = 204, show = false},
						npc = {model = "a_m_m_hillbilly_01", heading = 91.0, offset = 0.2},
					},
				},
			},
			{
				title = "Tabak",
				time = 5,
				loop = true,
				dosomething = {
					{
						label = "Zigaretten verkaufen",
						chance = 100,
						removeonfail = false,
						reciveitems = {
										{item = "money", count = 500},
						},
						neededitems = {
										{item = "craft_cigarette", count = 1, remove = true},
						},
					},
				},
				animation = "",
				coords = 
				{
					{
						blip = {label = "Zigarettenroute | Zigaretten verkaufen", sprite = 501, color = 21, scale = 0.8, show = true},
						coord = vector3(2194.4990234375, 5594.076171875, 52.80),
						marker = {type = 27, range = 4.0, red = 50, green = 50, blue = 204, show = false},
						npc = {model = "a_m_m_hillbilly_01", heading = 345.00, offset = 0.0},
					},
				},
			},
		},
	},
	{ -- Bulletproof vest Route
		{
			{
				title = "Westen",
				time = 5.4,
				loop = true,
				dosomething = {
					{
						label = "Kevlarfasern sammeln",		--Anzeige Name 
						chance = 100,						--Chance das man Items bekommt in "reciveitems"
						removeonfail = false,				--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "craft_kevlar_fibers", count = 1},
						},
						neededitems = {
						},
					},
				},
				animation = "",
				coords =
				{
					{
						blip = {label = "Westenroute | Kevlarfasern sammeln", sprite = 366, color = 22, scale = 0.8, show = true},
						coord = vector3(84.80, 6505.10, 30.40),
						marker = {type = 27, range = 15.0, red = 50, green = 50, blue = 204, show = true},
					},
				},
			},
		
			{
				title = "Westen",
				time = 5,
				loop = true,
				dosomething = {
					{
						label = "Kevlarfasern verarbeiten",
						chance = 100,
						removeonfail = false,
						reciveitems = {
										{item = "craft_kevlar", count = 1},
						},
						neededitems = {
										{item = "craft_kevlar_fibers", count = 5, remove = true},
						},
					},
				},
				animation = "",
				coords = 
				{
					{
						blip = {label = "Westenroute | Kevlarfasern verarbeiten", sprite = 366, color = 22, scale = 0.8, show = true},
						coord = vector3(-171.19187927246,6151.8017578125,30.30),
						marker = {type = 27, range = 4.0, red = 50, green = 50, blue = 204, show = false},
						npc = {model = "g_m_m_cartelguards_01", heading = 137.80, offset = 0.1},
					},
				},
			},
		
			{
				title = "Westen",
				time = 5,
				loop = true,
				dosomething = {
					{
						label = "Schusssichere Weste herstellen",
						chance = 100,
						removeonfail = false,
						reciveitems = {
										{item = "use_kevlar_west", count = 1},
						},
						neededitems = {
										{item = "craft_kevlar", count = 5, remove = true},
						},
					},
				},
				animation = "",
				coords = 
				{
					{
						blip = {label = "Westenroute | Schusssichere Weste herstellen", sprite = 366, color = 22, scale = 0.8, show = true},
						coord = vector3(-2220.4904785156,4222.6416015625,46.10),
						marker = {type = 27, range = 4.0, red = 50, green = 50, blue = 204, show = false},
						npc = {model = "g_m_m_cartelguards_01", heading = 131.85554504395, offset = 0.1},
					},
				},
			},
		},
	},
	{ -- Weed Route
		{
			{
			
				title = "Weed",
				time = 5,1,
				loop = true,
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
				animation = "",
				coords = 
				{
					{
						blip = {label = "Weedroute | Weed sammeln", sprite = 469, color = 69, scale = 0.8, show = true},
						coord = vector3(5373.04, -5245.00, 32.90),
						marker = {type = 27, range = 15.0, red = 50, green = 50, blue = 204, show = true},
					},
				},
			},	
		
			{
				title = "Weed",
				time = 5,
				loop = true,
				dosomething = {
					{
						label = "Joints herstellen",
						chance = 100,
						removeonfail = false,
						reciveitems = {
										{item = "craft_joint", count = 1},
						},
						neededitems = {
										{item = "craft_weed", count = 15, remove = true},
						},
					},
				},
				animation = "",
				coords = 
				{
					{
						blip = {label = "Weedroute | Joints herstellen", sprite = 469, color = 69, scale = 0.8, show = true},
						coord = vector3(4925.005859375,-5244.6708984375,1.55),
						marker = {type = 27, range = 4.0, red = 50, green = 50, blue = 204, show = false},
						npc = {model = "u_m_y_militarybum", heading = 45.00, offset = 0.0},
					},
				},
			},
	
			{
				title = "Weed",
				time = 5,
				loop = true,
				dosomething = {
					{
						label = "Joints drehen",
						chance = 100,
						removeonfail = false,
						reciveitems = {
										{item = "black_money", count = 550},
						},
						neededitems = {
										{item = "craft_joint", count = 15, remove = true},
						},
					},
				},
				animation = "",
				coords = 
				{
					{
						blip = {label = "Weedroute | Joints verkaufen", sprite = 469, color = 69, scale = 0.8, show = true},
						coord = vector3(4447.55, -4443.70, 6.30),
						marker = {type = 27, range = 4.0, red = 50, green = 50, blue = 204, show = false},
						npc = {model = "u_m_y_militarybum", heading = 105.0, offset = 0.0},
					},
				},
			},
		},
	},
	{ -- Cocaine Route
		{
			{
				title = "Koks",
				time = 5,1,
				loop = true,
				dosomething = {
					{
						label = "Blüten sammeln",		--Anzeige Name 
						chance = 100,					--Chance das man Items bekommt in "reciveitems"
						removeonfail = false,			--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "craft_cocainplant", count = 1},
						},
						neededitems = {
						},
					},
				},
				animation = "",
				coords = 
				{
					{
						blip = {label = "Koksroute | Blüten sammeln", sprite = 674, color = 37, scale = 0.8, show = true},
						coord = vector3(-519.52313232422,4362.1752929688,66.90),
						marker = {type = 27, range = 15.0, red = 50, green = 50, blue = 204, show = true},
					},
				},
			},
	
			{
				title = "Koks",
				time = 5,
				loop = true,
				dosomething = {
					{
						label = "Koks verarbeiten",
						chance = 100,
						removeonfail = false,
						reciveitems = {
										{item = "craft_coke", count = 1},
						},
						neededitems = {
										{item = "craft_cocainplant", count = 15, remove = true},
						},
					},
				},
				animation = "",
				coords = 
				{
					{
						blip = {label = "Koksroute | Koks verarbeiten", sprite = 674, color = 37, scale = 0.8, show = true},
						coord = vector3(-2675.9028320313,2489.3820800781,2.8),
						marker = {type = 27, range = 4.0, red = 50, green = 50, blue = 204, show = false},
						npc = {model = "a_m_y_soucent_02", heading = 85.00, offset = 0.1},
					},
				},
			},
	
			{
				title = "Koks",
				time = 5,
				loop = true,
				dosomething = {
					{
						label = "Koks verkaufen",
						chance = 100,
						removeonfail = false,
						reciveitems = {
										{item = "black_money", count = 800},
						},
						neededitems = {
										{item = "craft_coke", count = 15, remove = true},
						},
					},
				},
				animation = "",
				coords = 
				{
					{
						blip = {label = "Koksroute | Koks verkaufen", sprite = 674, color = 37, scale = 0.8, show = true},
						coord = vector3(3822.3471679688,4440.0434570313,2.00),
						marker = {type = 27, range = 4.0, red = 50, green = 50, blue = 204, show = false},
						npc = {model = "a_m_y_soucent_02", heading = 0.44871735572815, offset = 0.1},
					},
				},
			},
		},
	},
	{ -- Iron Route
		{
			{
				title = "Eisen",
				time = 6,
				loop = true,
				dosomething = {
					{
						label = "Eisen sammeln",
						chance = 100,
						removeonfail = false,
						reciveitems = {
										{item = "craft_ironplate", count = 1},
						},
						neededitems = {
						},
					},
				},
				animation = "",
				coords = 
				{
					{
						blip = {label = "Eisen-Route | Eisenplatten sammeln", sprite = 478, color = 40, scale = 0.8, show = true},
						coord = vector3(2411.8979492188,3103.0205078125,47.30),
						marker = {type = 27, range = 15.0, red = 50, green = 50, blue = 204, show = true},
					},
					{
						blip = {label = "Eisen-Route | Eisenplatten sammeln", sprite = 478, color = 40, scale = 0.8, show = false},
						coord = vector3(2413.3120117188,3135.068359375,47.30),
						marker = {type = 27, range = 15.0, red = 50, green = 50, blue = 204, show = true},
					},
				},
			},
		},
	},
	{ -- Crafter
		{
			{
				title = "Waffen",
				time = 3,
				loop = true,
				dosomething = {
					{
						label = "Waffen Gehäuse herstellen",			--Anzeige Name 
						chance = 80,									--Chance das man Items bekommt in "reciveitems"
						removeonfail = false,							--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "craft_weaponpart1", count = 1},
						},
						neededitems = {
							{item = "craft_ironplate", count = 50, remove = true},
							{item = "black_money", count = 25000, remove = true},
						},
					},
					{
						label = "Magazin herstellen",
						chance = 80,
						removeonfail = false,
						reciveitems = {
										{item = "craft_weaponpart2", count = 1},
						},
						neededitems = {
							{item = "craft_ironplate", count = 50, remove = true},
							{item = "black_money", count = 25000, remove = true},
						},
					},
					{
						label = "Patronen Lager herstellen",
						chance = 80,
						removeonfail = false,
						reciveitems = {
										{item = "craft_weaponpart3", count = 1},
						},
						neededitems = {
							{item = "craft_ironplate", count = 50, remove = true},
							{item = "black_money", count = 25000, remove = true},
						},
					},
					{
						label = "Kurzer Patronen Lauf herstellen",
						chance = 80,
						removeonfail = false,
						reciveitems = {
										{item = "craft_weaponpart4", count = 1},
						},
						neededitems = {
							{item = "craft_ironplate", count = 75, remove = true},
							{item = "black_money", count = 25000, remove = true},
						},
					},
					{
						label = "Langer Patronen Lauf herstellen",
						chance = 80,
						removeonfail = false,
						reciveitems = {
										{item = "craft_weaponpart5", count = 1},
						},
						neededitems = {
							{item = "craft_ironplate", count = 100, remove = true},
							{item = "black_money", count = 25000, remove = true},
						},
					},
					{
						label = "Schaft herstellen",
						chance = 80,
						removeonfail = false,
						reciveitems = {
										{item = "craft_weaponpart5", count = 1},
						},
						neededitems = {
							{item = "craft_ironplate", count = 100, remove = true},
							{item = "black_money", count = 25000, remove = true},
						},
					},
				},
				animation = "",
				coords = 
				{
					{
						blip = {label = "Waffenroute | Waffenteile herstellen", sprite = 150, color = 21, scale = 0.8, show = true},
						coord = vector3(596.04339599609,-457.11849975586,23.80),
						marker = {type = 27, range = 3.0, red = 50, green = 50, blue = 204, show = false},
						npc = {model = "csb_ramp_mex", heading = 355.60, offset = 0.0},
					},
				},
			},
		},
	},
	{ -- Weapon Dealer
		{
			{
				title = "Kleinwaffen Händler",
				time = 3,
				loop = false,
				dosomething = {
					{
						label = "Flasche",			--Anzeige Name 
						chance = 70,				--Chance das man Items bekommt in "reciveitems"
						removeonfail = true,		--Entferne Needed Items wenn fehlschlägt"
						reciveitems = {
										{item = "WEAPON_BOTTLE", count = 1},
						},
						neededitems = {
							{item = "craft_weaponpart1", count = 1, remove = true},
							{item = "craft_weaponpart2", count = 1, remove = true},
							{item = "craft_weaponpart3", count = 1, remove = true},
							{item = "black_money", count = 50000, remove = true},
						},
					},
					{
						label = "Billiard-Kö",
						chance = 70,
						removeonfail = true,
						reciveitems = {
										{item = "WEAPON_POOLCUE", count = 1},
						},
						neededitems = {
							{item = "craft_weaponpart1", count = 1, remove = true},
							{item = "craft_weaponpart2", count = 1, remove = true},
							{item = "craft_weaponpart3", count = 1, remove = true},
							{item = "black_money", count = 50000, remove = true},
						},
					},
					{
						label = "Klappmesser",
						chance = 70,
						removeonfail = true,
						reciveitems = {
										{item = "WEAPON_SWITCHBLADE", count = 1},
						},
						neededitems = {
							{item = "craft_weaponpart1", count = 1, remove = true},
							{item = "craft_weaponpart2", count = 1, remove = true},
							{item = "craft_weaponpart3", count = 1, remove = true},
							{item = "black_money", count = 50000, remove = true},
						},
					},
					{
						label = "Machete",
						chance = 70,
						removeonfail = true,
						reciveitems = {
										{item = "WEAPON_MACHETE", count = 1},
						},
						neededitems = {
							{item = "craft_weaponpart1", count = 1, remove = true},
							{item = "craft_weaponpart2", count = 1, remove = true},
							{item = "craft_weaponpart3", count = 1, remove = true},
							{item = "black_money", count = 50000, remove = true},
						},
					},
					{
						label = "Dolch",
						chance = 70,
						removeonfail = true,
						reciveitems = {
										{item = "WEAPON_DAGGER", count = 1},
						},
						neededitems = {
							{item = "craft_weaponpart1", count = 1, remove = true},
							{item = "craft_weaponpart2", count = 1, remove = true},
							{item = "craft_weaponpart3", count = 1, remove = true},
							{item = "black_money", count = 50000, remove = true},
						},
					},
					{
							label = "Schlagring",
							chance = 60,
							removeonfail = true,
							reciveitems = {
											{item = "WEAPON_KNUCKLE", count = 1},
							},
							neededitems = {
								{item = "craft_weaponpart1", count = 1, remove = true},
								{item = "craft_weaponpart2", count = 1, remove = true},
								{item = "craft_weaponpart3", count = 1, remove = true},
								{item = "black_money", count = 5000, remove = true},
						},
					},
				},
				animation = "",
				coords = 
				{
					{
						blip = {label = "Waffenroute | Kleinwaffen Händler", sprite = 150, color = 21, scale = 0.8, show = true},
						coord = vector3(2556.0383300781,4658.0151367188,33.20),
						marker = {type = 27, range = 3.0, red = 50, green = 50, blue = 204, show = false},
						npc = {model = "s_m_y_blackops_02", heading = 301.00, offset = 0.1},
					},
				},
			},
		},
	},
	{ -- Weapon Dealer (Pistol)
		{
			{
				title = "Pistolen Händler",
				time = 3,
				loop = false,
				dosomething = {
					{
						label = "Pistole.50",
						chance = 60,
						removeonfail = true,
						reciveitems = {
										{item = "WEAPON_PISTOL50", count = 1},
						},
						neededitems = {
							{item = "craft_weaponpart1", count = 1, remove = true},
							{item = "craft_weaponpart2", count = 1, remove = true},
							{item = "craft_weaponpart3", count = 1, remove = true},
							{item = "craft_weaponpart4", count = 1, remove = true},
							{item = "black_money", count = 100000, remove = true},
						},
					},
					{
						label = "Schwerer Revolver",
						chance = 50,
						removeonfail = true,
						reciveitems = {
										{item = "WEAPON_REVOLVER", count = 1},
						},
						neededitems = {
							{item = "craft_weaponpart1", count = 1, remove = true},
							{item = "craft_weaponpart2", count = 1, remove = true},
							{item = "craft_weaponpart3", count = 1, remove = true},
							{item = "craft_weaponpart4", count = 1, remove = true},
							{item = "black_money", count = 100000, remove = true},
						},
					},
				},
				animation = "",
				coords = 
				{
					{
						blip = {label = "Waffenroute | Pistolen Händler", sprite = 150, color = 21, scale = 0.8, show = false},
						coord = vector3(2557.1701660156,4666.53515625,33.20),
						marker = {type = 27, range = 3.0, red = 50, green = 50, blue = 204, show = false},
						npc = {model = "s_m_y_blackops_02", heading = 165.00, offset = 0.20},
					},
				},
			},
		},
	},
	{ -- Weapon Dealer (Langwaffen)
		{
			{
				title = "Langwaffen Händler",
				time = 3,
				loop = false,
				dosomething = {
					{
						label = "Gusenberg",
						chance = 50,
						removeonfail = true,
						reciveitems = {
										{item = "WEAPON_GUSENBERG", count = 1},
						},
						neededitems = {
							{item = "craft_weaponpart1", count = 1, remove = true},
							{item = "craft_weaponpart2", count = 1, remove = true},
							{item = "craft_weaponpart3", count = 1, remove = true},
							{item = "craft_weaponpart5", count = 1, remove = true},
							{item = "craft_weaponpart6", count = 1, remove = true},
							{item = "black_money", count = 200000, remove = true},
						},
					},
					{
						label = "Compactgewehr",
						chance = 50,
						removeonfail = true,
						reciveitems = {
										{item = "WEAPON_COMPACTRIFLE", count = 1},
						},
						neededitems = {
							{item = "craft_weaponpart1", count = 1, remove = true},
							{item = "craft_weaponpart2", count = 1, remove = true},
							{item = "craft_weaponpart3", count = 1, remove = true},
							{item = "craft_weaponpart5", count = 1, remove = true},
							{item = "craft_weaponpart6", count = 1, remove = true},
							{item = "black_money", count = 200000, remove = true},
						},
					},
					{
						label = "Advancedgewehr",
						chance = 40,
						removeonfail = true,
						reciveitems = {
										{item = "WEAPON_ADVANCEDRIFLE", count = 1},
						},
						neededitems = {
							{item = "craft_weaponpart1", count = 1, remove = true},
							{item = "craft_weaponpart2", count = 1, remove = true},
							{item = "craft_weaponpart3", count = 1, remove = true},
							{item = "craft_weaponpart5", count = 1, remove = true},
							{item = "craft_weaponpart6", count = 1, remove = true},
							{item = "black_money", count = 200000, remove = true},
						},
					},
					{
						label = "Bullpupgewehr",
						chance = 40,
						removeonfail = true,
						reciveitems = {
										{item = "WEAPON_BULLPUPRIFLE", count = 1},
						},
						neededitems = {
							{item = "craft_weaponpart1", count = 1, remove = true},
							{item = "craft_weaponpart2", count = 1, remove = true},
							{item = "craft_weaponpart3", count = 1, remove = true},
							{item = "craft_weaponpart5", count = 1, remove = true},
							{item = "craft_weaponpart6", count = 1, remove = true},
							{item = "black_money", count = 200000, remove = true},
						},
					},
					{
						label = "Militärgewehr",
						chance = 40,
						removeonfail = true,
						reciveitems = {
										{item = "WEAPON_MILITARYIFLE", count = 1},
						},
						neededitems = {
							{item = "craft_weaponpart1", count = 1, remove = true},
							{item = "craft_weaponpart2", count = 1, remove = true},
							{item = "craft_weaponpart3", count = 1, remove = true},
							{item = "craft_weaponpart5", count = 1, remove = true},
							{item = "craft_weaponpart6", count = 1, remove = true},
							{item = "black_money", count = 200000, remove = true},
						},
					},
				},
				animation = "",
				coords = 
				{
					{
						blip = {label = "Waffenroute | Langwaffen Händler", sprite = 150, color = 21, scale = 0.8, show = false},
						coord = vector3(2553.3002929688,4665.11328125,33.20),
						marker = {type = 27, range = 3.0, red = 50, green = 50, blue = 204, show = false},
						npc = {model = "s_m_y_blackops_02", heading = 235.00, offset = 0.10},
					},
				},
			},
		},
	},
}
