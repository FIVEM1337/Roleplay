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

Citizen.CreateThread(function()

    if Config.ESX12 then
        ESX.RegisterCommand('sca', 'user', function(xPlayer, args, showError)
            TriggerClientEvent("d-phone:client:acceptsharecontact", xPlayer.source)
          end)
          
        ESX.RegisterCommand('scd', 'user', function(xPlayer, args, showError)
        TriggerClientEvent("d-phone:client:declinesharecontact", xPlayer.source)
        end)
    else
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
    end

end)



-- ESX 1.2
--[[

  ]]

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
        MySQL.Async.execute("INSERT INTO `phone_advertisement` (`id`, `name`, `number`, `message`, `date`, `time`) VALUES (@id, @name, @number, @message, @date, @time)",
            {
            ['@id'] = (id + 1), 
            ['@name'] = name, 
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

math.randomseed(os.time()) 

function GeneratePhoneNumber()
    local numBase0 = math.random(Config.LowerPrefix, Config.HigherPrefix)
    local numBase1 = math.random(Config.LowerNumber, Config.HigherNumber)
    local number = string.format("%03d-%04d", numBase0, numBase1)
    
    if Config.Prefix == true then
        number = string.format("%s%s%s", numBase0, Config.numBaseSpace, numBase1)
    else
        number = string.format("%s%s", numBase0, numBase1)
    end
    return number
end

-- Banking
RegisterServerEvent('d-phone:server:banking:load')
AddEventHandler('d-phone:server:banking:load', function(source, clientsource)
    if source then
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local bankmoney = xPlayer.getAccount('bank').money
        local data = UserData[clientsource]
        local html = ''
        if Config.Debug == true then
            print("banking:load | Test1")
        end

        if data.transactions[1] ~= nil or data.transactions[0] ~= nil then
            if Config.Debug == true then
                print("banking:load | Test2")
            end
            for _,v in pairs(data.transactions) do
                if Config.Debug == true then
                    print("banking:load | Test3")
                end
                table.sort(v, function(a,b) return a.id > b.id end)
                for _,k in pairs(v) do
                    if Config.Debug == true then
                        print("banking:load | Test4")
                    end
                    if k.cardnumber == data.cardnumber then
                        html = html .. string.format('<div class="phone-bankapp-transaction"><div class="phone-bankapp-transaction-header"><div class="phone-bankapp-transaction-header-name">%s</div><div class="phone-bankapp-transaction-header-amount minus">-%s$</div></div><div class="phone-bankapp-transaction-bottom">%s</div></div>', k.targetname, k.amount, k.date)
                    else
                        html = html .. string.format('<div class="phone-bankapp-transaction"><div class="phone-bankapp-transaction-header"><div class="phone-bankapp-transaction-header-name">%s</div><div class="phone-bankapp-transaction-header-amount plus">+%s$</div></div><div class="phone-bankapp-transaction-bottom">%s</div></div>', k.cardname, k.amount, k.date)
                    end
                end
            end
        end
        if Config.Debug == true then
            print("banking:load | Test5")
            print("banking:load | Bankmoney " ..bankmoney)
            print("banking:load | html " ..html)
            print("banking:load | cardnumber " ..data.cardnumber)
            print("banking:load | rpname " ..data.rpname)
        end
        Wait(100)
        TriggerClientEvent("d-phone:client:banking:load", _source, bankmoney, html, data.cardnumber, data.rpname)
    end
end)

RegisterServerEvent('d-phone:server:banking:dasdas')
AddEventHandler('d-phone:server:banking:dasdas', function(source, clientsource, targetnumber, amount2)
    -- Transfer
    if source and targetnumber ~= nil or targetnumber ~= "" or amount2:find("%D") then
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local bankmoney = xPlayer.getAccount('bank').money
        local data = UserData[clientsource]
        local otherdata = GetUserDataByCardnumber(targetnumber) 
        local amount = tonumber(amount2)
        local time = os.date("%x") .. ' ' .. os.date("%H") .. ':' .. os.date("%M")
        Wait(Config.UserDataWaitingTime)
        if bankmoney >= amount and amount > 0 then
                if otherdata then
                    local Othersource = getOthersource(otherdata.identifier)
                    if Othersource ~= nil then
                        local xTarget = ESX.GetPlayerFromId(Othersource)
                        xPlayer.removeAccountMoney('bank', amount)
                        xTarget.addAccountMoney('bank', amount)

                        TriggerClientEvent("d-notification", _source, _U("moneysended",  otherdata.rpname, tostring(amount)), 5000, "#44BB34")
                        TriggerClientEvent("d-notification", Othersource, _U("moneytransfered", data.rpname, tostring(amount)), 5000, "#44BB34")

                        MySQL.Async.execute("INSERT INTO `phone_banking_transactions` (`cardnumber`, `cardname`, `targetnumber`, `targetname`, `date`, `amount`) VALUES (@cardnumber, @cardname, @targetnumber, @targetname, @date, @amount)",
                            {
                                ['@cardnumber'] = data.cardnumber, 
                                ['@cardname'] = data.rpname,
                                ['@targetnumber'] = targetnumber, 
                                ['@targetname'] = otherdata.rpname,   
                                ['@date'] = time, 
                                ['@amount'] = amount,   
                        })

                        TriggerClientEvent("d-phone:client:banking:forcerefresh", _source)
                        TriggerClientEvent("d-phone:client:banking:forcerefresh", Othersource)
                    else
                        TriggerClientEvent("d-notification", _source, _U("personoffline"), 5000, "#E82323")
                    end
                else
                    TriggerClientEvent("d-notification", _source, _U("personoffline"), 5000, "#E82323")
                end
        else
                -- Not enough money
                TriggerClientEvent("d-notification", _source, _U("notenoughmoney"), 5000, "#E82323")
        end
    end
end)