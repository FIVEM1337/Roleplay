ESX             = nil
local ShopItems = {}
local hasSqlRun = false

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Load items
AddEventHandler('onMySQLReady', function()
	hasSqlRun = true
	LoadShop()
end)

-- extremely useful when restarting script mid-game
Citizen.CreateThread(function()
	Citizen.Wait(2000) -- hopefully enough for connection to the SQL server

	while true do
		LoadShop()
		Citizen.Wait(20000)
	end
end)

function LoadShop()
	ShopItems = {}
	local itemResult = MySQL.Sync.fetchAll('SELECT * FROM items')
	local shopResult = MySQL.Sync.fetchAll('SELECT * FROM shops')
	local itemInformation = {}
	for i=1, #itemResult, 1 do

		if itemInformation[itemResult[i].name] == nil then
			itemInformation[itemResult[i].name] = {}
		end

		itemInformation[itemResult[i].name].label = itemResult[i].label
		itemInformation[itemResult[i].name].limit = itemResult[i].limit
	end

	for i=1, #shopResult, 1 do
		if ShopItems[shopResult[i].store] == nil then
			ShopItems[shopResult[i].store] = {}
		end

		if itemInformation[shopResult[i].item] == nil then
			table.insert(ShopItems[shopResult[i].store], {
				label = ESX.GetWeaponLabel(shopResult[i].item),
				item  = shopResult[i].item,
				price = shopResult[i].price,
				limit = 2,
				moneytype = shopResult[i].moneytype
			})
		else
			if itemInformation[shopResult[i].item].limit == -1 then
				itemInformation[shopResult[i].item].limit = 30
			end

			table.insert(ShopItems[shopResult[i].store], {
				label = itemInformation[shopResult[i].item].label,
				item  = shopResult[i].item,
				price = shopResult[i].price,
				limit = itemInformation[shopResult[i].item].limit,
				moneytype = shopResult[i].moneytype
			})
		end
	end
end

ESX.RegisterServerCallback('esx_shops:requestDBItems', function(source, cb)
	cb(ShopItems)
end)
