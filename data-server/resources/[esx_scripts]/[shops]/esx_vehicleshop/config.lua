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
		coords = vector3(-50.650760650635,-1109.9078369141,26.670318603516),
		draw_distance = 15.0,
		interact_distance = 10.0,
		npc = {model = "a_m_m_prolhost_01", heading = 90.0},
		blip = {sprite = 225, color = 3, scale = 0.8, name = "Händler - Auto"},

		spawn_coords = {
			car = {
				{coords = vector3(-59.550518035889,-1115.0264892578,26.225797653198), heading = 340.32974243164},
				{coords = vector3(-54.51927947998,-1116.7208251953,26.22444152832), heading = 343.318359375},
			},
			boat = {
				{coords = vector3(-55.308624267578,-1131.7788085938,25.476472854614), heading = 268.19989013672},
				{coords = vector3(-32.37230682373,-1131.8444824219,26.137065887451), heading = 270.59582519531},
			},
			plane = {
				{coords = vector3(-72.465957641602,-1105.3128662109,25.646482467651), heading = 262.3786315918},
				{coords = vector3(-72.74430847168,-1091.654296875,26.066980361938), heading = 145.10357666016},
			},
			heli = {
				{coords = vector3(-74.402854919434,-1111.0891113281,25.467910766602), heading = 171.39581298828},
				{coords = vector3(-74.215835571289,-1126.9897460938,25.24312210083), heading = 182.46653747559},
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
			car = {
				{coords = vector3(-59.550518035889,-1115.0264892578,26.225797653198), heading = 340.32974243164},
				{coords = vector3(-54.51927947998,-1116.7208251953,26.22444152832), heading = 343.318359375},
			},
			boat = {
				{coords = vector3(-55.308624267578,-1131.7788085938,25.476472854614), heading = 268.19989013672},
				{coords = vector3(-32.37230682373,-1131.8444824219,26.137065887451), heading = 270.59582519531},
			},
			plane = {
				{coords = vector3(-72.465957641602,-1105.3128662109,25.646482467651), heading = 262.3786315918},
				{coords = vector3(-72.74430847168,-1091.654296875,26.066980361938), heading = 145.10357666016},
			},
			heli = {
				{coords = vector3(-74.402854919434,-1111.0891113281,25.467910766602), heading = 171.39581298828},
				{coords = vector3(-74.215835571289,-1126.9897460938,25.24312210083), heading = 182.46653747559},
			},
		}
	},
}
