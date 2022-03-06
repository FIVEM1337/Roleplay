local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
end)

local properties = {}
local propertyOwner = {}
local playersInProperties = {}
local playersonline = {}
local highestid = 0

MySQL.ready( function()
  MySQL.Async.fetchAll('SELECT * from prop', {},
      function(result)
          if #result > 0 then
              for k, prop_result in pairs(result) do
                  table.insert(properties, {
                      id = prop_result.id,
                      name = prop_result.name,
                      label = prop_result.label,
                      entering = json.decode(prop_result.entering),
                      inside = json.decode(prop_result.inside),
                      room_menu = json.decode(prop_result.room_menu),
                      ipls = prop_result.ipls,
                      is_single = prop_result.is_single,
                      is_unique = prop_result.is_unique,
                      type = prop_result.type,
                      is_buyable = prop_result.is_buyable,
                      price = prop_result.price,
                      depends = prop_result.depends,
                  })
              end

          end
      end
  )


  MySQL.Async.fetchAll('SELECT * from prop_owner', {},
      function(result)
          if #result > 0 then
              for k, prop_owner_result in pairs(result) do
                  table.insert(propertyOwner, {
                      id = prop_owner_result.id,
                      owner = prop_owner_result.owner,
                      charname = prop_owner_result.charactername,
                      property = prop_owner_result.property,
                      price = prop_owner_result.price,
                      rented = prop_owner_result.rented,
                      trusted = json.decode(prop_owner_result.trusted),
                      locked = prop_owner_result.locked,
                      deposit = prop_owner_result.deposit,
                      blackMoneyDeposit = prop_owner_result.blackMoneyDeposit,
                  })
                  highestid = prop_owner_result.id
              end

          end
      end
  )
end)

RegisterServerEvent('esx_properties:updateIdentifier')
AddEventHandler('esx_properties:updateIdentifier', function(src, oldidentifier, newidentifier)
	
	for k, prop in pairs(propertyOwner) do
		for k2, trust in pairs(prop.trusted) do
			if trust.steamID == oldidentifier then
				trust.steamID = newidentifier
				MySQL.Async.execute('UPDATE prop_owner SET trusted=@trusted WHERE id=@PROPID LIMIT 1',
				{
                ['@trusted'] = json.encode(prop.trusted),
                ['@PROPID'] = prop.id
				})
			end
		end
		if prop.owner == oldidentifier then
			prop.owner = newidentifier
		end
		
	
	end

end)

ESX.RegisterServerCallback('esx_properties:receiveAllPropertiesFromPlayer', function(source, cb)
  local steamID = GetPlayerIdentifiers(source)[1]
  if Config.useNewESX then
	 for k, v in ipairs(GetPlayerIdentifiers(source)) do
	   if string.match(v, "license:") then
		  steamID = string.gsub(v, "license:", "")
		  break
	   end
	end
  end
--local xPlayer = ESX.GetPlayerFromId(source)

  local owned = {}

  for k, v in pairs(propertyOwner) do
	--print('compare ' .. v.owner .. ' and ' .. steamID)
    if v.owner == steamID then

      for k2, v2 in pairs(properties) do

        if v.property == v2.name then
          table.insert(owned, {
            label = v2.label,
            coords = v2.entering,
          })
          break
        end

      end

    end

  end

  cb(owned)


end)

RegisterServerEvent('esx_properties:saveLastProperty')
AddEventHandler('esx_properties:saveLastProperty', function(property)
  
  local xPlayer = ESX.GetPlayerFromId(source)
  MySQL.Async.execute(
    'UPDATE users SET last_property = @property WHERE identifier = @identifier', {
      ['@property'] = property, 
      ['@identifier'] = xPlayer.identifier, 
  })


end)

RegisterServerEvent('esx_properties:getProperties')
AddEventHandler('esx_properties:getProperties', function()

    if source ~= nil then
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
		if xPlayer ~= nil then
			TriggerClientEvent('esx_properties:sendPropertiesToClient', _source, properties, propertyOwner, xPlayer.identifier)
		end
    end


end)

RegisterServerEvent('esx_properties:getPlayerProperties')
AddEventHandler('esx_properties:getPlayerProperties', function(dest, owner)

	local ownedPropFromPlayer = {}
    for k, v in pairs(propertyOwner) do
		--print(v.owner .. owner)
		if v.owner == owner then
			table.insert(ownedPropFromPlayer, v.id)
		end
		for k2, trust in pairs(v.trusted) do
			if trust.steamID == owner then
				table.insert(ownedPropFromPlayer, v.id)
				break
			end
		end
		if k == #propertyOwner then
			if dest == 'addon' then
				TriggerEvent('esx_addoninventory:receiveProperties', ownedPropFromPlayer)
			elseif dest == 'data' then
				TriggerEvent('esx_datastore:receiveProperties', ownedPropFromPlayer)
			end
		end
	
	end

end)


-- OneSync getPlayers

ESX.RegisterServerCallback('esx_properties:getPlayersInArea', function(source, cb, position, distance)
  local p = GetPlayers()
  local players = {}
  local vecposition = vector3(position.x, position.y, position.z)
  if(#p > 0) then
      for index, playerID in ipairs(p) do
          local player = ESX.GetPlayerFromId(playerID)
		  if player ~= nil then
			  local coords = player.getCoords(true)
			  if #(vecposition - coords) < distance then
				  local playerInfo = {id = playerID, name = player.getName()}
				  table.insert(players, playerInfo)
			  end
		  else
		  end
      end
  end
  cb(players)
end)


--

RegisterServerEvent('esx_properties:enterProperty')
AddEventHandler('esx_properties:enterProperty', function(propertyID, propertyData)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)	
	
	if Config.useRoutingBuckets then
		SetPlayerRoutingBucket(_source, tonumber(propertyID))
	end
	
	if #playersInProperties > 0 then
		for k, property in pairs(playersInProperties) do
			if property.propid == propertyID then
				if property.player ~= _source then
					local playerEnter = ESX.GetPlayerFromId(_source)
					--TriggerClientEvent('esx_properties:msg', property.player, playerEnter.name .. ' hat die Wohnung ~g~betreten~s~!')
					TriggerClientEvent('esx_properties:picturemsg', property.player, 'CHAR_MULTIPLAYER', playerEnter.name .. Translation[Config.Locale]['has_entered_prop'] , Translation[Config.Locale]['prop'], Translation[Config.Locale]['doorbell_title'])
					TriggerClientEvent('esx_properties:setPlayerVisible', property.player, _source)
					if Config.useRoutingBuckets then
						SetPlayerRoutingBucket(property.player, tonumber(propertyID))
					end
				end
			else
				if property.player ~= _source then
					TriggerClientEvent('esx_properties:setPlayerInvisible', property.player, _source, propertyID)
					TriggerClientEvent('esx_properties:setPlayerInvisible', _source, property.player, propertyID)
				end
			end
		end
	end
	for k3, property in pairs(playersInProperties) do
		if property.name == xPlayer.name then
			table.remove(playersInProperties, k3)
			break
		end
	end
    table.insert(playersInProperties, {
        propid = propertyID,
        property = propertyData.name,
        player = _source,
        name = xPlayer.name,
    })

    TriggerClientEvent('esx_properties:enterProperty', _source, propertyData)

end)

RegisterServerEvent('esx_properties:leaveProperty')
AddEventHandler('esx_properties:leaveProperty', function(propertyData)

    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)	
	
    for k, property in pairs(playersInProperties) do
        if property.name == xPlayer.name then
			if Config.useRoutingBuckets then
				SetPlayerRoutingBucket(property.player, 0)
			end
            table.remove(playersInProperties, k)
            break
        end
    end

    TriggerClientEvent('esx_properties:leaveProperty', _source, propertyData)

end)

RegisterServerEvent('esx_properties:invitePlayer')
AddEventHandler('esx_properties:invitePlayer', function(target, propertyID, propertyData)

    TriggerClientEvent('esx_properties:msg', target, Translation[Config.Locale]['invite_msg'] .. propertyData.label .. Translation[Config.Locale]['invite_msg2'])
    TriggerClientEvent('esx_properties:hasInvitation', target, propertyID, propertyData)

end)

RegisterServerEvent('esx_properties:updateTrusted')
AddEventHandler('esx_properties:updateTrusted', function(type, trustedPlayer, propertyID)
    if source ~= nil then
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local charname = 'Unknown'
        local trusted = nil
        local trustedPlayerFinal = trustedPlayer

        if type == "add" then
            trustedPlayerFinal = ESX.GetPlayerFromId(trustedPlayer).identifier
        end

        MySQL.Async.fetchAll('SELECT firstname, lastname from users WHERE identifier = @identifier', {
            ['@identifier'] = trustedPlayerFinal
        },
        function(result)
            if #result > 0 then
                charname = result[1].firstname .. " " .. result[1].lastname
            end
        end)

        while charname == 'Unknown' do
            Wait(10)
        end

        local editedLine = 0

        for k, v in pairs(propertyOwner) do
            if v.id == propertyID then
                if (type == "del") then
                    for i = 1, #v.trusted, 1 do
                        if (v.trusted[i].steamID == trustedPlayerFinal) then
                            table.remove(v.trusted, i)
							              break
                        end
                    end
                elseif (type == "add") then
                    table.insert(v.trusted, {steamID = trustedPlayerFinal, name = charname})
                end
                editedLine = k
                trusted = v.trusted
				        break
            end
        end
		
        if (trusted ~= nil) then
            MySQL.Async.execute('UPDATE prop_owner SET trusted=@trusted WHERE id=@PROPID LIMIT 1',
            {
                ['@trusted'] = json.encode(trusted),
                ['@PROPID'] = propertyID
            })
        end

        local players = ESX.GetPlayers()

        for k, player in pairs(players) do
            local xPlayer2 = ESX.GetPlayerFromId(player)
            if xPlayer2.identifier == trustedPlayerFinal then
                --TriggerClientEvent('esx_properties:sendPropertiesToClient', player, properties, propertyOwner, xPlayer2.identifier)
                TriggerClientEvent('esx_properties:updatePropertyOwner', player, editedLine, propertyOwner[editedLine], xPlayer2.identifier)
                if type == "add" then
                    TriggerClientEvent('esx_properties:picturemsg', player, 'CHAR_MULTIPLAYER', Translation[Config.Locale]['got_key'], Translation[Config.Locale]['prop'], Translation[Config.Locale]['got_permission'])
                elseif type == "del" then
                    TriggerClientEvent('esx_properties:picturemsg', player, 'CHAR_MULTIPLAYER', Translation[Config.Locale]['removed_key'], Translation[Config.Locale]['prop'], Translation[Config.Locale]['remove_permission'])
                end
                break
            end
        end
        --TriggerClientEvent('esx_properties:sendPropertiesToClient', _source, properties, propertyOwner, xPlayer.identifier)
        TriggerClientEvent('esx_properties:updatePropertyOwner', _source, editedLine, propertyOwner[editedLine], xPlayer.identifier)
        if type == "del" then
            TriggerClientEvent('esx_properties:picturemsg', _source, 'CHAR_MULTIPLAYER', Translation[Config.Locale]['remove_key'] .. charname .. Translation[Config.Locale]['remove_key2'], Translation[Config.Locale]['prop'], Translation[Config.Locale]['remove_permission'])
        elseif type == "add" then
            TriggerClientEvent('esx_properties:picturemsg', _source, 'CHAR_MULTIPLAYER', Translation[Config.Locale]['give_key_msg'] .. charname .. Translation[Config.Locale]['give_key_msg2'], Translation[Config.Locale]['prop'], Translation[Config.Locale]['got_permission'])
        end
    end
end)

RegisterServerEvent('esx_properties:saveLockState')
AddEventHandler('esx_properties:saveLockState', function(propertyID, lock)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  MySQL.Async.execute('UPDATE prop_owner SET locked=@locked WHERE id=@PROPID LIMIT 1',
  {
      ['@locked'] = lock,
      ['@PROPID'] = propertyID,
  })

  local editedLine = 0

  for k, v in pairs(propertyOwner) do
    if v.id == propertyID then

      propertyOwner[k].locked = lock
      editedLine = k
      break

    end
  end

  --TriggerClientEvent('esx_properties:updatePropertyOwner', _source, editedLine, propertyOwner[editedLine], xPlayer.identifier)
  TriggerClientEvent('esx_properties:updateLockState', -1, editedLine, lock)

end)

ESX.RegisterServerCallback('esx_properties:getPlayerDressing', function(source, cb)

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

  ESX.RegisterServerCallback('esx_properties:getPlayerOutfit', function(source, cb, num)

    local xPlayer  = ESX.GetPlayerFromId(source)
  
    TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
      local outfit = store.get('dressing', num)
      cb(outfit.skin)
    end)
  
  end)

  RegisterServerEvent('esx_properties:removeOutfit')
  AddEventHandler('esx_properties:removeOutfit', function(index)
  
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

  ESX.RegisterServerCallback('esx_properties:getPropertyInventory', function(source, cb, owner)

    local xPlayer    = ESX.GetPlayerFromIdentifier(owner)
    --local xPlayerOwner = ESX.GetPlayerFromIdentifier(owner)
    --local Money = 0
    local items      = {}
    local weapons    = {}
  
     --[[TriggerEvent('esx_addonaccount:getAccount', 'property_money', xPlayer.identifier, function(account)
        Money = account.money
     end)--]]
  
    TriggerEvent('esx_addoninventory:getInventory', 'property', owner, function(inventory)
	  if inventory ~= nil then
		items = inventory.items
	  end
    end)
  
    TriggerEvent('esx_datastore:getDataStore', 'property', owner, function(store)
	  local storeWeapons
      if store ~= nil then
		storeWeapons = store.get('weapons')
	  end
	  
      if storeWeapons ~= nil then
        weapons = storeWeapons
      end
  
    end)
  
    cb({
      --money      = Money,
      items      = items,
      weapons    = weapons
    })
  
  end)
  
  ESX.RegisterServerCallback('esx_properties:getPlayerInventory', function(source, cb)
  
    local xPlayer    = ESX.GetPlayerFromId(source)
    --local money      = xPlayer.money
    local items      = xPlayer.inventory
  
    cb({
      --money = money,
      items = items
    })
  
  end)

RegisterServerEvent('esx_properties:getItem')
AddEventHandler('esx_properties:getItem', function(owner, type, item, count)

	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)
	local xPlayerOwner = ESX.GetPlayerFromIdentifier(owner)

	if type == 'item_standard' then
		local sourceItem = xPlayer.getInventoryItem(item)
		TriggerEvent('esx_addoninventory:getInventory', 'property', owner, function(inventory)

			-- is there enough in the property?
			if count > 0 and inventory.getItem(item).count >= count then
			
				-- can the player carry the said amount of x item?
				if not Config.useESXCountSystem then
					--if xPlayer.canCarryItem(sourceItem, count) then
					inventory.removeItem(item, count)
					xPlayer.addInventoryItem(item, count)
					--else
					--	TriggerClientEvent('esx:showNotification', _source, Translation[Config.Locale]['too_heavy'])
					--end
				else
					if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
						TriggerClientEvent('esx:showNotification', _source, Translation[Config.Locale]['too_heavy'])
					else
						inventory.removeItem(item, count)
						xPlayer.addInventoryItem(item, count)
					end
				end
				
			else
				TriggerClientEvent('esx:showNotification', _source, Translation[Config.Locale]['not_enough_stored'])
			end
		end)
	end

  --[[if type == 'item_account' then

    TriggerEvent('esx_addonaccount:getAccount', 'property_' .. item, xPlayer.identifier, function(account)

      local roomAccountMoney = account.money

      if roomAccountMoney >= count then
        account.removeMoney(count)
        xPlayer.addAccountMoney(item, count)
      else
        TriggerClientEvent('esx:showNotification', _source, _U('amount_invalid'))
      end

    end)

  end--]]

  if type == 'item_weapon' then

    TriggerEvent('esx_datastore:getDataStore', 'property', owner, function(store)

      local storeWeapons = store.get('weapons')

      if storeWeapons == nil then
        storeWeapons = {}
      end

      local weaponName   = nil
      local ammo         = nil

      for i=1, #storeWeapons, 1 do
        if storeWeapons[i].name == item then

          weaponName = storeWeapons[i].name
          ammo       = storeWeapons[i].ammo

          table.remove(storeWeapons, i)

          break
        end
      end

      store.set('weapons', storeWeapons)

      xPlayer.addWeapon(weaponName, ammo)

    end)

  end

end)

RegisterServerEvent('esx_properties:putItem')
AddEventHandler('esx_properties:putItem', function(owner, type, item, count)

  local _source      = source
  local xPlayer      = ESX.GetPlayerFromId(_source)
  local xPlayerOwner = ESX.GetPlayerFromIdentifier(owner)

  if type == 'item_standard' then

    local playerItemCount = xPlayer.getInventoryItem(item).count

    if count > 0 and playerItemCount >= count then

      TriggerEvent('esx_addoninventory:getInventory', 'property', owner, function(inventory)
        if inventory ~= nil then
          inventory.addItem(item, count)
          xPlayer.removeInventoryItem(item, count)
        else
          TriggerClientEvent('esx:showNotification', _source, Translation[Config.Locale]['need_restart_addoninventory'])
		  --print('esx_properties: Be sure you have the modified esx_addoninventory and esx_datastore running! If you already have, ignore this.')
        end
      end)
	  
	  

    else
      TriggerClientEvent('esx:showNotification', _source, Translation[Config.Locale]['wrong_input'])
    end

  end

  --[[if type == 'item_account' then

    local playerAccountMoney = xPlayer.getAccount(item).money

    if playerAccountMoney >= count then

      xPlayer.removeAccountMoney(item, count)

      TriggerEvent('esx_addonaccount:getAccount', 'property_' .. item, xPlayer.identifier, function(account)
        account.addMoney(count)
      end)

    else
      TriggerClientEvent('esx:showNotification', _source, _U('amount_invalid'))
    end

  end--]]

  if type == 'item_weapon' then

    TriggerEvent('esx_datastore:getDataStore', 'property', owner, function(store)
	  local storeWeapons
	  if store ~= nil then
		  storeWeapons = store.get('weapons')
	  end
	  
	  if storeWeapons == nil then
		storeWeapons = {}
	  end

	  table.insert(storeWeapons, {
		name = item,
		ammo = count
	  })
	  
	  if store ~= nil then
		store.set('weapons', storeWeapons)
		xPlayer.removeWeapon(item)
	  else
		TriggerClientEvent('esx:showNotification', _source, Translation[Config.Locale]['need_restart_addoninventory'])
	  end

    end)

  end

end)

ESX.RegisterServerCallback('esx_properties:getPlayerInventory', function(source, cb)

  local xPlayer    = ESX.GetPlayerFromId(source)
--  local blackMoney = xPlayer.getAccount('black_money').money
  local items      = xPlayer.inventory

  cb({
--    blackMoney = blackMoney,
    items      = items
  })

end)

function SetPropertyOwned(name, price, rented, owner)

  local charname = 'Unknown'

  MySQL.Async.fetchAll('SELECT firstname, lastname from users WHERE identifier = @identifier', {
    ['@identifier'] = owner
  },
  function(result)
      if #result > 0 then
          charname = result[1].firstname .. " " .. result[1].lastname
      end
  end)

  for i=1, 10, 1 do
    if charname == 'Unknown' then
      Wait(10)
    else
      break
    end
  end


  MySQL.Async.execute(
    'INSERT INTO prop_owner (id, owner, charactername, property, price, rented, trusted) VALUES (@id, @owner, @charactername, @property, @price, @rented, @trusted)', {
      ['@id'] = highestid +1, 
      ['@owner'] = owner,
      ['@charactername'] = charname,
      ['@property'] = name,
      ['@price'] = price,
      ['@rented'] = (rented and 1 or 0),
      ['@trusted'] = '[]',
  })
  highestid = highestid + 1

  table.insert(propertyOwner, {
    id = highestid, 
    owner = owner,
    charname = charname,
    property = name,
    price = price,
    rented = (rented and 1 or 0),
    trusted = {},
	  deposit = 0,
    blackMoneyDeposit = 0,
  })

    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
      local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
      if xPlayer.identifier == owner then
        if rented then
          TriggerClientEvent('esx_properties:msg', xPlayer.source, Translation[Config.Locale]['prop_successfully_rented'] .. price .. Translation[Config.Locale]['rented_2'])
        else
          TriggerClientEvent('esx_properties:msg', xPlayer.source, Translation[Config.Locale]['prop_successfully_bought'] .. price .. Translation[Config.Locale]['bought_2'])
        end
        TriggerClientEvent('esx_properties:sendPropertiesToClient', xPlayer.source, properties, propertyOwner, xPlayer.identifier)
		--TriggerClientEvent('esx_properties:sendPropertiesToClient', -1, properties, propertyOwner, xPlayer.identifier)
      end
    end
end

function RemoveOwnedProperty(property, owner)

  MySQL.Async.execute(
    'DELETE FROM prop_owner WHERE property = @name AND owner = @owner',
    {
      ['@name']  = property,
      ['@owner'] = owner
    },
    function(rowsChanged)

      local xPlayers = ESX.GetPlayers()

      for k, v in pairs(propertyOwner) do
        if ((v.owner == owner) and (v.property == property)) then
          table.remove(propertyOwner, k)
        end
      end

      for i=1, #xPlayers, 1 do

        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if xPlayer.identifier == owner then
          TriggerClientEvent('esx_properties:sendPropertiesToClient', xPlayer.source, properties, propertyOwner, xPlayer.identifier)
          TriggerClientEvent('esx_properties:msg', xPlayer.source, Translation[Config.Locale]['prop_canceled'])
          break
        end
      end

    end
  )

end


RegisterServerEvent('esx_properties:setPropertyOwned')
AddEventHandler('esx_properties:setPropertyOwned', function(name, price, rented, owner)
  if owner == 'SOURCE' then
    local xPlayer = ESX.GetPlayerFromId(source)
    SetPropertyOwned(name, price, rented, xPlayer.identifier)
  else
    SetPropertyOwned(name, price, rented, owner)
  end
  
end)

RegisterServerEvent('esx_properties:RemoveOwnedProperty')
AddEventHandler('esx_properties:RemoveOwnedProperty', function(name, owner)
  if owner == 'SOURCE' then
    local xPlayer = ESX.GetPlayerFromId(source)
    RemoveOwnedProperty(name, xPlayer.identifier)
  else
    RemoveOwnedProperty(name, owner)
  end
  
end)

RegisterServerEvent('esx_properties:pay')
AddEventHandler('esx_properties:pay', function(amount)

  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addMoney(amount)

end)

RegisterServerEvent('esx_properties:buy')
AddEventHandler('esx_properties:buy', function(propname, buyorrent, amount)

  local xPlayer = ESX.GetPlayerFromId(source)

  for k, v in pairs(propertyOwner) do
	if v.property == propname then
		for k2, v2 in pairs(properties) do
			if v2.name == propname and v2.is_unique then
				TriggerClientEvent('esx_properties:msg', xPlayer.source, Translation[Config.Locale]['prop_not_available'])
				return
			end
		end
		break
	end
  end
  
  if xPlayer.getMoney() >= amount then
	xPlayer.removeMoney(amount)
	if buyorrent == "BUY" then
		TriggerEvent('esx_properties:setPropertyOwned', propname, amount, false, xPlayer.identifier)
	elseif buyorrent == "RENT" then
		TriggerEvent('esx_properties:setPropertyOwned', propname, amount, true, xPlayer.identifier)
	end
  else
	TriggerClientEvent('esx_properties:msg', xPlayer.source, Translation[Config.Locale]['not_enough_money'])
  end

end)
-- PAY RENT
RegisterServerEvent('esx_properties:registerPlayer')
AddEventHandler('esx_properties:registerPlayer', function()
  local steamID = GetPlayerIdentifier(source)
  local playeralreadyinserted = false

	if steamID ~= nil then

		for i = 0, #playersonline, 1 do
			if playersonline[i] == steamID then
				playeralreadyinserted = true
				break
			else
				playeralreadyinserted = false
			end
		end

		if not playeralreadyinserted then
			table.insert(playersonline, steamID)
		end

	end
end)



function PayRent(d, h, m)

	  for p=1, #playersonline, 1 do

		  MySQL.Async.fetchAll(
			'SELECT * FROM prop_owner WHERE rented = 1 and owner = @owner',
			{
				['@owner'] = playersonline[p]
			},
			function(result)

			  local xPlayers = ESX.GetPlayers()

			  for i=1, #result, 1 do

				local foundPlayer = false
				local xPlayer     = nil

				for j=1, #xPlayers, 1 do

				  local xPlayer2 = ESX.GetPlayerFromId(xPlayers[j])

				  if xPlayer2.identifier == result[i].owner then
            foundPlayer = true
            xPlayer     = xPlayer2
          end
          
				end

				if foundPlayer then
				  xPlayer.removeMoney(result[i].price)
				  TriggerClientEvent('esx:showNotification', xPlayer.source, Translation[Config.Locale]['rent_paid'] .. result[i].price .. Translation[Config.Locale]['rent_paid2'])
				else
          -- remove money in database
          if Config.useNewESX then
            MySQL.Async.fetchAll('SELECT accounts from users WHERE identifier = @identifier', {
                ['@identifier'] = playersonline[p]
            },
            function(usersResult)
                if #usersResult > 0 then
                    local accountsData = json.decode(usersResult[1].accounts)
                    accountsData.money = accountsData.money - result[i].price
                    local newAccountsData = json.encode(accountsData)
                    MySQL.Async.execute('UPDATE users SET accounts=@accounts WHERE identifier=@identifier',
                    {
                        ['@accounts'] = newAccountsData,
                        ['@identifier'] = playersonline[p]
                    })
                end
            end)
          else
            MySQL.Async.fetchAll('SELECT money from users WHERE identifier = @identifier', {
                ['@identifier'] = playersonline[p]
            },
            function(usersResult)
                if #usersResult > 0 then

                    MySQL.Async.execute('UPDATE users SET money=@money WHERE identifier=@identifier',
                    {
                        ['@money'] = usersResult[1].money - result[i].price,
                        ['@identifier'] = playersonline[p]
                    })
                  
                end

            end)
          end

          TriggerEvent('esx_addonaccount:getSharedAccount', 'society_realestateagent', function(account)
            account.addMoney(result[i].price)
          end)

			  end

      end
      
    end
		  )
	   
	  end
	  --

	  playersonline = {}

	  TriggerClientEvent('esx_properties:stillOnline', -1)

end


RegisterServerEvent('esx_properties:editPropDeposit')
AddEventHandler('esx_properties:editPropDeposit', function(useBlackMoney, type, amount, propertyID)
  local xPlayer = ESX.GetPlayerFromId(source)
  if type == 'deposit' then
	if useBlackMoney then
		local playerAccountMoney = xPlayer.getAccount(Config.BlackMoneyName).money
		if amount >= 0 and playerAccountMoney >= amount then
			xPlayer.removeAccountMoney(Config.BlackMoneyName, amount)
			
			for k, v in pairs(propertyOwner) do
				if v.id == propertyID then
				  
					v.blackMoneyDeposit = v.blackMoneyDeposit + amount

					MySQL.Async.execute('UPDATE prop_owner SET blackMoneyDeposit=@blackMoneyDeposit WHERE id=@PROPID LIMIT 1',
					{
						['@blackMoneyDeposit'] = v.blackMoneyDeposit,
						['@PROPID'] = propertyID
					})

					TriggerClientEvent('esx:showNotification', xPlayer.source, '~w~' .. amount .. Translation[Config.Locale]['money_added_to_wallet'])
					TriggerClientEvent('esx_properties:updatePropertyOwner', xPlayer.source, k, propertyOwner[k], xPlayer.identifier)
					break
				end
			end
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, Translation[Config.Locale]['not_enough_money'])
		end
	else
		if amount > 0 and xPlayer.getMoney() >= amount then
		  xPlayer.removeMoney(amount)

		  for k, v in pairs(propertyOwner) do
			if v.id == propertyID then
			  
			  v.deposit = v.deposit + amount

			  MySQL.Async.execute('UPDATE prop_owner SET deposit=@deposit WHERE id=@PROPID LIMIT 1',
			  {
				  ['@deposit'] = v.deposit,
				  ['@PROPID'] = propertyID
			  })

			  TriggerClientEvent('esx:showNotification', xPlayer.source, '~w~' .. amount .. Translation[Config.Locale]['money_added_to_wallet'])
			  TriggerClientEvent('esx_properties:updatePropertyOwner', xPlayer.source, k, propertyOwner[k], xPlayer.identifier)
			  break
			end

		  end

		else
		  TriggerClientEvent('esx:showNotification', xPlayer.source, Translation[Config.Locale]['not_enough_money'])
		end
	end

  elseif type == 'withdraw' then
    for k, v in pairs(propertyOwner) do
      if v.id == propertyID then
        if useBlackMoney then
          if amount > 0 and v.blackMoneyDeposit >= amount then
            v.blackMoneyDeposit = v.blackMoneyDeposit - amount
              MySQL.Async.execute('UPDATE prop_owner SET blackMoneyDeposit=@blackMoneyDeposit WHERE id=@PROPID LIMIT 1',
              {
                  ['@blackMoneyDeposit'] = v.blackMoneyDeposit,
                  ['@PROPID'] = propertyID
              })
            xPlayer.addAccountMoney(Config.BlackMoneyName, amount)
            TriggerClientEvent('esx:showNotification', xPlayer.source, '~w~' .. amount .. Translation[Config.Locale]['money_withdraw_from_safe'])
            TriggerClientEvent('esx_properties:updatePropertyOwner', xPlayer.source, k, propertyOwner[k], xPlayer.identifier)
          else
            TriggerClientEvent('esx:showNotification', xPlayer.source, Translation[Config.Locale]['not_enough_money_in_wallet'])
          end
        else
          if amount > 0 and v.deposit >= amount then
            v.deposit = v.deposit - amount
              MySQL.Async.execute('UPDATE prop_owner SET deposit=@deposit WHERE id=@PROPID LIMIT 1',
              {
                  ['@deposit'] = v.deposit,
                  ['@PROPID'] = propertyID
              })
            xPlayer.addMoney(amount)
            TriggerClientEvent('esx:showNotification', xPlayer.source, '~w~' .. amount .. Translation[Config.Locale]['money_withdraw_from_safe'])
            TriggerClientEvent('esx_properties:updatePropertyOwner', xPlayer.source, k, propertyOwner[k], xPlayer.identifier)
          else
            TriggerClientEvent('esx:showNotification', xPlayer.source, Translation[Config.Locale]['not_enough_money_in_wallet'])
          end
        end
        break
      end

    end
  end

end)

RegisterServerEvent('esx_properties:editPropPlate')
AddEventHandler('esx_properties:editPropPlate', function(propertyID, newPlate)
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer.getMoney() >= 500 then
    xPlayer.removeMoney(500)

    for k, v in pairs(propertyOwner) do
      if v.id == propertyID then
        
        v.charname = newPlate

        MySQL.Async.execute('UPDATE prop_owner SET charactername=@charname WHERE id=@PROPID LIMIT 1',
        {
            ['@charname'] = v.charname,
            ['@PROPID'] = propertyID
        })

        TriggerClientEvent('esx:showNotification', xPlayer.source, Translation[Config.Locale]['doorbell_changed'] .. newPlate .. Translation[Config.Locale]['doorbell_changed2'])
        TriggerClientEvent('esx_properties:updatePropertyOwner', xPlayer.source, k, propertyOwner[k], xPlayer.identifier)
        break
      end

    end

  else
    TriggerClientEvent('esx:showNotification', xPlayer.source, Translation[Config.Locale]['not_enough_money'])
  end
end)

TriggerEvent('cron:runAt', Config.PayRent.h, Config.PayRent.m, PayRent)

RegisterServerEvent('esx_properties:payrent')
AddEventHandler('esx_properties:payrent', function()
	PayRent()
end)

ESX.RegisterServerCallback('esx_properties:getLastProperty', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)

  MySQL.Async.fetchAll(
    'SELECT last_property FROM users WHERE identifier = @identifier',
    {
      ['@identifier'] = xPlayer.identifier
    },
    function(users)
      cb(users[1].last_property)
    end
  )

end)

RegisterServerEvent('esx_properties:sendPropertiesToRealestateagentjob')
AddEventHandler('esx_properties:sendPropertiesToRealestateagentjob', function()
	TriggerClientEvent('realestateagent:getPropertiesFromProp', source, properties)
end)

