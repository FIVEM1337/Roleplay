Config = {}
Config.Locale = 'de'
Config.PlateLetters  = 3
Config.PlateNumbers  = 3
Config.PlateUseSpace = true

--[[
plane = 251
heli = 64
truck = 67
car = 225
luxuscar = 523
mbike = 226
boat = 410

]]--

Config.VehicleShops = {
	{
		shop_id = "1",
		coords = vector3(-30.9869556427,-1097.0218505859,27.274402618408),
		draw_distance = 15.0,
		interact_distance = 10.0,
		npc = {model = "a_m_m_prolhost_01", heading = 90.0},
		blip = {sprite = 225, color = 3, scale = 0.8, name = "Händler - Auto"},

		spawn_coords = {
			car = {
				{coords = vector3(-59.550518035889,-1115.0264892578,26.225797653198), heading = 340.32974243164},
				{coords = vector3(-54.51927947998,-1116.7208251953,26.22444152832), heading = 343.318359375},
				{coords = vector3(-50.210369110107,-1116.8194580078,26.173822402954), heading = 340.24035644531},
				{coords = vector3(-46.998138427734,-1116.8682861328,26.173892974854), heading = 339.94458007813},
				{coords = vector3(-43.550144195557,-1117.0008544922,26.17472076416), heading = 341.83673095703},
				{coords = vector3(-40.073875427246,-1117.1437988281,26.174169540405), heading = 337.8430480957},
			},
		}
	},

	{
		shop_id = "2",
		coords = vector3(-702.17883300781,-1397.3933105469,8.5464096069336),
		draw_distance = 15.0,
		interact_distance = 10.0,
		npc = {model = "a_m_m_prolhost_01", heading = 314.62069702148},
		blip = {sprite = 64, color = 3, scale = 0.8, name = "Händler - Helikopter"},

		spawn_coords = {
			heli = {
				{coords = vector3(-724.19781494141,-1444.1927490234,5.3643779754639), heading = 131.83993530273},
			},
		}
	},
	{
		shop_id = "3",
		coords = vector3(-713.22943115234,-1297.6851806641,5.1019258499146),
		draw_distance = 15.0,
		interact_distance = 10.0,
		npc = {model = "a_m_m_prolhost_01", heading = 43.365756988525},
		blip = {sprite = 410, color = 3, scale = 0.8, name = "Händler - Boote"},

		spawn_coords = {
			boat = {
				{coords = vector3(-724.60272216797,-1329.5150146484,0.073163449764252), heading = 228.25114440918},
			},
		}
	},
	{
		shop_id = "4",
		coords = vector3(-942.48675537109,-2957.5986328125,13.945070266724),
		draw_distance = 15.0,
		interact_distance = 10.0,
		npc = {model = "a_m_m_prolhost_01", heading = 146.14212036133},
		blip = {sprite = 251, color = 3, scale = 0.8, name = "Händler - Flugzeuge"},

		spawn_coords = {
			plane = {
				{coords = vector3(-980.96160888672,-3025.2243652344,14.120941162109), heading = 61.082344055176},
			},
		}
	},
}