Events.RegisterEvent('inventory:isVehicleOwned', function (source, plate)
  local p = promise.new()

  MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate=@plate',
  {
    ["@plate"] = plate
  },
  function (result)
    if result then 
      if result[1] then 
        p:resolve(true)
      else 
        p:resolve(false)
      end
    end
  end)

  return Citizen.Await(p)
end)