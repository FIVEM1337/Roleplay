Config                            = {}
Config.DrawDistance               = 50.0
Config.MarkerColor                = { r = 255, g = 0, b = 0 }
Config.EnableOwnedVehicles        = true
Config.ResellPercentage           = 50

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
		Pos   = vector3(-43.51, -1105.47, 26.20),
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
		Pos   = vector3(-714.55, -1403.35, 5),
		Size  = vector3(1.5, 1.5, 1.0),
		Type  = 36,
		VehType = "helicopter"
	},



	-- Vehicle Spawns
	car = {
		Size  = vector3(1.5, 1.5, 1.0),
		spawn_coords = {
            {coords = vector3(-27.6, -1082.4, 26.2), heading = 69.66},
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
            {coords = vector3(-974.88, -2967.71, 13.95), heading = 139.6},
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
	},

	ResellVehicle = {
		VehicleSell = true,
		Pos   = vector3(-46.14, -1082.73, 25.74),
		Size  = vector3(3.0, 3.0, 1.0),
		Type  = 1
	}
}

