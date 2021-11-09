AesxAdmin = {}
CurrentWeather = Config.StartWeather
local baseTime, timeOffset, freezeTime, blackout = Config.BaseTime, 0, false, Config.Blackout
local newWeatherTimer = Config.NewWeatherTimer

RegisterServerEvent('AesxAdmin:requestSync')
AddEventHandler('AesxAdmin:requestSync', function()
    TriggerClientEvent('AesxAdmin:updateWeather', -1, CurrentWeather, blackout)
    TriggerClientEvent('AesxAdmin:updateTime', -1, baseTime, timeOffset, freezeTime)
end)

function ShiftToMinute(minute)
    timeOffset = timeOffset - ( ( (baseTime+timeOffset) % 60 ) - minute )
end

function ShiftToHour(hour)
    timeOffset = timeOffset - ( ( ((baseTime+timeOffset)/60) % 24 ) - hour ) * 60
end

AesxAdmin.freezeTime = function(source)
    if source ~= 0 then
        local xPlayer = ESX.GetPlayerFromId(source)
        local playerGroup = xPlayer.getGroup()
        if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanFreezeTime then
            freezeTime = not freezeTime
            if freezeTime then
                TriggerClientEvent('esx:showNotification', source, 'Time frozen') 
            else
                TriggerClientEvent('esx:showNotification', source, 'Time unfrozen') 
            end
        else
            TriggerClientEvent('chat:addMessage', source, {args = {"AesxAdmin ", " You do not have permission for this."}})
        end
    end
end

AesxAdmin.Time = function(source, args)
    if source == 0 then
        if tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil then
            local argh = tonumber(args[1])
            local argm = tonumber(args[2])
            if argh < 24 then
                ShiftToHour(argh)
            else
                ShiftToHour(0)
            end
            if argm < 60 then
                ShiftToMinute(argm)
            else
                ShiftToMinute(0)
            end
            print("time changed")
            TriggerEvent('AesxAdmin:requestSync')
        else
            print("invalid time")
        end
    elseif source ~= 0 then
        local xPlayer = ESX.GetPlayerFromId(source)
        local playerGroup = xPlayer.getGroup()
        if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanChangeTime then
            if tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil then
                local argh = tonumber(args[1])
                local argm = tonumber(args[2])
                if argh < 24 then
                    ShiftToHour(argh)
                else
                    ShiftToHour(0)
                end
                if argm < 60 then
                    ShiftToMinute(argm)
                else
                    ShiftToMinute(0)
                end
                local newtime = math.floor(((baseTime+timeOffset)/60)%24) .. ":"
                local minute = math.floor((baseTime+timeOffset)%60)
                if minute < 10 then
                    newtime = newtime .. "0" .. minute
                else
                    newtime = newtime .. minute
                end
                TriggerClientEvent('esx:showNotification', source, 'Time changed to '..newtime) 
                TriggerEvent('AesxAdmin:requestSync')
            else
                TriggerClientEvent('chat:addMessage', source, {args = {"AesxAdmin ", " Invalid time."}})
            end
        else
            TriggerClientEvent('chat:addMessage', source, {args = {"AesxAdmin ", " You do not have permission for this."}})
        end
    end
end

AesxAdmin.freezeWeather = function(source)
    if source ~= 0 then
        local xPlayer = ESX.GetPlayerFromId(source)
        local playerGroup = xPlayer.getGroup()
        if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanFreezeWeather then
            Config.DynamicWeather = not Config.DynamicWeather
            if not Config.DynamicWeather then
                TriggerClientEvent('esx:showNotification', source, 'Dynamic Weather disabled') 
            else
                TriggerClientEvent('esx:showNotification', source, 'Dynamic Weather enabled') 
            end
        else
            TriggerClientEvent('chat:addMessage', source, {args = {"AesxAdmin ", " You do not have permission for this."}})
        end
    end
end

AesxAdmin.Weather = function(source, args, invokeMethod)
    if source == 0 then
        local validWeatherType = false
        if args[1] == nil then
            print("invalid weather syntax")
            return
        else
            for i,wtype in ipairs(Config.AvailableWeatherTypes) do
                if wtype == string.upper(args[1]) then
                    validWeatherType = true
                end
            end
            if validWeatherType then
                print("weather updated")
                CurrentWeather = string.upper(args[1])
                newWeatherTimer = 10
                TriggerEvent('AesxAdmin:requestSync')
            else
                print("weather invalid")
            end
        end
    else
        local xPlayer = ESX.GetPlayerFromId(source)
        local playerGroup = xPlayer.getGroup()
        if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanChangeWeather then
            local validWeatherType = false
            if invokeMethod == "command" then
                if args[1] == nil then
                     TriggerClientEvent('chat:addMessage', source, {args = {"AesxAdmin ", " Invalid weather syntax"}})
                else
                    TriggerClientEvent('esx:showNotification', source, " Weather will change to "..string.lower(args[1])) 
                    CurrentWeather = string.upper(args[1])
                    newWeatherTimer = 10
                    TriggerEvent('AesxAdmin:requestSync')
                end
            elseif invokeMethod == "gui" then
                TriggerClientEvent('esx:showNotification', source, " Weather will change to "..string.lower(args)) 
                CurrentWeather = args
                newWeatherTimer = 10
                TriggerEvent('AesxAdmin:requestSync')
            end
        else
            TriggerClientEvent('chat:addMessage', source, {args = {"AesxAdmin ", " You do not have permission for this."}})
        end
    end
end

AesxAdmin.Blackout = function(source)
    if source == 0 then
        blackout = not blackout
        if blackout then
            print('blackout enabled')
        else
            print('blackout disabled')
        end
    else
        local xPlayer = ESX.GetPlayerFromId(source)
        local playerGroup = xPlayer.getGroup()
        if Config.Perms[playerGroup] and Config.Perms[playerGroup].CanBlackout then
            blackout = not blackout
            if blackout then
                TriggerClientEvent('esx:showNotification', source, 'Blackout enabled') 
            else
                TriggerClientEvent('esx:showNotification', source, 'Blackout disabled') 
            end
            TriggerEvent('AesxAdmin:requestSync')
        end
    end
end

RegisterNetEvent('AesxAdmin:freezeWeather')
AddEventHandler('AesxAdmin:freezeWeather', function(weather)
    AesxAdmin.freezeWeather(source)
end)

RegisterCommand('freezeweather', function(source, args)
    AesxAdmin.freezeWeather(source)
end)

RegisterNetEvent('AesxAdmin:Weather')
AddEventHandler('AesxAdmin:Weather', function(weather)
    AesxAdmin.Weather(source, weather, "gui")
end)

RegisterCommand('weather', function(source, args)
    AesxAdmin.Weather(source, args, "command")
end)

RegisterNetEvent('AesxAdmin:Blackout')
AddEventHandler('AesxAdmin:Blackout', function()
    AesxAdmin.Blackout(source)
end)

RegisterCommand('blackout', function(source)
    AesxAdmin.Blackout(source)
end)

RegisterNetEvent('AesxAdmin:freezeTime')
AddEventHandler('AesxAdmin:freezeTime', function()
    AesxAdmin.freezeTime(source)
end)

RegisterCommand('freezetime', function(source, args)
    AesxAdmin.freezeTime(source)
end)

RegisterNetEvent('AesxAdmin:Time')
AddEventHandler('AesxAdmin:Time', function(args)
    args = split(args, ':')
    AesxAdmin.Time(source, args)
end)

RegisterCommand('time', function(source, args, rawCommand)
    AesxAdmin.Time(source, args)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local newBaseTime = os.time(os.date("!*t"))/2 + 360
        if freezeTime then
            timeOffset = timeOffset + baseTime - newBaseTime            
        end
        baseTime = newBaseTime
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        TriggerClientEvent('AesxAdmin:updateTime', -1, baseTime, timeOffset, freezeTime)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000)
        TriggerClientEvent('AesxAdmin:updateWeather', -1, CurrentWeather, blackout)
    end
end)

Citizen.CreateThread(function()
    while true do
        newWeatherTimer = newWeatherTimer - 1
        Citizen.Wait(60000)
        if newWeatherTimer == 0 then
            if Config.DynamicWeather then
                NextWeatherStage()
            end
            newWeatherTimer = 10
        end
    end
end)

function NextWeatherStage()
    if CurrentWeather == "CLEAR" or CurrentWeather == "CLOUDS" or CurrentWeather == "EXTRASUNNY"  then
        local new = math.random(1,2)
        if new == 1 then
            CurrentWeather = "CLEARING"
        else
            CurrentWeather = "OVERCAST"
        end
    elseif CurrentWeather == "CLEARING" or CurrentWeather == "OVERCAST" then
        local new = math.random(1,6)
        if new == 1 then
            if CurrentWeather == "CLEARING" then CurrentWeather = "FOGGY" else CurrentWeather = "RAIN" end
        elseif new == 2 then
            CurrentWeather = "CLOUDS"
        elseif new == 3 then
            CurrentWeather = "CLEAR"
        elseif new == 4 then
            CurrentWeather = "EXTRASUNNY"
        elseif new == 5 then
            CurrentWeather = "SMOG"
        else
            CurrentWeather = "FOGGY"
        end
    elseif CurrentWeather == "THUNDER" or CurrentWeather == "RAIN" then
        CurrentWeather = "CLEARING"
    elseif CurrentWeather == "SMOG" or CurrentWeather == "FOGGY" then
        CurrentWeather = "CLEAR"
    end
    TriggerEvent("AesxAdmin:requestSync")
end

function split(s, delimiter)
    result = {}
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end