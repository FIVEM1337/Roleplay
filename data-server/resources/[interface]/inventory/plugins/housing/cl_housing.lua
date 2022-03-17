RegisterNetEvent('inventory:openHouse', function (owner, id, title, weight)
  OpenInventory({type = 'house', id = owner..id, title = title, save = true, weight = weight })
end)