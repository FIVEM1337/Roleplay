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
    blip = {id = 59, color = 2, scale = 0.8, hiddenForOthers = false},
    locations = {
      vector3(373.875, 325.896, 102.566),
      vector3(373.875, 325.896, 102.566),
			vector3(2557.458, 382.282, 107.622),
			vector3(-3038.939, 585.954, 6.908),
			vector3(-3241.927, 1001.462, 11.830),
			vector3(547.431, 2671.710, 41.156),
			vector3(1961.464, 3740.672, 31.343),
			vector3(26.16, -1347.17, 8.55),
			vector3(2678.916, 3280.671, 54.241),
			vector3(1729.216, 6414.131, 34.037),
    },
    items = {
      {type = 'item', name = 'phone', method = 'money', price = 10},
      {type = 'item', name = 'use_spray', method = 'money', price = 10},
      {type = 'item', name = 'use_repairkit', method = 'money', price = 10},
      {type = 'item', name = 'use_bandage', method = 'money', price = 10},
      {type = 'item', name = 'use_tablet', method = 'money', price = 10},
      {type = 'item', name = 'use_binoculars', method = 'money', price = 10},
      {type = 'item', name = 'use_medikit', method = 'money', price = 10},
      {type = 'item', name = 'use_gps', method = 'money', price = 10},
    }
  },
  ["GunShop"] = {
    label = 'Weapon Shop',
    license = "weapon", -- license name, esx_license required!
    jobs = false, -- set to false to disable whitelisting
    job_grades = false, -- set to false to disable grading
    addon_account_name = false, -- adds to specified account when player buys item, set to false to disable addon_account
    blip = {id = 110, color = 1, scale = 0.8, hiddenForOthers = false},
    locations = {
      vector3(-662.1, -935.3, 20.8),
      vector3(-662.1, -935.3, 20.8),
			vector3(810.2, -2157.3, 28.6),
			vector3(1693.4, 3759.5, 33.7),
			vector3(-330.2, 6083.8, 30.4),
			vector3(252.3, -50.0,  68.9),
			vector3(22.0, -1107.2, 28.8),
			vector3(2567.6, 294.3, 107.7),
			vector3(-1117.5, 2698.6, 17.5),
			vector3(842.4, -1033.4, 27.1),
    },
    items = {
      {type = 'weapon', name = 'WEAPON_HATCHET', method = 'money', price = 3, ammo = 100},
      {type = 'weapon', name = 'WEAPON_DAGGER', method = 'money', price = 3, ammo = 100},
      {type = 'weapon', name = 'WEAPON_SWITCHBLADE', method = 'money', price = 3, ammo = 100},
      {type = 'weapon', name = 'WEAPON_PISTWEAPON_FLASHLIGHTOL', method = 'money', price = 3, ammo = 100},
      {type = 'weapon', name = 'ammo_pistol', method = 'money', price = 3, ammo = 100},
      {type = 'weapon', name = 'ammo_rifle', method = 'money', price = 3, ammo = 100},
      {type = 'weapon', name = 'ammo_shotgun', method = 'money', price = 3, ammo = 100},
      {type = 'weapon', name = 'ammo_smg', method = 'money', price = 3, ammo = 100},
    }
  },
  ["LTDgasonline"] = {
    label = 'LTD',
    license = false, -- license name, esx_license required!
    jobs = false, -- set to false to disable whitelisting
    job_grades = false, -- set to false to disable grading
    addon_account_name = false, -- adds to specified account when player buys item, set to false to disable addon_account
    blip = {id = 415, color = 2, scale = 0.8, hiddenForOthers = false},
    locations = {
			vector3(-48.519, -1757.514, 28.421),
			vector3(1163.373, -323.801, 68.205),
			vector3(-707.501, -914.260, 18.215),
			vector3(-1820.523, 792.518, 137.118),
			vector3(1698.388, 4924.404, 41.063),
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
    }
  },
  ["RobsLiquor"] = {
    label = 'BAR',
    license = false, -- license name, esx_license required!
    jobs = false, -- set to false to disable whitelisting
    job_grades = false, -- set to false to disable grading
    addon_account_name = false, -- adds to specified account when player buys item, set to false to disable addon_account
    blip = {id = 93, color = 25, scale = 0.8, hiddenForOthers = false},
    locations = {
			vector3( 1135.808,  -982.281,  45.415),
			vector3( -1222.915, -906.983,  11.326),
			vector3( -1487.553, -379.107,  39.163),
			vector3( -2968.243, 390.910,   14.043),
			vector3( 1166.024,  2708.930,  37.157),
			vector3( 1392.562,  3604.684,  33.980),
			vector3( 127.830,   -1284.796, 28.280), --StripClub
			vector3( -1393.409, -606.624,  29.319), --Tequila la
			vector3( -559.906,  287.093,   81.176), --Bahammas
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
}