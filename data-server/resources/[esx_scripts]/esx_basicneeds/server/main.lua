ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- FOOD @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

ESX.RegisterUsableItem('food_bread', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('food_bread', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 200000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	--xPlayer.showNotification(_U('used_bread'))
end)

ESX.RegisterUsableItem('food_mcrib', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('food_mcrib', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 400000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	--xPlayer.showNotification(_U('used_bread'))
end)

ESX.RegisterUsableItem('food_sandwich', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('food_sandwich', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 400000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	--xPlayer.showNotification(_U('used_bread'))
end)

ESX.RegisterUsableItem('food_taco', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('food_taco', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 400000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	--xPlayer.showNotification(_U('used_bread'))
end)

ESX.RegisterUsableItem('food_watermelon', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('food_watermelon', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 250000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	--xPlayer.showNotification(_U('used_bread'))
end)

--DRINK@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

ESX.RegisterUsableItem('drink_water', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('drink_water', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	--xPlayer.showNotification(_U('used_water'))
end)

ESX.RegisterUsableItem('drink_milkshake', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('drink_milkshake', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 400000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	--xPlayer.showNotification(_U('used_water'))
end)

ESX.RegisterUsableItem('drink_shot1', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('drink_shot1', 1)

	TriggerClientEvent('esx_status:add', source, 'stress', -10000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	--xPlayer.showNotification(_U('used_water'))
end)

ESX.RegisterUsableItem('drink_shot2', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('drink_shot2', 1)

	TriggerClientEvent('esx_status:add', source, 'stress', -10000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	--xPlayer.showNotification(_U('used_water'))
end)

ESX.RegisterUsableItem('drink_shot3', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('drink_shot3', 1)

	TriggerClientEvent('esx_status:add', source, 'stress', -10000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	--xPlayer.showNotification(_U('used_water'))
end)

ESX.RegisterUsableItem('drink_shot4', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('drink_shot4', 1)

	TriggerClientEvent('esx_status:add', source, 'stress', -10000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	--xPlayer.showNotification(_U('used_water'))
end)

ESX.RegisterUsableItem('drink_shot5', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('drink_shot5', 1)

	TriggerClientEvent('esx_status:add', source, 'stress', -10000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	--xPlayer.showNotification(_U('used_water'))
end)

ESX.RegisterUsableItem('drink_tequila', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('drink_tequila', 1)

	TriggerClientEvent('esx_status:add', source, 'stress', -10000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	--xPlayer.showNotification(_U('used_water'))
end)

ESX.RegisterUsableItem('drink_whiskey', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('drink_whiskey', 1)

	TriggerClientEvent('esx_status:add', source, 'stress', -10000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	--xPlayer.showNotification(_U('used_water'))
end)

ESX.RegisterUsableItem('drink_rum', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('drink_rum', 1)

	TriggerClientEvent('esx_status:add', source, 'stress', -10000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	--xPlayer.showNotification(_U('used_water'))
end)







ESX.RegisterCommand('heal', 'admin', function(xPlayer, args, showError)
	args.playerId.triggerEvent('esx_basicneeds:healPlayer')
	args.playerId.triggerEvent('chat:addMessage', {args = {'^5HEAL', 'You have been healed.'}})
end, true, {help = 'Heal a player, or yourself - restores thirst, hunger and health.', validate = true, arguments = {
	{name = 'playerId', help = 'the player id', type = 'player'}
}})
