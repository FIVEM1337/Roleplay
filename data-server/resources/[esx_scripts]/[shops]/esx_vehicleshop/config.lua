Config                            = {}
Config.DrawDistance               = 50.0
Config.MarkerColor                = { r = 255, g = 0, b = 0 }
Config.EnableOwnedVehicles        = true

Config.Locale                     = 'de'

Config.LicenseEnable = false -- require people to own drivers license when buying vehicles? Only applies if EnablePlayerManagement is disabled. Requires esx_license

-- looks like this: 'LLL NNN'
-- The maximum plate length is 8 chars (including spaces & symbols), don't go past it!
Config.PlateLetters  = 3
Config.PlateNumbers  = 3
Config.PlateUseSpace = true

Config.Zones = {
	DonatorShop = {
		ShopName = "Premium Deluxe Cars",
		VehicleShop = true,
		DonatorShop = true,
		Pos   = vector3(-1257.38, -368.84, 37.00),
		Size  = vector3(1.5, 1.5, 1.0),
		Type  = 36,
		VehType = "car"
	},
	CarShop = {
		ShopName = "Authohändler",
		VehicleShop = true,
		DonatorShop = false,
		Pos   = vector3(-32.007301330566,-1096.8826904297,27.316753387451),
		Size  = vector3(1.5, 1.5, 1.0),
		Type  = 36,
		VehType = "car"
	},
	PlaneShop = {
		ShopName = "Flugzeughändler",
		VehicleShop = true,
		DonatorShop = false,
		Pos   = vector3(-935.08, -2965.69, 19.85),
		Size  = vector3(1.5, 1.5, 1.0),
		Type  = 36,
		VehType = "plane"
	},

	BoatShop = {
		ShopName = "Boothändler",
		VehicleShop = true,
		DonatorShop = false,
		Pos   = vector3(-835.31, -1337.64, 5),
		Size  = vector3(1.5, 1.5, 1.0),
		Type  = 36,
		VehType = "boat"
	},

	HeliShop = {
		ShopName = "Helicopterhändler",
		VehicleShop = true,
		DonatorShop = false,
		Pos   = vector3(-695.44989013672,-1395.3560791016,8.5464105606079),
		Size  = vector3(1.5, 1.5, 1.0),
		Type  = 36,
		VehType = "helicopter"
	},



	-- Vehicle Spawns
	car = {
		Size  = vector3(1.5, 1.5, 1.0),
		spawn_coords = {
            {coords = vector3(-18.123119354248,-1079.9405517578,26.541877746582), heading = 126.18},
            {coords = vector3(-15.420352935791,-1080.7667236328,26.541589736938), heading = 126.38},
            {coords = vector3(-12.179203987122,-1081.2083740234,26.544414520264), heading = 125.98},
            {coords = vector3(-9.0703687667847,-1082.4122314453,26.546464920044), heading = 127.51},

            {coords = vector3(-10.664839744568,-1096.6818847656,26.541534423828), heading = 101.30},
            {coords = vector3(-11.884087562561,-1099.9699707031,26.541822433472), heading = 101.91},

            {coords = vector3(-13.189190864563,-1102.880859375,26.541582107544), heading = 100.79},
            {coords = vector3(-14.334703445435,-1105.7869873047,26.542316436768), heading = 102.29},
            {coords = vector3(-15.329020500183,-1108.6375732422,26.541961669922), heading = 102.43},
        },
		Type  = -1
	},

	car_donator = {
		Size  = vector3(1.5, 1.5, 1.0),
		spawn_coords = {
            {coords = vector3(-1234.48, -344.84, 36.90), heading = 28.09},
        },
		Type  = -1
	},

	helicopter = {
		Size  = vector3(1.5, 1.5, 1.0),
		spawn_coords = {
            {coords = vector3(-724.45751953125,-1443.4455566406,5.000518321991), heading = 139.6},
        },
		Type  = -1
	},

	plane = {
		Size  = vector3(1.5, 1.5, 1.0),
		spawn_coords = {
            {coords = vector3(-974.88, -2967.71, 13.95), heading = 139.6},
        },
		Type  = -1
	},

	boat = {
		Size  = vector3(1.5, 1.5, 1.0),
		spawn_coords = {
            {coords = vector3(-890, -1343.48, 0.12), heading = 194.98},
        },
		Type  = -1
	}
}

