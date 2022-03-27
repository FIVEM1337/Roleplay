local Playertasks = {}
CreateThread(function()
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
		Wait(1)
	end
end)

function eat_drink(source, itemname, itemtype)
	local xPlayer = ESX.GetPlayerFromId(source)
	local dict

	running = CheckTaskStatus(source)
	if running then
		return
	end

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
	SetTimeout(dict.duration * 1000, function() Playertasks[source].running = false end)
end


ESX.RegisterUsableItem('use_repairkit', function(source)
	local source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	running = CheckTaskStatus(source)
	if running then
		return
	end

	TriggerClientEvent('esx_basicitems:onRepairkit', source)
	SetTimeout(Config.RepairkitUseTime * 1000, function() Playertasks[source].running = false end)
end)

ESX.RegisterUsableItem('use_medikit', function(source)
	local source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	running = CheckTaskStatus(source)
	if running then
		return
	end
	
	TriggerClientEvent('esx_basicitems:onUseHeal', source, 'use_medikit')
	SetTimeout(Config.HealUseTime * 1000, function() Playertasks[source].running = false end)
end)

ESX.RegisterUsableItem('use_bandage', function(source)
	local source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	running = CheckTaskStatus(source)
	if running then
		return
	end

	TriggerClientEvent('esx_basicitems:onUseHeal', source, 'use_bandage')
	SetTimeout(Config.HealUseTime * 1000, function() Playertasks[source].running = false end)
end)

ESX.RegisterUsableItem('use_kevlar_west', function (source)
    local xPlayer = ESX.GetPlayerFromId(source)

	running = CheckTaskStatus(source)
	if running then
		return
	end

    TriggerClientEvent('esx_basicitems:onUseKevlar', source)
	SetTimeout(Config.KevlarUseTime * 1000, function() Playertasks[source].running = false end)
end)


ESX.RegisterUsableItem('use_tablet', function(source)
	local source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	TriggerClientEvent('esx_basicitems:onUseTablet', source)
end)

RegisterNetEvent('esx_basicitems:removeItem')
AddEventHandler('esx_basicitems:removeItem', function(item, count)
	local source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem(item, count)
end)

ESX.RegisterServerCallback('esx_basicitems:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)

	cb(xPlayer.getInventoryItem(item).count)
end)

function CheckTaskStatus(source)
	if not Playertasks[source] then
		Playertasks[source] = {}
	end
	if Playertasks[source].running then 
		TriggerClientEvent('dopeNotify:Alert', source, "", "Das kannst du noch nicht machen", 5000, 'error')
		return true
	end
	Playertasks[source].running = true
	return false
end


RegisterNetEvent('esx_basicitems:stopTask')
AddEventHandler('esx_basicitems:stopTask', function()
	local source = source

	if not Playertasks[source] then
		Playertasks[source] = {}
	end

	if Playertasks[source].running then 
		Playertasks[source].running = false
	end
end)