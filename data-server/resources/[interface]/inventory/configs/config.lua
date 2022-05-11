Config = {}

Config.OpenKey = 'i' -- Open key, use letters for FiveM keybinding | default: 'K'
Config.ESXPrefix = "esx" -- this only changes the prefix to core ESX events, not 3rd party scripts | default: "esx"
Config.Blur = true -- Blurs the background | default: true
Config.Delay = 150 -- how long it takes to load inventory in miliseconds | default: 150
Config.DropTimeout = 600 -- how many seconds it takes for a drop to despawn | default: 600 (10 mins)
Config.DropRenderDistance = 20.0 -- how far the drop blip will render | default: 20.0
Config.DropInterval = 60000 -- check drops timeout in miliseconds | default: 60000 (1 min) 
Config.WeaponAnimation = true -- Peform an animation on weapon equip/removal | default: true
Config.CloseOnUse = {"", ""} -- all items in this array when used will close the inventory
Config.CloseOnUseAll = false -- all items when used will close inventory | default: false
Config.UseCharacterName = false -- use character names in give menu | default: true
Config.ClickOutsideToClose = true -- when you click in empty space around the inventory it will close | default: true
Config.UsePlayerID = true -- This will only show the player id in the give menu, by enabling this it will disable UseCharacterName | default: false
Config.CanMultipleView = false -- This will only allow 1 player at a time to access an inventory, this includes drops | default: false
Config.WeightUnits = "kg" -- Adds units next to weight, set to false to disable | default: "kg"
Config.CloseAnimation = true -- Makes character do animation on inventory close | default: true

Config.Items = true -- toggle items | default: true
Config.Weapons = true -- toggle weapons | default: true
Config.Accounts = {"money", "black_money"} -- ESX accounts to display in the inventory | default: {"money", "black_money"}

Config.Hotbar = true -- toggle hotbar | default: true
Config.HotbarKeys = {157, 158, 160, 164, 165} -- fivem key codes | default: {157, 158, 160, 164, 165}
Config.HotbarSave = true -- toggle hotbar database saving | default: true

Config.WeaponWeights = { -- weapons weights for both player and secondary inventory | template: ["weaponName"] = weight
  ["WEAPON_PISTOL"] = 3
}

Config.DiscordLogs = true -- toggle discord logs | default: false
Config.WebhookURL = "https://discord.com/api/webhooks/973992669015576641/9b6Tup5Ra5Dh96noHb-LZAiZ9sC0lHOvemwO6nmIqbW_Uj9_7VLh1aPsPXQ_WKjYeALZ" -- Discord webhook url