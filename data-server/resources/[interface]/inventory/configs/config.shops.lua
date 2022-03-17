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
    },
    items = {
      {type = 'item', name = 'bread', method = 'money', price = 10, sellPrice = 1},
      {type = 'item', name = 'water', method = 'money', price = 10, sellPrice = 1},
      {type = 'weapon', name = 'WEAPON_KNIFE', method = 'money', price = 30, sellPrice = 20},
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
    },
    items = {
      {type = 'weapon', name = 'WEAPON_PISTOL', method = 'money', price = 3, sellPrice = 1, ammo = 100},
    }
  }
}