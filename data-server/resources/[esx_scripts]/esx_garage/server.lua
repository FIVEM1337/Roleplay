ESX.RegisterServerCallback('esx_garage:getVehicles', function (source, cb, garage, stored)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
    if garage.job then
        if xPlayer.job.name == garage.job then
            MySQL.Async.fetchAll(
                'SELECT * FROM owned_vehicles WHERE job = @job and type = @type and stored = @stored and impound = @impound', 
            {
                ['@job']            = xPlayer.job.name,
                ['@type']           = garage.Type,
                ['@stored']         = stored,
                ['@impound']        = false,
            }, 
            function(vehicles)
                cb(vehicles)
            end)
        else
            Print("User sollte garage nicht öffnen können")
            cb(nil)
        end
    else
        MySQL.Async.fetchAll(
            'SELECT * FROM owned_vehicles WHERE owner = @owner and job = @job and type = @type and stored = @stored and impound = @impound', 
        {
            ['@owner']      = xPlayer.identifier,
            ['@job']        = "private",
            ['@type']       = garage.Type,
            ['@stored']     = stored,
            ['@impound']    = false,
        },
        function(vehicles)
            cb(vehicles)
        end)
    end
end)

ESX.RegisterServerCallback('esx_garage:getImpounds', function (source, cb, data)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget
    local job = job

    canopenimpound = false
    for k, v in ipairs(Config.ImpoundJobs) do
        if v == xPlayer.job.name then
            canopenimpound = true
            break
        end
    end
    if not canopenimpound then
        TriggerClientEvent('dopeNotify:Alert', source, "", "Du bist nicht berechtigt die Garage zu öffnen", 5000, 'error')
        return
    end

    if data.id then
        xTarget = ESX.GetPlayerFromId(data.id)
        if not xTarget then
            TriggerClientEvent('dopeNotify:Alert', source, "", "Person nicht verfügbar", 5000, 'error')
            return
        end
    end

    if data.id then
        MySQL.Async.fetchAll(
            'SELECT * FROM owned_vehicles WHERE owner = @owner and stored = @stored and impound = @impound', 
        {
            ['@owner']          = xTarget.identifier,
            ['@stored']         = true,
            ['@impound']        = true,
        },
        function(vehicles)
            cb(vehicles)
        end)
    elseif data.plate then
        MySQL.Async.fetchAll(
            'SELECT * FROM owned_vehicles WHERE plate = @plate and stored = @stored and impound = @impound', 
        {
            ['@plate']          = string.gsub(tostring(data.plate), '^%s*(.-)%s*$', '%1'):upper(),
            ['@stored']         = true,
            ['@impound']        = true,
        },
        function(vehicles)
            cb(vehicles)
        end)
    elseif data.job then
        MySQL.Async.fetchAll(
            'SELECT * FROM owned_vehicles WHERE owner = @owner and job = @job and stored = @stored and impound = @impound', 
        {
            ['@owner']          = data.job,
            ['@job']            = data.job,
            ['@stored']         = true,
            ['@impound']        = true,
        },
        function(vehicles)
            cb(vehicles)
        end)
    end
end)

ESX.RegisterServerCallback('esx_garage:changestatus', function (source, cb, probs, garage, stored, impound)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = "private"
    local probs = probs

    if garage.job or garage.impound then
        if xPlayer.job.name == garage.job or garage.impound then
            job = xPlayer.job.name
        end
    end

    if garage.job or garage.impound then
        MySQL.Async.execute(
            'UPDATE owned_vehicles SET job = @job, vehicle = @vehicle, stored = @stored, impound = @impound, garage_id = @garage_id WHERE TRIM(UPPER(plate)) = @plate',
            {
                ['@plate']      = string.gsub(tostring(probs.plate), '^%s*(.-)%s*$', '%1'):upper(),
                ['@job']        = job,
                ['@vehicle']    = json.encode(probs),
                ['@stored']     = stored,
                ['@impound']    = impound or false,
                ['@garage_id']   = garage_id or garage.garage_id,
            },
            function(rowsChanged)
                if rowsChanged == 0 then
                    cb(false)
                else
                    MySQL.Async.fetchAll(
                        'SELECT * FROM owned_vehicles WHERE TRIM(UPPER(plate)) = @plate', 
                    {
                        ['@plate']      = string.gsub(tostring(probs.plate), '^%s*(.-)%s*$', '%1'):upper(),
                    },
                    function(vehicle)
                        cb(true, vehicle[1])
                    end)
                end
        end)
    else
        MySQL.Async.execute(
            'UPDATE owned_vehicles SET job = @job, vehicle = @vehicle, stored = @stored, impound = @impound, grade = @grade, garage_id = @garage_id WHERE TRIM(UPPER(plate)) = @plate',
            {
                ['@plate']      = string.gsub(tostring(probs.plate), '^%s*(.-)%s*$', '%1'):upper(),
                ['@job']        = job,
                ['@vehicle']    = json.encode(probs),
                ['@stored']     = stored,
                ['@impound']    = impound or false,
                ['@grade']      = -1,
                ['@garage_id']   = garage_id or garage.garage_id,
            },
            function(rowsChanged)
                if rowsChanged == 0 then
                    cb(false)
                else
                    cb(true)
                end
        end)
    end
end)

ESX.RegisterServerCallback('esx_garage:ChangeGrade', function (source, cb, probs, garage, grade)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.execute(
        'UPDATE owned_vehicles SET grade = @grade WHERE TRIM(UPPER(plate)) = @plate',
        {
            ['@plate']      = string.gsub(tostring(probs.plate), '^%s*(.-)%s*$', '%1'):upper(),
            ['@grade']        = grade,
        },
        function(rowsChanged)
            cb(true)
    end)
end)

ESX.RegisterServerCallback('esx_garage:canGetVehicle', function (source, cb, probs, garage)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local probs = probs


    if garage.impound then
        MySQL.Async.fetchAll(
            'SELECT * FROM owned_vehicles WHERE TRIM(UPPER(plate)) = @plate and stored = @stored and impound = @impound', 
        {
            ['@plate']      = string.gsub(tostring(probs.plate), '^%s*(.-)%s*$', '%1'):upper(),
            ['@stored']     = true,
            ['@impound']    = garage.impound or false,
        },
        function(vehicle)
            if vehicle[1] then
                cb(true)
            else
                cb(false)
            end
        end)
    else
        MySQL.Async.fetchAll(
            'SELECT * FROM owned_vehicles WHERE TRIM(UPPER(plate)) = @plate and type = @type and stored = @stored and impound = @impound', 
        {
            ['@plate']      = string.gsub(tostring(probs.plate), '^%s*(.-)%s*$', '%1'):upper(),
            ['@type']       = garage.Type,
            ['@stored']     = true,
            ['@impound']    = garage.impound or false,
        },
        function(vehicle)
            if vehicle[1] then
                cb(true)
            else
                cb(false)
            end
        end)
    end
end)

ESX.RegisterServerCallback('esx_garage:canStoreVehicle', function (source, cb, probs, garage)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local probs = probs

    local isImpounder = false
    if garage.impound then
        for k, v in ipairs(Config.ImpoundJobs) do
            if v == xPlayer.job.name then
                isImpounder = true
            end
        end
    end


    MySQL.Async.fetchAll(
        'SELECT * FROM owned_vehicles WHERE TRIM(UPPER(plate)) = @plate', 
    {
        ['@plate']  = string.gsub(tostring(probs.plate), '^%s*(.-)%s*$', '%1'):upper(),
    },
    function(vehicle)
        if vehicle[1] then
            local vehicle = vehicle[1]
            if not vehicle.stored then
                if not vehicle.impound then
                    if garage.impound then
                        if isImpounder then
                            cb(true, true)
                        else
                            cb(false, true)
                        end
                    else
                        if garage.job then -- job garage
                            if garage.job == xPlayer.job.name then
                                if vehicle.owner == xPlayer.identifier then
                                    if garage.storeprivate then
                                        cb(true, true) -- user have same job as garage and is owner of the vehicle
                                    else
                                        cb(false, true)
                                    end
                                elseif vehicle.job == xPlayer.job.name then
                                    cb(true, true) -- user have same job as garage and vehicle is correct job
                                else
                                    cb(false, true)   -- user has not the same job as garage and vehicle is not the correct job
                                end
                            else
                                cb(false, true) -- user dosnt have the same job as garage
                            end
                        else    -- private garage
                            if vehicle.owner == xPlayer.identifier then
                                cb(true, true)    -- user is owner of vehicle
                            else
                                cb(false, true)   -- user is not owner of vehicle
                            end
                        end
                    end
                else
                    print("ERROR - Vehicle is Impounded but someone try to Store it")
                    cb(false, false)
                end
            else
                print("ERROR - Vehicle is Stored but someone try to Store it")
                cb(false, false)
            end
        else
            print("ERROR - Vehicle is not in Database")
            cb(false, false)
        end
    end)
end)

ESX.RegisterServerCallback("esx_garage:GetJob",function(source, cb, all)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if all then
        MySQL.Async.fetchAll(
            'SELECT * FROM jobs ORDER BY `label` ASC ;', {},
        function(job_grades)
            cb(job_grades)
        end)
    else
        MySQL.Async.fetchAll(
            'SELECT * FROM job_grades WHERE job_name = @jobname ORDER BY `grade` ASC ;',
        {
            ['@jobname'] = xPlayer.job.name,
        },
        function(job_grades)
            cb(job_grades)
        end)
    end
end)

ESX.RegisterServerCallback('esx_garage:pay', function (source, cb, job)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if job then
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..job, function(account)
            if account.money >= Config.ReturnPayment then
                account.removeMoney(Config.ReturnPayment)
                cb(true)
            else
                cb(false)
            end
        end)
    else
        if xPlayer.getMoney() >= Config.ReturnPayment then
            xPlayer.removeMoney(Config.ReturnPayment)
            cb(true)
        else
            cb(false)
        end
    end
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Wait(50)

        MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE stored = 0', {}, 
        function(vehicles)
            for k, v in ipairs(vehicles) do
                MySQL.Async.execute(
                    'UPDATE owned_vehicles SET `stored` = @stored, impound = @impound WHERE TRIM(UPPER(plate)) = @plate',
                    {
                        ['@plate']      = string.gsub(tostring(v.plate), '^%s*(.-)%s*$', '%1'):upper(),
                        ['@stored']     = true,
                        ['@impound']    = true,
                    },
                    function(rowsChanged)
                end)
            end
        end)
    end
end)