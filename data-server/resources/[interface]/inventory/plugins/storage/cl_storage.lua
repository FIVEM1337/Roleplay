if Config.Storages then 
  local Blips = {}

  RegisterNetEvent(Config.ESXPrefix..':playerLoaded')
  AddEventHandler(Config.ESXPrefix..':playerLoaded', function(xPlayer, isNew)
    resetStorageBlips()
  end)

  RegisterNetEvent(Config.ESXPrefix..':playerLogout') 
  AddEventHandler(Config.ESXPrefix..':playerLogout', function(xPlayer, isNew)
    resetStorageBlips()
  end)
  
  RegisterNetEvent(Config.ESXPrefix..':setJob')
  AddEventHandler(Config.ESXPrefix..':setJob', function(job)
    resetStorageBlips()
  end)

  RegisterNetEvent('inventory:openStorage', function (title, id, weight, delay, jobs)
    OpenStorage(title, id, weight, delay, jobs)
  end)

  function OpenStorage(title, id, weight, delay, jobs, grades)
    if not jobs then 
      OpenInventory({type = 'storage', id = id, title = title, weight = weight, save = true, delay = delay })
      return
    end
    
    if T(jobs):includes(ESX.PlayerData.job.name) then 
      if grades then 
        if T(grades):includes(ESX.PlayerData.job.grade) then 
          canSee = true
          OpenInventory({type = 'storage', id = id, title = title, weight = weight, save = true, delay = delay })
        else
         TriggerEvent('inventory:notify', Locales.noAccessStorage, "error")
        end
      else 
        canSee = true
        OpenInventory({type = 'storage', id = id, title = title, weight = weight, save = true, delay = delay })
      end
    else
      TriggerEvent('inventory:notify', Locales.noAccessStorage, "error")
    end
  end

  CreateThread(function ()
    while true do
      Wait(0)
      for k,v in pairs(Config.StorageLocations) do 
        for k2,location in pairs(v.locations) do 
          local distance = #(GetEntityCoords(PlayerPedId()) - location)
          if distance <= 5.0 then 
            DrawMarker(27, location.x, location.y, location.z + 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.6, 0.6, 255, 255, 255, 100, false, true, 0, false)
            if distance <= 1.2 then 
              SetTextComponentFormat('STRING')
              AddTextComponentString("~INPUT_CONTEXT~ "..v.openBtn)
              DisplayHelpTextFromStringLabel(0, 0, 1, -1)
              if IsControlJustReleased(0, 38) then 
                OpenStorage(v.label, k, v.weight, v.delay, v.jobs, v.job_grades)
              end
            end
          end
        end
      end
    end
  end)

  function resetStorageBlips()
    CreateThread(function ()
      for k,v in pairs(Blips) do 
        RemoveBlip(v)
        table.remove(Blips, k)
      end

      for k,v in pairs(Config.StorageLocations) do
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

  resetStorageBlips()
end
