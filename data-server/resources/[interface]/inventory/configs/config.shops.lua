Config.Shops = true -- toggle shops plugin | default: true
Config.ShopsBuiltIn = true -- toggle shops built in, add your shops below in Config.ShopLocations | default: false
Config.ShopDelay = 250 -- opening delay of the shop | default: 250
Config.ShopLocations = {
  ["247"] = {
    label = '24/7 Shop',
    license = false, -- license name, esx_license required!
    jobs = false, -- set to false to disable whitelisting
    job_grades = false, -- set to false to disable grading
    addon_account_name = false, -- adds to specified account when player buys item, set to false to disable addon_account
    blip = {id = 59, color = 2, scale = 1.0, hiddenForOthers = false},
    locations = {
      {coord = vector3(373.875, 325.896, 102.566), show = true},
      {coord = vector3(373.875, 325.896, 102.566), show = true},
			{coord = vector3(2557.458, 382.282, 107.622), show = true},
			{coord = vector3(-3038.939, 585.954, 6.908), show = true},
			{coord = vector3(-3241.927, 1001.462, 11.830), show = true},
			{coord = vector3(547.431, 2671.710, 41.156), show = true},
			{coord = vector3(1961.464, 3740.672, 31.343), show = true},
			{coord = vector3(26.16, -1347.17, 8.55), show = true},
			{coord = vector3(2678.916, 3280.671, 54.241), show = true},
			{coord = vector3(1729.216, 6414.131, 34.037), show = true},
    },
    items = {
      {type = 'item', name = 'use_bandage', method = 'money', price = 10},
      {type = 'item', name = 'use_medikit', method = 'money', price = 10},
      {type = 'item', name = 'drink_water', method = 'money', price = 10},
      {type = 'item', name = 'drink_milkshake', method = 'money', price = 10},
      {type = 'item', name = 'food_donut', method = 'money', price = 10},
      {type = 'item', name = 'food_burger', method = 'money', price = 10},
      {type = 'item', name = 'food_sandwich', method = 'money', price = 10},
      {type = 'item', name = 'food_taco', method = 'money', price = 10},
      {type = 'item', name = 'food_hotdog', method = 'money', price = 10},
      {type = 'item', name = 'food_chips', method = 'money', price = 10},
    }
  },
  ["GunShop"] = {
    label = 'Waffenladen',
    license = false, -- license name, esx_license required!
    jobs = false, -- set to false to disable whitelisting
    job_grades = false, -- set to false to disable grading
    addon_account_name = false, -- adds to specified account when player buys item, set to false to disable addon_account
    blip = {id = 110, color = 0, scale = 1.0, hiddenForOthers = false},
    locations = {
      {coord = vector3(-662.1, -935.3, 20.9), show = true},
      {coord = vector3(-662.1, -935.3, 20.9), show = true},
			{coord = vector3(810.2, -2157.3, 28.6), show = true},
			{coord = vector3(1693.4, 3759.5, 33.7), show = true},
			{coord = vector3(-330.2, 6083.8, 30.4), show = true},
			{coord = vector3(252.3, -50.0,  68.9), show = true},
			{coord = vector3(22.0, -1107.2, 28.8), show = true},
			{coord = vector3(2567.6, 294.3, 107.7), show = true},
			{coord = vector3(-1117.5, 2698.6, 17.5), show = true},
			{coord = vector3(842.4, -1033.4, 27.1), show = true},
    },
    items = {
      {type = 'weapon', name = 'WEAPON_HATCHET', method = 'money', price = 3},
      {type = 'weapon', name = 'WEAPON_DAGGER', method = 'money', price = 3},
      {type = 'weapon', name = 'WEAPON_SWITCHBLADE', method = 'money', price = 3},
      {type = 'weapon', name = 'WEAPON_PISTOl', method = 'money', price = 3, ammo = 0},
      {type = 'weapon', name = 'WEAPON_FLASHLIGHT', method = 'money', price = 3},
      {type = 'item', name = 'ammo_pistol', method = 'money', price = 3, ammo = 100},
      {type = 'weapon', name = 'weapon_machete', method = 'money', price = 3},
      {type = 'weapon', name = 'weapon_bat', method = 'money', price = 3},
      {type = 'weapon', name = 'weapon_golfclub', method = 'money', price = 3},
      {type = 'weapon', name = 'weapon_knuckle', method = 'money', price = 3},
      {type = 'weapon', name = 'weapon_nightstick', method = 'money', price = 3},
    }
  },
  ["LTDgasonline"] = {
    label = 'Tankstellenshop',
    license = false, -- license name, esx_license required!
    jobs = false, -- set to false to disable whitelisting
    job_grades = false, -- set to false to disable grading
    addon_account_name = false, -- adds to specified account when player buys item, set to false to disable addon_account
    blip = {id = 361, color = 4, scale = 1.0, hiddenForOthers = true},
    locations = {
			{coord = vector3(-48.519, -1757.514, 28.421), show = true},
			{coord = vector3(1163.373, -323.801, 68.205), show = true},
			{coord = vector3(-707.501, -914.260, 18.215), show = true},
			{coord = vector3(-1820.523, 792.518, 137.118), show = true},
			{coord = vector3(1698.388, 4924.404, 41.063), show = true},
    },
    items = {
      {type = 'item', name = 'drink_water', method = 'money', price = 10},
      {type = 'item', name = 'drink_milkshake', method = 'money', price = 10},
      {type = 'item', name = 'food_donut', method = 'money', price = 10},
      {type = 'item', name = 'food_burger', method = 'money', price = 10},
      {type = 'item', name = 'food_sandwich', method = 'money', price = 10},
      {type = 'item', name = 'food_taco', method = 'money', price = 10},
      {type = 'item', name = 'food_hotdog', method = 'money', price = 10},
      {type = 'item', name = 'food_chips', method = 'money', price = 10},
      {type = 'weapon', name = 'WEAPON_PETROLCAN', method = 'money', price = 10, ammo = 0},
    }
  },
  ["RobsLiquor"] = {
    label = 'Spirituoseladen',
    license = false, -- license name, esx_license required!
    jobs = false, -- set to false to disable whitelisting
    job_grades = false, -- set to false to disable grading
    addon_account_name = false, -- adds to specified account when player buys item, set to false to disable addon_account
    blip = {id = 93, color = 25, scale = 1.0, hiddenForOthers = false},
    locations = {
			{coord = vector3( 1135.808,  -982.281,  45.415), show = true},
			{coord = vector3( -1222.915, -906.983,  11.326), show = true},
			{coord = vector3( -1487.553, -379.107,  39.163), show = true},
			{coord = vector3( -2968.243, 390.910,   14.043), show = true},
			{coord = vector3( 1166.024,  2708.930,  37.157), show = true},
			{coord = vector3( 1392.562,  3604.684,  33.980), show = true},
			{coord = vector3( 127.830,   -1284.796, 28.280), show = false}, --StripClub
			{coord = vector3( -1393.409, -606.624,  29.319), show = false}, --Tequila la
			{coord = vector3( -559.906,  287.093,   81.176), show = false}, --Bahammas
    },
    items = {
      {type = 'item', name = 'drink_whiskey', method = 'money', price = 3},
      {type = 'item', name = 'drink_tequila', method = 'money', price = 3},
      {type = 'item', name = 'drink_rum', method = 'money', price = 3},
      {type = 'item', name = 'drink_shot1', method = 'money', price = 3},
      {type = 'item', name = 'drink_shot2', method = 'money', price = 3},
      {type = 'item', name = 'drink_shot3', method = 'money', price = 3},
      {type = 'item', name = 'drink_shot4', method = 'money', price = 3},
      {type = 'item', name = 'drink_shot5', method = 'money', price = 3},
    }
  },
  ["Schwarzmarkt"] = {
    label = 'Illegaler Handel',
    license = false, -- license name, esx_license required!
    jobs = false, -- set to false to disable whitelisting
    job_grades = false, -- set to false to disable grading
    addon_account_name = false, -- adds to specified account when player buys item, set to false to disable addon_account
    blip = {id = 303, color = 40, scale = 1.0, hiddenForOthers = false},
    locations = {
			{coord = vector3( 57.836044311523,3692.9631347656,38.921283721924), show = true},
    },
    items = {
      {type = 'item', name = 'ammo_rifle', method = 'money', price = 3, ammo = 100},
      {type = 'item', name = 'ammo_shotgun', method = 'money', price = 3, ammo = 100},
      {type = 'item', name = 'ammo_smg', method = 'money', price = 3, ammo = 100},
      {type = 'item', name = 'fish', method = 'money', sellPrice  = 3},
      {type = 'item', name = 'fishing_seestern', method = 'money', sellPrice  = 3},
      {type = 'item', name = 'fishing_delphin', method = 'money', sellPrice  = 3},
      {type = 'item', name = 'diamond', method = 'money', sellPrice = 3},
      {type = 'item', name = 'fishing_goldbarren', method = 'money', sellPrice = 3},
    }
  },
  ["Handyladen"] = {
    label = "Elektronik-Zubehör",
    license = false, -- license name, esx_license required!
    jobs = false, -- set to false to disable whitelisting
    job_grades = false, -- set to false to disable grading
    addon_account_name = false, -- adds to specified account when player buys item, set to false to disable addon_account
    blip = {id = 627, color = 25, scale = 1.0, hiddenForOthers = false},
    locations = {
			{coord = vector3( -657.05114746094,-857.62896728516,23.503044128418), show = true},
    },
    items = {
      {type = 'item', name = 'use_gps', method = 'money', price = 10},
      {type = 'item', name = 'use_tablet', method = 'money', price = 10},
      {type = 'item', name = 'phone', method = 'money', price = 10},
    }
  },
  ["Baumarkt"] = {
    label = "Baumarkt",
    license = false, -- license name, esx_license required!
    jobs = false, -- set to false to disable whitelisting
    job_grades = false, -- set to false to disable grading
    addon_account_name = false, -- adds to specified account when player buys item, set to wfalse to disable addon_account
    blip = {id = 628, color = 25, scale = 1.0, hiddenForOthers = false},
    locations = {
			{coord = vector3(-3156.7119140625,1111.4398193359,19.861461639404), show = true},
    },
    items = {
      {type = 'item', name = 'use_spray', method = 'money', price = 10},
      {type = 'item', name = 'use_repairkit', method = 'money', price = 10},
      {type = 'item', name = 'use_fernglas', method = 'money', price = 10},
      {type = 'item', name = 'use_schere', method = 'money', price = 10},
      {type = 'item', name = 'use_kabelbinder', method = 'money', price = 10},
      {type = 'item', name = 'use_unterbodenbeleuchtung', method = 'money', price = 10},
      {type = 'item', name = 'use_abschleppseil', method = 'money', price = 10},
      {type = 'weapon', name = 'WEAPON_PETROLCAN', method = 'money', price = 10, ammo = 0},
    }
  },
  ["Fishmarkt"] = {
    label = "Fish Handel",
    license = false, -- license name, esx_license required!
    jobs = false, -- set to false to disable whitelisting
    job_grades = false, -- set to false to disable grading
    addon_account_name = false, -- adds to specified account when player buys item, set to wfalse to disable addon_account
    blip = {id = 762, color = 25, scale = 1.0, hiddenForOthers = false},
    locations = {
			{coord = vector3(-1599.6572265625,5201.9868164063,3.3973059654236), show = true},
    },
    items = {
      {type = 'item', name = 'fishingrod', method = 'money', price = 10},
      {type = 'item', name = 'fishbait', method = 'money', price = 10},
    }
  },
}