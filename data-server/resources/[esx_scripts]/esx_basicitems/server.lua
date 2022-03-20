local Playertasks = {}
ESX.RegisterUsableItem('use_kevlar_west', function (source)
    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeInventoryItem('use_kevlar_west', 1)
    TriggerClientEvent('basicitems:kevlar', source)
	TriggerEvent('esx_status:set', 'armor', 1000000)
end)


Citizen.CreateThread(function()
	Citizen.Wait(1000)
	while true do
		if Config then
			for k, v in pairs(Config.Drinks) do
				ESX.RegisterUsableItem(v, function(source)
					eat_drink(source, v, 'drink')
				end)
			end
			for k, v in pairs(Config.Foods) do
				ESX.RegisterUsableItem(v, function(source)
					eat_drink(source, v, 'food')
				end)
			end
			break
		end
		Citizen.Wait(1)
	end
end)

function eat_drink(source, itemname, itemtype)
	if not Playertasks[source] then
		Playertasks[source] = {}
	end

	if Playertasks[source].running then 
		TriggerClientEvent('dopeNotify:Alert', source, "", "Das kannst du noch nicht machen", 5000, 'error')
		return
	end

	local xPlayer = ESX.GetPlayerFromId(source)
	local dict

	if itemtype == 'drink' then
		if Config.DrinkAnimations[itemname] then
			dict = Config.DrinkAnimations[itemname]
		else
			dict = Config.DrinkAnimations["default"]
		end
	elseif itemtype == 'food' then
		if Config.FoodAnimations[itemname] then
			dict = Config.FoodAnimations[itemname]
		else
			dict = Config.FoodAnimations["default"]
		end
	end

	Playertasks[source].running = true
	SetTimeout(dict.duration * 1000, function() Playertasks[source] = {} end)

	xPlayer.removeInventoryItem(itemname, 1)

	for k, v in pairs(dict.status) do
		if v.dotype == 'add' then
			TriggerClientEvent('esx_status:add', source, v.status, v.value)
		elseif v.dotype == 'remove' then
			TriggerClientEvent('esx_status:remove', source, v.status, v.value)
		end
	end

	if itemtype == 'drink' then
		TriggerClientEvent('esx_basicitems:onDrink', source, itemname)
	elseif itemtype == 'food' then
		TriggerClientEvent('esx_basicitems:onEat', source, itemname)
	end
end