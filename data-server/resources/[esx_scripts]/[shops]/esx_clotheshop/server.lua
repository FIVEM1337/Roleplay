ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('esx_clotheshop:buy')
AddEventHandler('esx_clotheshop:buy', function()

    local xPlayer = ESX.GetPlayerFromId(source)


    if xPlayer.getMoney() >= Config.Price then

        TriggerClientEvent('esx_clotheshop:confirm', source, true)
        xPlayer.removeMoney(Config.Price)

    else
        TriggerClientEvent('esx_clotheshop:confirm', source, false)
    end

end)

ESX.RegisterServerCallback('esx_clotheshop:checkHavePropertyStore', function(source, cb)

  local found = false
  local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		found = true
	end)

	cb(found)

end)

RegisterServerEvent('esx_clotheshop:saveOutfit')
AddEventHandler('esx_clotheshop:saveOutfit', function(label, skinRes)

  local xPlayer = ESX.GetPlayerFromId(source)
	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)

		local dressing = store.get('dressing')

		if dressing == nil then
			dressing = {}
		end

		table.insert(dressing, {
			label = label,
			skin  = skinRes
		})

		store.set('dressing', dressing)

	end)

end)

ESX.RegisterServerCallback('esx_clotheshop:getPlayerOutfit', function(source, cb, num)

  local xPlayer  = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
    local outfit = store.get('dressing', num)
    cb(outfit.skin)
  end)

end)

RegisterServerEvent('esx_clotheshop:removeOutfit')
AddEventHandler('esx_clotheshop:removeOutfit', function(index)

    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)

        local dressing = store.get('dressing')

        if dressing == nil then
            dressing = {}
        end

        index = index
        
        table.remove(dressing, index)

        store.set('dressing', dressing)

    end)

end)

ESX.RegisterServerCallback('esx_clotheshop:getPlayerDressing', function(source, cb)

  local xPlayer  = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)

    local count    = store.count('dressing')
    local labels   = {}

    for i=1, count, 1 do
      local entry = store.get('dressing', i)
      table.insert(labels, entry.label)
    end

    cb(labels)

  end)

end)

RegisterServerEvent('skin:save')
AddEventHandler('skin:save', function(skin)

  local xPlayer = ESX.GetPlayerFromId(source)
	
--print(steamID)
  MySQL.Async.execute(
    'UPDATE users SET `skin` = @skin WHERE identifier = @identifier',
    {
      ['@skin']       = json.encode(skin),
      ['@identifier'] = xPlayer.identifier
    }
  )

end)