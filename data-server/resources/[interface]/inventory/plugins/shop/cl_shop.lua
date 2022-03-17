if Config.Shops then 
  function OpenShop(title, items, account, jobs, grades, license)
    if license then 
      ESX.TriggerServerCallback('esx_license:checkLicense', function(hasLicense)
        if hasLicense then
          OpenInventory({type = 'shop', id = 'shop', title = title, account = account, presetItems = items, timeout = Config.ShopDelay, weight = false})
        else 
          TriggerEvent('inventory:notify', Locales.noLicense, "error")
        end
      end, GetPlayerServerId(PlayerId()), license)
      return
    end

    if not jobs then 
      OpenInventory({type = 'shop', id = 'shop', title = title, account = account, presetItems = items, timeout = Config.ShopDelay, weight = false})
      return
    end       

    if T(jobs):includes(ESX.PlayerData.job.name) then 
      if grades then 
        if T(grades):includes(ESX.PlayerData.job.grade) then 
          canSee = true
          OpenInventory({type = 'shop', id = 'shop', title = title, account = account, presetItems = items, timeout = Config.ShopDelay, weight = false})
        else
         TriggerEvent('inventory:notify', Locales.noAccessShop, "error")
        end
      else 
        canSee = true
        OpenInventory({type = 'shop', id = 'shop', title = title, account = account, presetItems = items, timeout = Config.ShopDelay, weight = false})
      end
    else
      TriggerEvent('inventory:notify', Locales.noAccessShop, "error")
    end
  end

  RegisterNetEvent('inventory:openShop', function (title, items)
    OpenShop(title, items)
  end)

  if Config.ShopsBuiltIn then 
    local Blips = {}

    RegisterNetEvent(Config.ESXPrefix..':playerLoaded')
    AddEventHandler(Config.ESXPrefix..':playerLoaded', function(xPlayer, isNew)
      resetShopBlips()
    end)

    RegisterNetEvent(Config.ESXPrefix..':playerLogout') 
    AddEventHandler(Config.ESXPrefix..':playerLogout', function(xPlayer, isNew)
      resetShopBlips()
    end)
    
    RegisterNetEvent(Config.ESXPrefix..':setJob')
    AddEventHandler(Config.ESXPrefix..':setJob', function(job)
      resetShopBlips()
    end)
    

    CreateThread(function ()
      while true do
        Wait(0)
        for k,v in pairs(Config.ShopLocations) do 
          for k2,location in pairs(v.locations) do 
            local distance = #(GetEntityCoords(PlayerPedId()) - location)
            if distance <= 5.0 then 
              DrawMarker(27, location.x, location.y, location.z + 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.6, 0.6, 255, 255, 255, 100, false, true, 0, false)
              if distance <= 1.2 then 
                SetTextComponentFormat('STRING')
                AddTextComponentString(Locales.shopOpenBtn)
                DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                if IsControlJustReleased(0, 38) then 
                  OpenShop(v.label, v.items, v.addon_account_name, v.jobs, v.job_grades, v.license)
                end
              end
            end
          end
        end
      end
    end)

    function resetShopBlips()
      CreateThread(function ()
        for k,v in pairs(Blips) do 
          RemoveBlip(v)
          table.remove(Blips, k)
        end

        for k,v in pairs(Config.ShopLocations) do
          if v.blip then 
            local canSee = true

            if v.blip.hiddenForOthers then
              canSee = false
              if v.jobs then 
                if ESX.PlayerData.job then 
                  if T(v.jobs):includes(ESX.PlayerData.job.name) then 
                    if v.job_grades then 
                      if T(v.job_grades):includes(ESX.PlayerData.job.grade) then 
                        canSee = true
                      end
                    else 
                      canSee = true
                    end
                  end
                else 
                  canSee = false
                end
              end
            end

            if canSee then 
              for k2,location in pairs(v.locations) do 
                local blip = AddBlipForCoord(location)
                SetBlipSprite(blip, v.blip.id)
                SetBlipScale(blip, v.blip.scale)
                SetBlipDisplay(blip, 4)
                SetBlipColour(blip, v.blip.color)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(v.label)
                EndTextCommandSetBlipName(blip)      
                table.insert(Blips, blip)
              end
            end
          end
        end
      end)
    end

    resetShopBlips()
  end
end
