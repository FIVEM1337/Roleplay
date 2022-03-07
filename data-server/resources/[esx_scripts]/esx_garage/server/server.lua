ESX = nil
local vehicles = {}
local default_routing = {}
local current_routing = {}
local lastgarage = {}
local impound_G = {}
local jobplates = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function MysqlGarage(plugin,type,query,var)
	local wait = promise.new()
    if type == 'fetchAll' and plugin == 'mysql-async' then
		MySQL.Async.fetchAll(query, var, function(result)
            wait:resolve(result)
        end)
    end
    if type == 'execute' and plugin == 'mysql-async' then
        MySQL.Async.execute(query, var, function(result)
            wait:resolve(result)
        end)
    end
    if type == 'execute' and plugin == 'ghmattisql' then
        exports['ghmattimysql']:execute(query, var, function(result)
            wait:resolve(result)
        end)
    end
    if type == 'fetchAll' and plugin == 'ghmattisql' then
        exports.ghmattimysql:execute(query, var, function(result)
            wait:resolve(result)
        end)
    end
    if type == 'execute' and plugin == 'oxmysql' then
        exports.oxmysql:execute(query, var, function(result)
            wait:resolve(result)
        end)
    end
    if type == 'fetchAll' and plugin == 'oxmysql' then
		exports['oxmysql']:fetch(query, var, function(result)
			wait:resolve(result)
		end)
    end
	return Citizen.Await(wait)
end

RegisterServerEvent('esx_garage:GetVehiclesTable')
AddEventHandler('esx_garage:GetVehiclesTable', function(garageid,public)
    local src = source 
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier

    local Owned_Vehicle = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE owner = @owner', {
        ['@owner'] = identifier
    })
    local Job_Vehicles = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM job_vehicles WHERE job = @job', {
        ['@job'] = xPlayer.job.name
    }) 
    TriggerClientEvent("esx_garage:receive_vehicles", src , Owned_Vehicle or {},vehicles or {}, Job_Vehicles or {})
end)

RegisterServerEvent('esx_garage:GetVehiclesTableImpound')
AddEventHandler('esx_garage:GetVehiclesTableImpound', function()
    local src = source  
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
 
    local Impound_Owned_Vehicles = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE `impound` = 1 and owner = @owner', {
        ['@owner'] = identifier
    })

    local Impound_Job_Vehicles = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM job_vehicles WHERE `impound` = 1 and job = @job', {
        ['@job'] = xPlayer.job.name
    }) 

    TriggerClientEvent("esx_garage:receive_vehicles", src , Impound_Owned_Vehicles or {} ,vehicles, Impound_Job_Vehicles or {})
end)


ESX.RegisterServerCallback('esx_garage:getowner',function(source, cb, identifier, plate, garage)
    local owner = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier
	})
    if impound_G[garage][plate] == nil then
        -- create data from default
        impound_G[garage][plate] = {fine = ImpoundPayment, reason = 'no specified', impounder = 'Renzuzu', duration = -1, date = os.time()}
    end
    local res = impound_G[garage][plate] ~= nil and impound_G[garage][plate] or {}
	cb(owner,res)
end)

function bool_to_number(value)
    if value then
    return tonumber(1)
    else
    return tonumber(0)
    end
end

ESX.RegisterServerCallback('esx_garage:returnpayment', function (source, cb)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= Config.ReturnPayment then
        xPlayer.removeMoney(Config.ReturnPayment)
        cb(true)
    else
        cb(false)
    end
end)

local garageshare = {}

function DoiOwnthis(xPlayer,id)
    local owned = false
    for k,v in pairs(current_routing) do
        if tonumber(v) == tonumber(xPlayer.source) and GetPlayerRoutingBucket(xPlayer.source) == tonumber(k) then
            owned = true
        end
    end
    return owned
end


ESX.RegisterServerCallback('esx_garage:isvehicleingarage', function (source, cb, plate, garageid)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    money = 1000
    plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()

    local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT `stored`, impound FROM owned_vehicles WHERE TRIM(UPPER(plate)) = @plate', {
        ['@plate'] = plate
    })
    if #result > 0 then
        vehicle = result[1]
        if vehicle.impound then
            if xPlayer.getMoney() >= money then
                xPlayer.removeMoney(money)
                TriggerClientEvent('dopeNotify:Alert', source, "Garage", "Fahrzeug abgeholt", 5000, 'success')
                cb(vehicle.stored, vehicle.impound, garageid, nil)
            else
                TriggerClientEvent('dopeNotify:Alert', source, "Garage", "Du hast nicht genug Geld es werden $".. money.. " benötigt", 5000, 'error')
                cb(vehicle.stored, vehicle.impound, garageid, money)
            end
        else
            cb(vehicle.stored, vehicle.impound, garageid, nil)
        end
    else
        local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT `stored` FROM job_vehicles WHERE TRIM(UPPER(plate)) = @plate', {
            ['@plate'] = plate
        })
        if #result > 0 then
            if result and result[1].stored ~= nil then
                local stored = result[1].stored
                cb(stored,false,false,impound_fee)
            end
        end
    end
end)

ESX.RegisterServerCallback('esx_garage:canstore', function (source, cb, plate, job, isjobgarage, garagetype)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    local isjobcar = nil

    if job ~= nil then
        if job ~= xPlayer.job.name then
            cb(false)
            return
        end
    end

    local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE owner = @owner and TRIM(UPPER(plate)) = @plate LIMIT 1', {
        ['@owner'] = identifier,
        ['@plate'] = plate
    })
    if #result > 0 then
        isjobcar = false

        if garagetype ~= result[1].type then
            cb(false)
        end

    else
        local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM job_vehicles WHERE TRIM(UPPER(plate)) = @plate LIMIT 1', {
            ['@plate'] = plate
        })
        if #result > 0 then
            isjobcar = true

            if garagetype ~= result[1].type then
                cb(false)
            end

        else
            print("car not in database")
            cb(false) 

        end
    end

    if isjobcar == nil then
        cb(false)
    end

    if isjobgarage then
        if isjobcar then
            cb(true)
        else
            cb(false)
        end
    else
        if isjobcar then
            cb(false)
        else
            cb(true)
        end
    end
end)


ESX.RegisterServerCallback('esx_garage:changestate', function (source, cb, plate,state,garage_id,model,props,impound_cdata, public, impound)
    plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()
    local state = tonumber(state)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    if xPlayer then
        local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE owner = @owner and TRIM(UPPER(plate)) = @plate LIMIT 1', {
            ['@owner'] = identifier,
            ['@plate'] = plate
        })
        if #result > 0 then
            if result[1].vehicle ~= nil then
                local veh = json.decode(result[1].vehicle)
                if veh.model == model then
                    local var = {
                        ['@vehicle'] = json.encode(props),
                        ['@garage_id'] = garage_id,
                        ['@plate'] = plate:upper(),
                        ['@owner'] = identifier,
                        ['@stored'] = state,
                        ['@impound'] = impound,
                        ['@job'] = state == 1 and public and xPlayer.job.name or state == 1 and result[1].job ~= nil and result[1].job or 'civ',
                    }
                    local result = MysqlGarage(Config.Mysql,'execute','UPDATE owned_vehicles SET `stored` = @stored, impound = @impound, garage_id = @garage_id, vehicle = @vehicle, `job` = @job WHERE TRIM(UPPER(plate)) = @plate and owner = @owner', var)
                    if state == 1 then
                        TriggerClientEvent('dopeNotify:Alert', source, "Garage", "Fahrzeug eingeparkt", 5000, 'success')
                    else
                        TriggerClientEvent('dopeNotify:Alert', source, "Garage", "Fahrzeug ausgeparkt", 5000, 'success')
                    end
                    cb(true,public)
                else
                    print('exploiting')
                    cb(false,public)
                end
            end
        else
            local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM job_vehicles WHERE TRIM(UPPER(plate)) = @plate LIMIT 1', {
                ['@plate'] = plate
            })
            if #result > 0 then
                if result[1].vehicle ~= nil then
                    local veh = json.decode(result[1].vehicle)
                    if veh.model == model then
                        local var = {
                            ['@vehicle'] = json.encode(props),
                            ['@plate'] = plate:upper(),
                            ['@stored'] = state,
                            ['@impound'] = impound,
                        }
                        local result = MysqlGarage(Config.Mysql,'execute','UPDATE job_vehicles SET `stored` = @stored, impound = @impound, vehicle = @vehicle WHERE TRIM(UPPER(plate)) = @plate', var)
                        if state == 1 then
                            TriggerClientEvent('dopeNotify:Alert', source, "Garage", "Fahrzeug eingeparkt", 5000, 'success')
                        else
                            TriggerClientEvent('dopeNotify:Alert', source, "Garage", "Fahrzeug ausgeparkt", 5000, 'success')
                        end
                        cb(true,public)
                    else
                        print('exploiting')
                        cb(false,public)
                    end
                end
            else
                TriggerClientEvent('dopeNotify:Alert', source, "Garage", "Fahrzeug ist nicht dein Eigentum", 5000, 'error')
                cb(false, public)
            end
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    for k,v in pairs(default_routing) do
        SetPlayerRoutingBucket(k,0)
    end
    print('The resource ' .. resourceName .. ' was stopped.')
end)


RegisterServerEvent('statebugupdate') -- this will be removed once syncing of statebug from client is almost instant
AddEventHandler('statebugupdate', function(name,value,net)
    local vehicle = NetworkGetEntityFromNetworkId(net)
    local ent = Entity(vehicle).state
    ent[name] = value
    if name == 'unlock' then
        local val = 1
        if not value then
            val = 2
        end
        SetVehicleDoorsLocked(vehicle,tonumber(val))
    end
end)


AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
        print("enter")
		Citizen.Wait(50)
        local owned_vehicles = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE `stored` = 0 and impound = 0', {}) or {}
        for k,v in ipairs(owned_vehicles) do    
            local veh = json.decode(owned_vehicles[k].vehicle)
            local var_owned_vehicles = {
                ['@plate'] = veh.plate,
                ['@stored'] = 0,
                ['@impound'] = 1,
            }
            MysqlGarage(Config.Mysql,'execute','UPDATE owned_vehicles SET `stored` = @stored, impound = @impound WHERE TRIM(UPPER(plate)) = @plate', var_owned_vehicles)       
        end
        local job_vehicles = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM job_vehicles WHERE `stored` = 0 and impound = 0', {}) or {}
        for k,v in ipairs(job_vehicles) do
            print("do something with") 
            local veh = json.decode(job_vehicles[k].vehicle)
            local var_job_vehicles = {
                ['@plate'] = veh.plate,
                ['@stored'] = 0,
                ['@impound'] = 1,
            }
            MysqlGarage(Config.Mysql,'execute','UPDATE job_vehicles SET `stored` = @stored, impound = @impound WHERE TRIM(UPPER(plate)) = @plate', var_job_vehicles)       
        end
	end
end)