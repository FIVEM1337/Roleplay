if Config.Crafting then 
  if Config.CraftingBuiltIn then 
    local Blips = {}

    RegisterNetEvent(Config.ESXPrefix..':playerLoaded')
    AddEventHandler(Config.ESXPrefix..':playerLoaded', function(xPlayer, isNew)
      resetCraftingBlips();
    end)

    RegisterNetEvent(Config.ESXPrefix..':playerLogout') 
    AddEventHandler(Config.ESXPrefix..':playerLogout', function(xPlayer, isNew)
      resetCraftingBlips();
    end)
    
    RegisterNetEvent(Config.ESXPrefix..':setJob')
    AddEventHandler(Config.ESXPrefix..':setJob', function(job)
      resetCraftingBlips();
    end)
    
    function OpenCrafting(title, items, jobs, grades, license)
      if license then 
        ESX.TriggerServerCallback('esx_license:checkLicense', function(hasLicense)
          if hasLicense then
            OpenInventory({type = 'crafting', id = 'crafting', title = title, presetItems = items, delay = Config.CraftingDelay, weight = false})
          else 
            TriggerEvent('inventory:notify', Locales.noLicense, "error")
          end
        end, GetPlayerServerId(PlayerId()), license)
        return
      end

      if not jobs then 
        OpenInventory({type = 'crafting', id = 'crafting', title = title, presetItems = items, delay = Config.CraftingDelay, weight = false})
        return
      end

      if T(jobs):includes(ESX.PlayerData.job.name) then 
        if grades then 
          if T(grades):includes(ESX.PlayerData.job.grade) then 
            canSee = true
            OpenInventory({type = 'crafting', id = 'crafting', title = title, presetItems = items, delay = Config.CraftingDelay, weight = false})
          else
          TriggerEvent('inventory:notify', Locales.noAccessCrafting, "error")
          end
        else 
          canSee = true
          OpenInventory({type = 'crafting', id = 'crafting', title = title, presetItems = items, delay = Config.CraftingDelay, weight = false})
        end
      else
        TriggerEvent('inventory:notify', Locales.noAccessCrafting, "error")
      end
    end

    CreateThread(function ()
      while true do
        Wait(0)
        for k,v in pairs(Config.CraftingLocations) do 
          for k2,location in pairs(v.locations) do 
            local distance = #(GetEntityCoords(PlayerPedId()) - location)
            if distance <= 5.0 then 
              DrawMarker(27, location.x, location.y, location.z - 0.4, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.6, 0.6, 255, 255, 255, 100, false, true, 0, false)
              if distance <= 1.2 then 
                SetTextComponentFormat('STRING')
                AddTextComponentString(Locales.craftOpenBtn)
                DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                if IsControlJustReleased(0, 38) then 
                  OpenCrafting(v.label, v.items, v.jobs, v.job_grades, v.license)
                end
              end
            end
          end
        end
      end
    end)

    function resetCraftingBlips()
      CreateThread(function ()
        for k,v in pairs(Blips) do 
          RemoveBlip(v)
          table.remove(Blips, k)
        end

        for k,v in pairs(Config.CraftingLocations) do
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

    resetCraftingBlips()
  end

  RegisterNetEvent('inventory:openCrafting', function (title, items)
    OpenInventory({type = 'crafting', id = 'crafting', title = title, presetItems = items, delay = Config.CraftingDelay, weight = false})
  end)

  RegisterNUICallback('craftItem', function (data, cb)
    Events.TriggerServerEvent('inventory:craftItem', data.item, tonumber(data.count))
    cb('OK')
  end)
end
