ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, height FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		if result[1] then
			if result[1].firstname then
				local playerIdentity = {
					firstName = result[1].firstname,
					lastName = result[1].lastname,
					dateOfBirth = result[1].dateofbirth,
					sex = result[1].sex,
					height = result[1].height
				}

				xPlayer.setName(('%s %s'):format(playerIdentity.firstName, playerIdentity.lastName))
				xPlayer.set('firstName', playerIdentity.firstName)
				xPlayer.set('lastName', playerIdentity.lastName)
				xPlayer.set('dateofbirth', playerIdentity.dateOfBirth)
				xPlayer.set('sex', playerIdentity.sex)
				xPlayer.set('height', playerIdentity.height)

			end
		end
	end)
end)

RegisterServerEvent('esx_multichar:GetPlayerCharacters')
AddEventHandler('esx_multichar:GetPlayerCharacters', function()
    local src = source
    local LastCharId = GetLastCharacter(src)
    local license = GetRockstarID(src)
    SetIdentifierToChar(GetIdentifierWithoutLicense(license), LastCharId)

    print('md: ' .. GetIdentifierWithoutLicense(license) .. ' to ' .. LastCharId..':'..GetIdentifierWithoutLicense(license))
    if Config.useMyDrugs then
        TriggerEvent('myDrugs:updateIdentifier', src, GetIdentifierWithoutLicense(license), LastCharId..':'..GetIdentifierWithoutLicense(license))
    end
    
    if Config.useMyProperties then
        TriggerEvent('myProperties:updateIdentifier', src, GetIdentifierWithoutLicense(license), LastCharId..':'..GetIdentifierWithoutLicense(license))
    end
	

    local chars = GetPlayerCharacters(src)
    local maxChars = GetPlayerMaxChars(src)
    TriggerClientEvent('esx_multichar:receiveChars', src, chars, maxChars[1].maxChars)
end)

RegisterServerEvent('esx_multichar:CharSelected')
AddEventHandler('esx_multichar:CharSelected', function(charid, isnew)
    local src = source
    local spawn = {}
    SetLastCharacter(src, tonumber(charid))
    SetCharToIdentifier(GetIdentifierWithoutLicense(GetRockstarID(src)), tonumber(charid))
    
    if Config.useMyDrugs then
        TriggerEvent('myDrugs:updateIdentifier', src, tonumber(charid)..':'..GetIdentifierWithoutLicense(GetRockstarID(src)), GetIdentifierWithoutLicense(GetRockstarID(src)))
    end

    if Config.useMyProperties then
        TriggerEvent('myProperties:updateIdentifier', src, tonumber(charid)..':'..GetIdentifierWithoutLicense(GetRockstarID(src)), GetIdentifierWithoutLicense(GetRockstarID(src)))
    end

    if not isnew then
        
        if GetSpawnPos(src) == nil then
            spawn = Config.FirstSpawnLocation
        end
		spawn = GetSpawnPos(src)
		TriggerClientEvent("esx_multichar:SpawnCharacter", src, spawn, false)
    else
		TriggerClientEvent('skinchanger:loadDefaultModel', src, true, cb)
        spawn = Config.FirstSpawnLocation -- DEFAULT SPAWN POSITION
		TriggerClientEvent("esx_multichar:SpawnCharacter", src, spawn, true)
    end
    
end)

function GetPlayerCharacters(source)
    local identifier = GetIdentifierWithoutLicense(GetRockstarID(source))
    local Chars = executeMySQL("SELECT * FROM `users` WHERE identifier LIKE '%"..identifier.."%'")
    return Chars
end

function GetPlayerMaxChars(source)
    local identifier = GetIdentifierWithoutLicense(GetRockstarID(source))
    local maxChars = executeMySQL("SELECT `maxChars` FROM `user_lastcharacter` WHERE steamid LIKE '%"..identifier.."%'")
    return maxChars
end

function GetLastCharacter(source)
    local LastChar = executeMySQL("SELECT `charid` FROM `user_lastcharacter` WHERE `steamid` = '"..GetIdentifierWithoutLicense(GetRockstarID(source)).."'")
    if LastChar[1] ~= nil and LastChar[1].charid ~= nil then
        return tonumber(LastChar[1].charid)
    else
        executeMySQL("INSERT INTO `user_lastcharacter` (`steamid`, `charid`) VALUES('"..GetIdentifierWithoutLicense(GetRockstarID(source)).."', 1)")
        return 1
    end
end

function SetLastCharacter(source, charid)
    executeMySQL("UPDATE `user_lastcharacter` SET `charid` = '"..charid.."' WHERE `steamid` = '"..GetIdentifierWithoutLicense(GetRockstarID(source)).."'")
end

function GetSpawnPos(source)

    local posRes = executeMySQL("SELECT `position` FROM `users` WHERE `identifier` = '"..GetIdentifierWithoutLicense(GetRockstarID(source)).."'")
	
	if posRes[1] ~= nil then
		return json.decode(posRes[1].position)
	else
		return nil
	end
    
end

function SetIdentifierToChar(identifier, charid)

    print('Char'..charid..':'..GetIdentifierWithoutLicense(identifier) .. ' WHERE ' .. identifier)
    for k, data in pairs(Config.Tables) do
        executeMySQL("UPDATE `"..data.table.."` SET `"..data.column.."` = '"..charid..":"..GetIdentifierWithoutLicense(identifier).."' WHERE `"..data.column.."` = '"..identifier.."'")
    end
    -- REPLACE steam:111 to CharX:111
    
end

function SetCharToIdentifier(identifier, charid)

    print(identifier .. ' WHERE  ' .. 'Char'..charid..':'..GetIdentifierWithoutLicense(identifier))

    for k, data in pairs(Config.Tables) do
        executeMySQL("UPDATE `"..data.table.."` SET `"..data.column.."` = '"..identifier.."' WHERE `"..data.column.."` = '"..charid..":"..GetIdentifierWithoutLicense(identifier).."'")
    end
    -- REPLACE CharX:111 to steam:111
    
end

function DeleteCharacter(identifier, charid, maxChars)

    for k, data in pairs(Config.Tables) do
        executeMySQL("DELETE FROM `"..data.table.."` WHERE `"..data.column.."` = '"..charid..":"..GetIdentifierWithoutLicense(identifier).."'")
    end
    --executeMySQL("DELETE FROM users WHERE identifier = 'Char"..charid..GetIdentifierWithoutSteam(identifier).."'")

    if charid ~= maxChars then
        for i=charid, maxChars-1, 1 do
            
            local oldID = math.floor(i + 1)
            local newId = math.floor(i)

            --print('change: Char' .. oldID .. ' to ' .. 'Char' .. newId)

            for k, data in pairs(Config.Tables) do
                executeMySQL("UPDATE `"..data.table.."` SET `"..data.column.."` = '"..newId..":"..GetIdentifierWithoutLicense(identifier).."' WHERE `"..data.column.."` = '"..oldID..":"..GetIdentifierWithoutLicense(identifier).."'")
            end
        end
    end
end


RegisterServerEvent('esx_multichar:deleteChar')
AddEventHandler('esx_multichar:deleteChar', function(charid, maxChars)
    local steamID = GetRockstarID(source)
    DeleteCharacter(steamID, charid, maxChars)
end)

function GetIdentifierWithoutLicense(Identifier)
    return string.gsub(Identifier, "license:", "")
end

function GetRockstarID(playerId)
    local identifier

    for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
        if string.match(v, 'license') then
            identifier = v
            break
        end
    end

    return identifier
end

function executeMySQL(queryString)
    local doing = true -- IMPORTANT! 
    local result = nil

    MySQL.Async.fetchAll(queryString, {}, function(data)
        result = data
        doing = false
    end)

    while doing do
        Citizen.Wait(0)
    end

    return result
end




function getIdentity(source, callback)

    local identifier = GetRockstarID(source)
    MySQL.Async.fetchAll("SELECT * FROM `users` WHERE `identifier` = @identifier",
    {
        ['@identifier'] = GetIdentifierWithoutLicense(identifier)
    },
    function(result)
        if #result > 0 then
            if result[1].firstname ~= nil or result[1].firstname ~= '' then
                --print('Character is there')
                local data = {
                    identifier  = result[1].identifier,
                    firstname  = result[1].firstname,
                    lastname  = result[1].lastname,
                    dateofbirth  = result[1].dateofbirth,
                    sex      = result[1].sex,
                    height    = result[1].height,
                }
                callback(data)
            else
                print(result[1].identifier)
                local data = nil
                callback(data)
            end
        else
            print('nothing there')
            local data = nil
            callback(data)
        end
    end)

end

function RegisterNewAccount(identifier_res, firstname_res, lastname_res, dateofbirth_res, sex_res, height_res)
    MySQL.Async.execute("UPDATE `users` SET `firstname` = @firstname, `lastname` = @lastname, `dateofbirth` = @dateofbirth, `sex` = @sex, `height` = @height WHERE identifier = @identifier",
    {
      ['@identifier']   = identifier_res,
      ['@firstname']    = firstname_res,
      ['@lastname']     = lastname_res,
      ['@dateofbirth']  = dateofbirth_res,
      ['@sex']          = sex_res,
      ['@height']       = height_res,
    })
	
end


RegisterServerEvent('esx_multichar:updateAccount')
AddEventHandler('esx_multichar:updateAccount', function(firstname_res, lastname_res, dateofbirth_res, sex_res, height_res)


    local identifier_res = GetIdentifierWithoutLicense(GetRockstarID(source))
    RegisterNewAccount(identifier_res, firstname_res, lastname_res, dateofbirth_res, sex_res, height_res)

end)


RegisterServerEvent('esx_multichar:updatePedModel')
AddEventHandler('esx_multichar:updatePedModel', function(newModel)
    local steamID = GetIdentifierWithoutLicense(GetRockstarID(source))
    MySQL.Async.execute("UPDATE `users` SET `pedModel` = @pedModel WHERE identifier = @identifier",
    {
      ['@identifier']   = steamID,
      ['@pedModel']    = newModel,
    })
end)

RegisterServerEvent('esx_multichar:updatePermissions')
AddEventHandler('esx_multichar:updatePermissions', function(target, type, value)
    local steamID = GetIdentifierWithoutLicense(GetRockstarID(source))

    if steamID ~= nil then
        if type == 'pedmode' then
            MySQL.Async.execute("UPDATE `users` SET `pedModeAllowed` = @pedAllowed WHERE identifier = @identifier",
            {
            ['@identifier']   = steamID,
            ['@pedAllowed']    = value,
            })
            TriggerClientEvent('esx_multichar:msg', source, Translation[Config.Locale]['giveperm_success'])

        elseif type == 'charamount' then
            MySQL.Async.execute("UPDATE `user_lastcharacter` SET `maxChars` = @maxChars WHERE steamid = @identifier",
            {
            ['@identifier']   = steamID,
            ['@maxChars']    = value,
            })
            TriggerClientEvent('esx_multichar:msg', source, Translation[Config.Locale]['giveperm_success'])
        end
    else
        TriggerClientEvent('esx_multichar:msg', source, Translation[Config.Locale]['giveperm_error'])
    end

   
end)

AddEventHandler('es:playerLoaded', function(source)

    getIdentity(source, function(data)
    
        if data.firstname == '' then
			if Config.useRegisterMenu then
				TriggerClientEvent('esx_multichar:RegisterNewAccount', source)
			end
        else
            print('Character loaded: ' .. data.firstname .. ' ' .. data.lastname)
        end
    
    end)

    local steamID = GetIdentifierWithoutLicense(GetRockstarID(source))

    MySQL.Async.fetchAll('SELECT pedModel FROM users WHERE identifier = @identifier',
    {
        ['@identifier'] = steamID,

    },
    function(result)
        if #result > 0 then
            if result[1].pedModel ~= nil then
                TriggerClientEvent('esx_multichar:applyPed', source, result[1].pedModel)
            end
        end
    end
    )

end)

if Config.useRegisterMenu then
	RegisterCommand('register', function(source, args, raw)

		local steamID = GetIdentifierWithoutLicense(GetRockstarID(source))

		MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',
		{
			['@identifier'] = steamID,

		},
		function(result)
			if #result > 0 then
				TriggerClientEvent('esx_multichar:RegisterNewAccount', source, result[1].firstname, result[1].lastname, result[1].dateofbirth, result[1].sex, result[1].height)
			else
				TriggerClientEvent('esx_multichar:RegisterNewAccount', source)
			end
		end
		)
	end, false)
end

RegisterCommand('changePed', function(source, args, raw)

    local steamID = GetIdentifierWithoutLicense(GetRockstarID(source))

    MySQL.Async.fetchAll('SELECT pedModeAllowed, pedModel FROM users WHERE identifier = @identifier',
    {
        ['@identifier'] = steamID,

    },
    function(result)
        if #result > 0 then
            if result[1].pedModeAllowed ~= nil then
                TriggerClientEvent('esx_multichar:openPedMenu', source, result[1].pedModel)
            else
                TriggerClientEvent('esx_multichar:msg', source, Translation[Config.Locale]['pedmode_no_perms'])
            end
        else
            TriggerClientEvent('esx_multichar:msg', source, Translation[Config.Locale]['pedmode_no_perms'])
        end
    end
    )
end, false)

