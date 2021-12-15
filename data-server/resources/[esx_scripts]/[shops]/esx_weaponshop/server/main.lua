ESX = nil
local shopItems = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()

	MySQL.Async.fetchAll('SELECT * FROM weashops', {}, function(result)
		for i=1, #result, 1 do
			if shopItems[result[i].zone] == nil then
				shopItems[result[i].zone] = {}
			end

			table.insert(shopItems[result[i].zone], {
				item    = result[i].item,
				price   = result[i].price,
				label   = ESX.GetWeaponLabel(result[i].item),
				imglink = result[i].imglink,
				zone = result[i].zone,
				desc    = result[i].desc,
				category = result[i].category,
				job = result[i].job
			})
		end

		TriggerClientEvent('esx_weaponshop:sendShop', -1, shopItems)
	end)

end)

ESX.RegisterServerCallback('esx_weaponshop:getShop', function(source, cb)
	cb(shopItems)
end)

ESX.RegisterServerCallback('esx_weaponshop:buyLicense', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= Config.LicensePrice then
		xPlayer.removeMoney(Config.LicensePrice)

		TriggerEvent('esx_license:addLicense', source, 'weapon', function()
			cb(true)
		end)
	else
		xPlayer.showNotification(_U('not_enough'))
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_weaponshop:buyWeapon', function(source, cb, weaponName, zone)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = GetPrice(weaponName, zone)
	local job = GetJob(weaponName, zone)

	if price == 0 then
		print(('esx_weaponshop: %s attempted to buy a unknown weapon!'):format(xPlayer.identifier))
		cb(false)
	else
		if job then
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..job, function(account)
				if account.money >= price then
					account.removeMoney(price)

					TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..job, function(store)
						local weapons = store.get('weapons') or {}
						local foundWeapon = false
				
						for i=1, #weapons, 1 do
							if weapons[i].name == weaponName then
								weapons[i].count = weapons[i].count + 1
								foundWeapon = true
								break
							end
						end
				
						if not foundWeapon then
							table.insert(weapons, {
								name  = weaponName,
								count = 1
							})
						end
				
						store.set('weapons', weapons)
					end)
					cb(true)
				else
					cb(false)
				end
			end)
		else

			if xPlayer.hasWeapon(weaponName) then
				xPlayer.showNotification(_U('already_owned'))
				cb(false)
			else
				if zone == 'BlackWeashop' then
					if xPlayer.getAccount('black_money').money >= price then
						xPlayer.removeAccountMoney('black_money', price)
						xPlayer.addWeapon(weaponName, 42)
					
						cb(true)
					else
						xPlayer.showNotification(_U('not_enough_black'))
						cb(false)
					end
				else
					if xPlayer.getMoney() >= price then
						xPlayer.removeMoney(price)
						xPlayer.addWeapon(weaponName, 42)
					
						cb(true)
					else
						xPlayer.showNotification(_U('not_enough'))
						cb(false)
					end
				end
			end
		end
	end
end)

function GetPrice(weaponName, zone)
	local price = MySQL.Sync.fetchScalar('SELECT price FROM weashops WHERE zone = @zone AND item = @item', {
		['@zone'] = zone,
		['@item'] = weaponName
	})

	if price then
		return price
	else
		return 0
	end
end

function GetJob(weaponName, zone)
	local job = MySQL.Sync.fetchScalar('SELECT job FROM weashops WHERE zone = @zone AND item = @item', {
		['@zone'] = zone,
		['@item'] = weaponName
	})

	if job == "" then
		return nil
	else
		return job
	end
end