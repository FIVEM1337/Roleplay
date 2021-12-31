if Config.Trunk or Config.Glovebox then 
    if Config.TrunkSave or Config.GloveboxSave then
        ESX.RegisterServerCallback("inventory:isVehicleOwned", function(source, cb, plate)
            MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
                ['@plate'] = plate
            }, function(result)
                if result[1] then
                    cb(true)
                else
                    MySQL.Async.fetchAll('SELECT 1 FROM job_vehicles WHERE plate = @plate', {
                        ['@plate'] = plate
                    }, function(result)
                        if result[1] then
                            cb(true)
                        else
                            cb(false)
                        end
                    end)
                end
            end)
        end) 
    end
end