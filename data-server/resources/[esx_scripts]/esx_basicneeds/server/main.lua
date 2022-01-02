ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- FOOD @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

ESX.RegisterUsableItem('bread', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('bread', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 200000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	--xPlayer.showNotification(_U('used_bread'))
end)

ESX.RegisterUsableItem('np_torta', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('np_torta', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 400000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	--xPlayer.showNotification(_U('used_bread'))
end)

ESX.RegisterUsableItem('np_torpedo', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('np_torpedo', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 400000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	--xPlayer.showNotification(_U('used_bread'))
end)

ESX.RegisterUsableItem('np_taco', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('np_taco', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 400000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	--xPlayer.showNotification(_U('used_bread'))
end)

ESX.RegisterUsableItem('np_strawberry', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('np_strawberry', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 250000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	--xPlayer.showNotification(_U('used_bread'))
end)

ESX.RegisterUsableItem('np_watermelon', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('np_watermelon', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 250000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	--xPlayer.showNotification(_U('used_bread'))
end)

--DRINK@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

ESX.RegisterUsableItem('water', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('water', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	--xPlayer.showNotification(_U('used_water'))
end)

ESX.RegisterUsableItem('np_milkshake', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('np_milkshake', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 400000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	--xPlayer.showNotification(_U('used_water'))
end)

ESX.RegisterUsableItem('np_shot1', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('np_shot1', 1)

	TriggerClientEvent('esx_status:add', source, 'stress', -10000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	--xPlayer.showNotification(_U('used_water'))
end)

ESX.RegisterUsableItem('np_shot2', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('np_shot2', 1)

	TriggerClientEvent('esx_status:add', source, 'stress', -10000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	--xPlayer.showNotification(_U('used_water'))
end)

ESX.RegisterUsableItem('np_shot3', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('np_shot3', 1)

	TriggerClientEvent('esx_status:add', source, 'stress', -10000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	--xPlayer.showNotification(_U('used_water'))
end)

ESX.RegisterUsableItem('np_shot4', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('np_shot4', 1)

	TriggerClientEvent('esx_status:add', source, 'stress', -10000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	--xPlayer.showNotification(_U('used_water'))
end)

ESX.RegisterUsableItem('np_shot5', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('np_shot5', 1)

	TriggerClientEvent('esx_status:add', source, 'stress', -10000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	--xPlayer.showNotification(_U('used_water'))
end)

ESX.RegisterUsableItem('np_tequila', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('np_tequila', 1)

	TriggerClientEvent('esx_status:add', source, 'stress', -10000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	--xPlayer.showNotification(_U('used_water'))
end)

ESX.RegisterUsableItem('np_whiskey', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('np_whiskey', 1)

	TriggerClientEvent('esx_status:add', source, 'stress', -10000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	--xPlayer.showNotification(_U('used_water'))
end)

ESX.RegisterUsableItem('np_rum', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('np_rum', 1)

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
