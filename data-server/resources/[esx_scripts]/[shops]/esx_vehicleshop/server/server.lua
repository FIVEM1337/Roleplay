local Vehicles = {}

CreateThread(function()
    TriggerEvent('esx_vehicleshop:getVehicles')
end)

RegisterServerEvent('esx_vehicleshop:getVehicles')
AddEventHandler('esx_vehicleshop:getVehicles', function ()
    local vehicles = MySQL.Sync.fetchAll('SELECT * FROM shop_vehicle')

    for k, v in pairs(vehicles) do
        table.insert(Vehicles, v)
    end
end)

ESX.RegisterServerCallback('esx_vehicleshop:getVehicles', function (source, cb)
    cb(Vehicles)
end)

ESX.RegisterServerCallback('esx_vehicleshop:buyVehicle', function (source, cb, vehicle_id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local vehicle
    local job

    for k, v in pairs(Vehicles) do
        if v.id == vehicle_id then
            vehicle = v
            break
        end
    end

    if vehicle then
        if vehicle.job and vehicle.job ~= "" and not string.match(vehicle.job,"[^%w]") then
            job = vehicle.job
        end

        if job then
            if xPlayer.job.name == job and xPlayer.job.can_managecars then
                TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..job, function(account)
                    if account.money >= vehicle.price then
                        account.removeMoney(vehicle.price)
                        cb(true)
                    else
                        cb(false)
                    end
                end)
            end
        else
            local money = xPlayer.getAccount(vehicle.price_type).money
            if money >= vehicle.price then
                xPlayer.removeAccountMoney(vehicle.price_type, vehicle.price)
                cb(true)
            else
                cb(false)
            end
        end
    else
        cb(nil)
    end
end)

ESX.RegisterServerCallback('esx_vehicleshop:isPlateTaken', function (source, cb, plate)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    }, function (result)
        if result[1] then
            cb(true)
        else
            cb(false)
        end
    end)
end)


RegisterServerEvent('esx_vehicleshop:setVehicleOwned')
AddEventHandler('esx_vehicleshop:setVehicleOwned', function (vehicleProps, vehicle_id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local vehicle
    for k, v in pairs(Vehicles) do
        if v.id == vehicle_id then
            vehicle = v
            break
        end
    end

    if vehicle then
        local job
        if vehicle.job and vehicle.job ~= "" and not string.match(vehicle.job,"[^%w]") then
            job = vehicle.job
        end

        MySQL.Async.execute('INSERT INTO owned_vehicles (owner, job, plate, vehicle, type) VALUES (@owner, @job, @plate, @vehicle, @type)',
        {
            ['@owner'] = job or xPlayer.identifier,
            ['@job']   = job or "private",
            ['@plate']   = vehicleProps.plate,
            ['@vehicle'] = json.encode(vehicleProps),
            ['@type'] = vehicle.car_type,
        }, function (rowsChanged)
        end)
    end
end)
