if Config.Hotbar then 
  hbSoftLock = false
  WeaponLock = false
  WeaponEquipped = nil

  CreateThread(function ()
    while true do 
      Wait(1)
      HideHudComponentThisFrame(19)
      HideHudComponentThisFrame(20)
      HideHudComponentThisFrame(17)
    end
  end)

  CreateThread(function ()
    while true do
      Wait(1)
      for k,v in pairs(Config.HotbarKeys) do
        if IsDisabledControlJustPressed(0, v) then
          UseItemFromHotbar(tostring(k-1))
        end
      end
    end
  end)
  
  CreateThread(function()
    while true do
      Wait(1)
      DisableControlAction(0, 37, true) --Disable Tab
      if WeaponLock then
        DisableControlAction(1, 25, true )
        DisableControlAction(1, 140, true)
        DisableControlAction(1, 141, true)
        DisableControlAction(1, 142, true)
        DisableControlAction(1, 23, true)
        DisablePlayerFiring(PlayerPedId(), true)
      end
    end
  end)  

  RegisterNetEvent('inventory:onItemRemove', function (item)
    if item.type == 'item_weapon' then
      if WeaponEquipped then
        if WeaponEquipped.name == item.name then
          WeaponEquipped = nil
        end
      end
    end
  end)

  RegisterCommand('showHotbar', function ()
    local ped = PlayerPedId()

    if IsPauseMenuActive() then return end
    if IsPlayerDead(ped) then return end

    local hotbar = Events.TriggerServerEvent('inventory:getHotbar')
    SendNUIMessage({
      type = 'showHotbar',
      hotbar = hotbar
    })  
  end)
  RegisterKeyMapping('showHotbar', 'Hotbar', 'keyboard', 'tab')

  function UseItemFromHotbar(slot)
    if hbSoftLock then
      return
    end

    lockHB()

    local playerData = Events.TriggerServerEvent('inventory:getPlayerItems')
    local hotbarItem = playerData.hotbar[slot]
    local item = nil

    if not hotbarItem then 
      return
    end

    for k,v in pairs(playerData.items) do 
      if v.name == hotbarItem.name then 
        item = v
      end
    end

    local ped = PlayerPedId()

    if item then 
      if item.type == 'item_standard' then 
        if item.canUse then
          TriggerServerEvent(Config.ESXPrefix..':useItem', item.name)
        end
      elseif item.type == 'item_weapon' then 
        if WeaponLock then 
          return
        end

        WeaponLock = true

        if not WeaponEquipped or WeaponEquipped.name ~= item.name then 
          WeaponEquipped = item
          if Config.WeaponAnimation then
            LoadAnimDict('reaction@intimidation@1h', function ()
              TaskPlayAnim(ped, "reaction@intimidation@1h", "intro", 8.0, 2.0, -1, 48, 2, 0, 0, 0)
              Wait(1500)
              ClearPedTasks(ped)
              SetCurrentPedWeapon(ped, item.name, true)
              SetWeaponsNoAutoswap(true)
              WeaponLock = false
            end)
          else 
            SetCurrentPedWeapon(ped, item.name, true)
            SetWeaponsNoAutoswap(true)
            WeaponLock = false
          end

        else  
          WeaponEquipped = nil
          if Config.WeaponAnimation then
            LoadAnimDict('reaction@intimidation@1h', function ()
              TaskPlayAnim(ped, "reaction@intimidation@1h", "outro", 8.0, 2.0, -1, 48, 2, 0, 0, 0)
              Wait(1500)
              ClearPedTasks(ped)
              SetCurrentPedWeapon(ped, "WEAPON_UNARMED", true)
              WeaponLock = false
            end)
          else 
            SetCurrentPedWeapon(ped, "WEAPON_UNARMED", true)
            WeaponLock = false
          end
        end
      end
    end
  end

  function lockHB()
    hbSoftLock = true
    SetTimeout(500, function ()
      hbSoftLock = false
    end)
  end
end