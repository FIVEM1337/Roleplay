ESX = nil
local vehicles = {}
local default_routing = {}
local current_routing = {}
local lastgarage = {}
local impound_G = {}
local jobplates = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
Citizen.CreateThread(function()
    Wait(1000)
    vehicles = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM vehicles', {})
    GlobalState.VehicleinDb = vehicles
    globalvehicles = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles', {}) or {}
 
    local tempvehicles = {}
    for k,v in ipairs(globalvehicles) do
        if v.plate then
            local plate = string.gsub(v.plate, '^%s*(.-)%s*$', '%1')
            tempvehicles[plate] = {}
            tempvehicles[plate].owner = v.owner
            tempvehicles[plate].plate = v.plate
            tempvehicles[plate].name = 'NULL'
        end
    end
    for k,v in pairs(globalvehicles) do
        local plate = string.gsub(v.plate, '^%s*(.-)%s*$', '%1')
        for k2,v2 in pairs(vehicles) do
            if v.vehicle then
                local prop = json.decode(v.vehicle) or {model = ''}
                if prop.model == GetHashKey(v2.model) then
                    tempvehicles[plate].name = v2.name
                    break
                end
            end
        end
    end
    GlobalState.GVehicles = tempvehicles 
    tempvehicles = nil
    impoundget = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM impound_garage', {})
    for k,v in pairs(impoundget) do
        impound_G[v.garage] = json.decode(v.data) or {}
    end
    for k,v in pairs(impoundcoord) do
        MysqlGarage(Config.Mysql,'execute','INSERT IGNORE INTO impound_garage (garage, data) VALUES (@garage, @data)', {
            ['@garage']   = v.garage,
            ['@data']   = '[]'
        })
    end
    Wait(100)

    if Config.UseRayZone then
        local garages = {} -- garage table
        garages['multi_zone'] = {} -- rayzone multizone
        for k,v in pairs(garagecoord) do -- repack the coordinates to new table
            garages['multi_zone'][tostring(v.garage)] = {
                coord = vector3(v.garage_x,v.garage_y,v.garage_z),
                custom_title = 'Garage '..v.garage, -- custom title and it wont used the ['title'] anymore
                custom_event = 'opengarage', -- if custom_event is being used , the event ( ['event'] ) will not be used.
                custom_arg = { 1, 2, 4, 3}, -- sample only , ordering is important on this table
                arg_unpack = false, -- if true this will return the array as unpack to your event handler example: AddEventHandler("renzu_rayzone:test",function(a,b,c) the ,a will return the 1 ,b for 2, c for 4 ( as example config here) custom_arg = { 1, 2, 4, 3}, elseif false will return as a table.
                custom_ped = `g_m_importexport_01`, -- custom ped for this zone
                custom_heading = 100.0,
                server_event = false,
                min_z = -25.0, -- you can use this if you want the zone can be trigger only within this minimum height level
                max_z = 240.0, -- you can use this if you want the zone can be trigger only within this maximum height level
            }
        end
        if Config.EnableImpound then
            for k,v in pairs(impoundcoord) do -- repack the coordinates to new table
                garages['multi_zone'][tostring(v.garage)] = {
                    coord = vector3(v.garage_x,v.garage_y,v.garage_z),
                    custom_title = 'Garage '..v.garage, -- custom title and it wont used the ['title'] anymore
                    custom_event = 'opengarage', -- if custom_event is being used , the event ( ['event'] ) will not be used.
                    custom_arg = { 1, 2, 4, 3}, -- sample only , ordering is important on this table
                    arg_unpack = false, -- if true this will return the array as unpack to your event handler example: AddEventHandler("renzu_rayzone:test",function(a,b,c) the ,a will return the 1 ,b for 2, c for 4 ( as example config here) custom_arg = { 1, 2, 4, 3}, elseif false will return as a table.
                    custom_ped = `g_m_importexport_01`, -- custom ped for this zone
                    custom_heading = 100.0,
                    server_event = false,
                    min_z = -25.0, -- you can use this if you want the zone can be trigger only within this minimum height level
                    max_z = 240.0, -- you can use this if you want the zone can be trigger only within this maximum height level
                }
            end
        end

        if Config.EnableHeliGarage then
            for k,t in pairs(helispawn) do -- repack the coordinates to new table
                for k,v in pairs(t) do
                    garages['multi_zone'][tostring(v.garage)] = {
                        coord = vector3(v.coords.x,v.coords.y,v.coords.z),
                        custom_title = 'Garage '..v.garage, -- custom title and it wont used the ['title'] anymore
                        custom_event = 'opengarage', -- if custom_event is being used , the event ( ['event'] ) will not be used.
                        custom_arg = { 1, 2, 4, 3}, -- sample only , ordering is important on this table
                        arg_unpack = false, -- if true this will return the array as unpack to your event handler example: AddEventHandler("renzu_rayzone:test",function(a,b,c) the ,a will return the 1 ,b for 2, c for 4 ( as example config here) custom_arg = { 1, 2, 4, 3}, elseif false will return as a table.
                        custom_ped = `g_m_importexport_01`, -- custom ped for this zone
                        custom_heading = 100.0,
                        server_event = false,
                        min_z = -25.0, -- you can use this if you want the zone can be trigger only within this minimum height level
                        max_z = 240.0, -- you can use this if you want the zone can be trigger only within this maximum height level
                    }
                end
            end
        end

        garage = {
            ['zone_cooldown'] = 1, -- event cooldown
            ['popui'] = true, -- show pop ui by default, manual trigger event.
            ['multi_zone'] = garages['multi_zone'], -- insert table to the array
            -- global setting for each multi zone
            ['title'] = '🚗 My Garage', -- ignored if multizone
            ['confirm'] = '[ENTER]',
            ['reject'] = '[BACK]',
            ['thread_dist'] = 10,
            ['event_dist'] = 5,
            ['drawmarker'] = true,
            ['marker_type'] = 36,
            ['event'] = 'opengarage',
            ['invehicle_title'] = 'Store Vehicle', -- title to show instead of the ['title']
            ['spawnped'] = `g_m_importexport_01`, -- set to false if no spawnpeds else `g_m_importexport_01` (model)
        }
        zoneadd = exports['renzu_rayzone']:AddZone('Garage Zone Multi', garage) -- export!
        Wait(100)
        parking_prop = { -- Example using parking prop for parking garage
            ['type'] = 'object',
            ['job'] = 'all',
            ['model'] = {"prop_parking_hut_2","prop_parking_hut_2b","ch_prop_parking_hut_2","prop_parkingpay","dt1_21_parkinghut","prop_parking_sign_07"},
            ['dist'] = 7,
            --['target'] = 'bone',
            uidata = {
                ['garagepublic'] = {
                    ['title'] = 'Public Garage',
                    ['type'] = 'event', -- event / export
                    ['variables'] = {server = false, send_entity = false, onclickcloseui = true, custom_arg = {`street`,`coord`}, arg_unpack = true}, -- `street` = send current street name, `coord` = send current coordinates ( this is a shorcut function for custom args )
                },
            },
        }

        add = exports['renzu_rayzone']:AddRayCastTarget("Parking Target",parking_prop)
    end
end)

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

RegisterServerEvent('renzu_garage:GetVehiclesTable')
AddEventHandler('renzu_garage:GetVehiclesTable', function(garageid,public)
    local src = source 
    local xPlayer = ESX.GetPlayerFromId(src)
    local ply = Player(src).state
    local identifier = ply.garagekey or xPlayer.identifier

    --local Owned_Vehicle = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner', {['@owner'] = xPlayer.identifier})
    if not public then
        local Owned_Vehicle = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE owner = @owner', {['@owner'] = identifier})
        TriggerClientEvent("renzu_garage:receive_vehicles", src , Owned_Vehicle or {},vehicles or {})
    elseif public then
        local Owned_Vehicle = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE garage_id = @garage_id', {['@garage_id'] = garageid})
        TriggerClientEvent("renzu_garage:receive_vehicles", src , Owned_Vehicle or {},vehicles or {})
    end
end)

RegisterServerEvent('renzu_garage:GetVehiclesTableImpound')
AddEventHandler('renzu_garage:GetVehiclesTableImpound', function()
    local src = source  
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    --local Impounds = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE impound = 1', {})
    local q = 'SELECT * FROM owned_vehicles WHERE `stored` = 0 OR impound = 1'
    if not ImpoundedLostVehicle then
        q = 'SELECT * FROM owned_vehicles WHERE impound = 1'
    end
    local Impounds = MysqlGarage(Config.Mysql,'fetchAll',q, {})
    TriggerClientEvent("renzu_garage:receive_vehicles", src , Impounds,vehicles)
end)

ESX.RegisterServerCallback('renzu_garage:getjobgarages',function(source, cb, job)
    local garage = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM jobgarages WHERE `job` = @job', {['@job'] = job})
    if garage and garage[1] then
        cb(garage[1])
    end
    cb(false)
end)

ESX.RegisterServerCallback('renzu_garage:getowner',function(source, cb, identifier, plate, garage)
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

ESX.RegisterServerCallback('renzu_garage:returnpayment', function (source, cb)
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


ESX.RegisterServerCallback('renzu_garage:isvehicleingarage', function (source, cb, plate, id, ispolice, patrol)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not Config.PlateSpace then
        plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()
    else
        plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()
    end
    if patrol then
        cb(true,0)
    else
        local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT `stored` ,impound FROM owned_vehicles WHERE TRIM(UPPER(plate)) = @plate', {
            ['@plate'] = plate
        })
        if string.find(id, "impound") then
            local garage_impound = impoundcoord[1].garage
            local impound_fee = ImpoundPayment
            if result[1] and result[1].impound then
                for k,v in pairs(impound_G) do
                    for k2,v2 in pairs(v) do
                        if k2 == plate then
                            garage_impound = k
                            impound_fee = v2.fine or ImpoundPayment
                            break
                        end
                    end
                end
            end
        end
        if string.find(id, "impound") and Impoundforall and not ispolice then
            local money = impound_G[garage] ~= nil and impound_G[garage][plate] ~= nil and impound_G[garage][plate].fine or ImpoundPayment
            if xPlayer.getMoney() >= money then
                xPlayer.removeMoney(money)
                TriggerClientEvent('dopeNotify:Alert', source, "Garage", "Fahrzeug abgeholt", 5000, 'success')
                cb(1,0)
            else
                TriggerClientEvent('dopeNotify:Alert', source, "Garage", "Fahrzeug kann nicht abgeholt werden, du hast nicht genug Geld", 5000, 'error')
                cb(false,1,garage_impound,impound_fee)
            end
        elseif result and result[1].stored ~= nil then
            local stored = result[1].stored
            local impound = result[1].impound
            cb(stored,impound,garage_impound or false,impound_fee)
        end
    end
end)

ESX.RegisterServerCallback('renzu_garage:changestate', function (source, cb, plate,state,garage_id,model,props,impound_cdata, public)
    if not Config.PlateSpace then
        plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()
    else
        plate = string.gsub(tostring(plate), '^%s*(.-)%s*$', '%1'):upper()
    end
    local state = tonumber(state)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local ply = Player(source).state
    local identifier = xPlayer.identifier
    if public then
        local r = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE TRIM(UPPER(plate)) = @plate LIMIT 1', {
            ['@plate'] = plate
        })
        if r and r[1] then
            identifier = r[1].owner
        else
            TriggerClientEvent('dopeNotify:Alert', source, "Garage", "Fahrzeug hat keinen besitzer", 5000, 'error')
            cb(false,public, false)
            return
        end
    end
    if xPlayer then
        local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE owner = @owner and TRIM(UPPER(plate)) = @plate LIMIT 1', {
            ['@owner'] = identifier,
            ['@plate'] = plate
        })
        if #result > 0 and not string.find(garage_id, "impound") then
            if result[1].vehicle ~= nil then
                local veh = json.decode(result[1].vehicle)
                if veh.model == model then
                    local var = {
                        ['@vehicle'] = json.encode(props),
                        ['@garage_id'] = garage_id,
                        ['@plate'] = plate:upper(),
                        ['@owner'] = identifier,
                        ['@stored'] = state,
                        ['@job'] = state == 1 and public and xPlayer.job.name or state == 1 and result[1].job ~= nil and result[1].job or 'civ',
                    }
                    local result = MysqlGarage(Config.Mysql,'execute','UPDATE owned_vehicles SET `stored` = @stored, garage_id = @garage_id, vehicle = @vehicle, `job` = @job WHERE TRIM(UPPER(plate)) = @plate and owner = @owner', var)
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
        elseif JobImpounder[xPlayer.job.name] ~= nil and string.find(garage_id, "impound") or state ~= 1 and string.find(garage_id, "impound") and Impoundforall and JobImpounder[xPlayer.job.name] == nil then
            local result = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM owned_vehicles WHERE TRIM(UPPER(plate)) = @plate LIMIT 1', {
                ['@plate'] = plate:upper()
            })
            if #result > 0 then
                local veh = json.decode(result[1].vehicle)
                local impoundid = nil
                if veh.model == model then
                    local impound_data = {}
                    local res = MysqlGarage(Config.Mysql,'fetchAll','SELECT * FROM impound_garage WHERE garage = @garage', {['@garage'] = state == 1 and impound_cdata['impounds'] or garage_id})
                    impoundid = state == 1 and impound_cdata['impounds'] or garage_id
                    if res[1] and res[1].data then
                        impound_data = json.decode(res[1].data or '[]') or {}
                    end
                    local addimpound = false
                    if state == 1 then
                        chopstatus = os.time()
                        addimpound = true
                    else
                        garage_id = 'A'
                        chopstatus = os.time()
                    end
                    if not addimpound and impound_data[plate:upper()] then
                        impound_data[plate:upper()] = nil
                        MysqlGarage(Config.Mysql,'execute','UPDATE owned_vehicles SET `stored` = @stored, garage_id = @garage_id, impound = @impound, vehicle = @vehicle WHERE TRIM(UPPER(plate)) = @plate', {
                            ['vehicle'] = json.encode(props),
                            ['@garage_id'] = garage_id,
                            ['@impound'] = state,
                            ['@plate'] = plate:upper(),
                            ['@stored'] = state,
                        })
                    elseif addimpound then
                        impound_data[plate:upper()] = {reason = impound_cdata['reason'] or 'no reason', fine = impound_cdata['fine'] or ImpoundPayment, duration = impound_cdata['impound_duration'] or DefaultDuration, impounder = xPlayer.name, date = os.time()}
                        MysqlGarage(Config.Mysql,'execute','UPDATE owned_vehicles SET `stored` = @stored, garage_id = @garage_id, impound = @impound, vehicle = @vehicle WHERE TRIM(UPPER(plate)) = @plate', {
                            ['vehicle'] = json.encode(props),
                            ['@garage_id'] = garage_id,
                            ['@impound'] = state,
                            ['@plate'] = plate:upper(),
                            ['@stored'] = state,
                        })
                    end
                    local result = MysqlGarage(Config.Mysql,'execute','UPDATE impound_garage SET `data` = @data WHERE garage = @garage', {
                        ['@data'] = json.encode(impound_data),
                        ['@garage'] = impoundid,
                    })
                    if impound_G[impoundid] then
                        impound_G[impoundid] = impound_data
                    end
                    if state == 1 then
                        TriggerClientEvent('dopeNotify:Alert', source, "Garage", "Fahrzeug wurde beschlagnahmt", 5000, 'success')
                    else
                        TriggerClientEvent('dopeNotify:Alert', source, "Garage", "Fahrzeug wurde freigegeben", 5000, 'success')
                    end
                    cb(true,public)
                else
                    cb(false,public)
                    print('exploiting')
                end
            else
                TriggerClientEvent('dopeNotify:Alert', source, "Garage", "Fahrzeug wurde beschlagnahmt hat aber keinen Besitzer", 5000, 'warning')
                cb(false, public, false)
            end
        else
            TriggerClientEvent('dopeNotify:Alert', source, "Garage", "Fahrzeug ist nicht dein Eigentum", 5000, 'error')
            cb(false, public)
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
