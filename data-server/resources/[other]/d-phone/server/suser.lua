RegisterServerEvent('d-phone:server:fire')
AddEventHandler('d-phone:server:fire', function(source, id, unemployed2 )
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local zPlayer = ESX.GetPlayerFromId(id)
    local grade = 0
    if zPlayer then
            Wait(100)
            zPlayer.setJob("unemployed", 0)
            TriggerClientEvent("d-notification", _source, _U("successfired"), 5000, "orange")
            TriggerClientEvent("d-notification", zPlayer.source, _U("gotfired"), 5000, "orange")
    else
         TriggerClientEvent("d-notification", _source, _U("personoffline"), 5000, "red")
    end
end)


RegisterServerEvent('d-phone:server:uprank')
AddEventHandler('d-phone:server:uprank', function(source, id, oldgrade)
    if source then
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local maxgrade = xPlayer.job.grade
        local job = xPlayer.job.name
        local zPlayer = ESX.GetPlayerFromId(id)
        local grade2 = tonumber(oldgrade) + 1
        local grade = tonumber(grade2)

        if zPlayer then
            if maxgrade > grade then
                zPlayer.setJob(job, grade)
                TriggerClientEvent("d-notification", _source, _U("sucessuprank", tostring(grade)), 5000, "green")
                TriggerClientEvent("d-notification", zPlayer.source, _U("gotuprank", tostring(grade)), 5000, "green")
            else
                TriggerClientEvent("d-notification", _source, _U("ranktohigh"), 5000, "red")
            end
        else
            TriggerClientEvent("d-notification", _source, _U("personoffline"), 5000, "red")
        end
    end
end)

RegisterServerEvent('d-phone:server:derank')
AddEventHandler('d-phone:server:derank', function(source, id, oldgrade)
    if source then
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local job = xPlayer.job.name
        local zPlayer = ESX.GetPlayerFromId(id)
        local grade2 = tonumber(oldgrade) - 1
        local grade = tonumber(grade2)

        if zPlayer then
            if grade >= 0 then
                zPlayer.setJob(job, grade)
                TriggerClientEvent("d-notification", _source, _U("successderank", tostring(grade)), 5000, "orange")
                TriggerClientEvent("d-notification", zPlayer.source, _U("gotderank", tostring(grade)), 5000, "orange")
            else
                TriggerClientEvent("d-notification", _source, _U("alreadylow"), 5000, "red")
            end
        else
            TriggerClientEvent("d-notification", _source, _U("personoffline"), 5000, "red")
        end
    end
end)


RegisterServerEvent('d-phone:server:recruit')
AddEventHandler('d-phone:server:recruit', function(source, id, grade2 )
    if source then
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local job = xPlayer.job.name
        local joblabel = xPlayer.job.label
        local maxgrade = xPlayer.job.grade
        local zPlayer = ESX.GetPlayerFromId(id)
        local grade = tonumber(grade2)

        if zPlayer then
            if maxgrade > grade then
                zPlayer.setJob(job, grade )
                TriggerClientEvent("d-notification", _source, _U("recruit", tostring(grade)), 5000, "green")
                TriggerClientEvent("d-notification", zPlayer.source, _U("gotrecruit", joblabel, tostring(grade)), 5000, "green")
            else
                TriggerClientEvent("d-notification", _source, _U("ranktohigh"), 5000, "red")
            end
        else
            TriggerClientEvent("d-notification", _source, _U("personoffline"), 5000, "red")
        end
    end
end)

-- ESX 1.1
TriggerEvent('es:addGroupCommand', 'sca', 'user', function(p, args, user)
    TriggerClientEvent("d-phone:client:acceptsharecontact", p)
end)

TriggerEvent('es:addGroupCommand', 'scd', 'user', function(p, args, user)
    TriggerClientEvent("d-phone:client:declinesharecontact", p)
end)

TriggerEvent('es:addGroupCommand', 'reloaddata', 'user', function(p, args, user)
    TriggerEvent("d-phone:server:reloaduserdata", p)
end)

-- ESX 1.2
--[[
ESX.RegisterCommand('sca', 'user', function(xPlayer, args, showError)
    TriggerClientEvent("d-phone:client:acceptsharecontact", xPlayer.source)
  end)
  
  ESX.RegisterCommand('scd', 'user', function(xPlayer, args, showError)
    TriggerClientEvent("d-phone:client:declinesharecontact", xPlayer.source)
  end)
  ]]

  function getPhoneRandomNumber()
    local numBase0 = math.random(Config.LowerPrefix, Config.HigherPrefix)
    local numBase1 = math.random(Config.LowerNumber, Config.HigherNumber)
    local num
    if Config.Prefix == true then
        num = string.format(numBase0.. ""..numBase1)
    else
        num = string.format(numBase1)
    end
	return num
end

function getRandomCardNumber()
    local numBase0 = math.random(1000000000000000, 9999999999999999)
    local num = string.format(numBase0)

	return num
end


RegisterCommand(Config.CommandText, function(source, args, raw)
    if Config.Command == true then
        TriggerClientEvent('d-phone:client:openphone', source)
    end
  end)

--   Advertisement
RegisterServerEvent('d-phone:server:advertisement:newad')
AddEventHandler('d-phone:server:advertisement:newad', function(source, clientsource, name, message)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local Data = UserData[clientsource]
    local number = Data.phone_number
    local date = os.date("%d") .. "."  .. os.date("%m")
    local time = os.date("%H") .. ':' .. os.date("%M")
    local id = 0

    local blacklistwordfound = false
    for _,v in pairs(Wordblacklist) do
        if string.match(name, v) then
            blacklistwordfound = true
        end
        if string.match(message, v) then
            blacklistwordfound = true
        end
    end
    Wait(10)
    if blacklistwordfound == false then
        if Advertisement ~= nil then
            for i,v in pairs(Advertisement) do
                id = v.id
                break
            end
        end
        Wait(10)
        table.insert(Advertisement,
            {
                id = (id + 1),
                name = name,
                number = number,
                message = message,
                date = date,
                time = time
            }
        )
        table.sort(Advertisement, function(a,b) return a.id > b.id end)
        
        TriggerEvent("d-phone:server:advertisement:refresh", _source, clientsource)
        MySQL.Async.execute("INSERT INTO `phone_advertisement` (`name`, `number`, `message`, `date`, `time`) VALUES (@name, @number, @message, @date, @time)",
            {['@name'] = name, 
            ['@number'] = number,
            ['@message'] = message,
            ['@date'] = date,
            ['@time'] = time,
        })
    end
end)

-- Events for messages etc
AddEventHandler('d-phone:server:sendmessage', function(source, clientsource, message, number2)
end)

AddEventHandler('d-phone:server:sendgps', function(source, clientsource, number2, pos)
end)

AddEventHandler('d-phone:server:sendbusinessmessage', function(source, message, number2, job)
end)

AddEventHandler('d-phone:server:sendbusinessgps', function(source, number2, pos, job, position)
end)

AddEventHandler('d-phone:server:sendservicemessage', function(source, clientsource, rawmessage, job, sendnumber, gps, position, isDead)
end)

AddEventHandler('d-phone:server:twitter:writetweet', function(source, clientsource, message, twitteraccount, image)
end)

RegisterServerEvent('d-phone:server:checkphone')
AddEventHandler('d-phone:server:checkphone', function(source)
    if source then
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        if Config.Debug == true then
            print("CheckPhone1 | Working")
        end
        local item = xPlayer.getInventoryItem("phone")
        if Config.Debug == true then
            print("CheckPhone2 | Working")
        end

        if item == nil then
            if Config.Debug == true then
                print("You forgot to add the item 'phone' to your Database. Add this and it will work")
            end
        end

        if item.count >= 1 then
            if Config.Debug == true then
                print("CheckPhone3 | Working")
            end
            TriggerClientEvent("d-phone:client:hasphone", _source)
        else
            if Config.Debug == true then
                print("CheckPhone3 | Working")
            end
            TriggerClientEvent("d-phone:client:hasnophone", _source)
        end
    end
end)

function GetTime()
    local time = os.date("%x") .. ' ' .. os.date("%H") .. ':' .. os.date("%M")
    return time
end