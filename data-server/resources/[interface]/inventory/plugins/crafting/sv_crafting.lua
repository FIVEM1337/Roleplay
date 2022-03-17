if Config.Crafting then 
  Events.RegisterEvent('inventory:craftItem', function (source, item, count)
    if count < 1 then 
      return
    end

    CraftItem(source, item, count)
  end)

  function CraftItem(source, item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local canCraft = false
    for k,v in pairs(item.ingredients) do 
      local info = xPlayer.getInventoryItem(v.name)
      if info.count >= (v.count * count) then 
        canCraft = true
      else
        canCraft = false
      end
    end

    if canCraft then 
      if not CanPlayerCarry(xPlayer, item, count) then 
        TriggerClientEvent('inventory:notify', source, Locales.cannotCarry, "error")
        return
      end

      if item.type == 'item_standard' then 
        for k,v in pairs(item.ingredients) do
          xPlayer.removeInventoryItem(v.name, v.count * count)
        end
        xPlayer.addInventoryItem(item.name, item.count * count)
      else
        if not xPlayer.hasWeapon(item.name) then 
          for k,v in pairs(item.ingredients) do
            xPlayer.removeInventoryItem(v.name, v.count)
          end
          xPlayer.addWeapon(item.name, item.count)
        else 
          TriggerClientEvent('inventory:notify', source, Locales.alreadyGotWeapon, "error")
        end
      end
    else
      TriggerClientEvent('inventory:notify', source, Locales.notEnoughIngredients, "error")
    end

    TriggerClientEvent('inventory:refresh', source)
  end
end
