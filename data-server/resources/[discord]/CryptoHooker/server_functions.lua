function CreateLog(player1, player2, description, type)
    local Webhook = Config.Webhook[type]
    

    if Webhook then
        message = {
            embeds = {{
                ["color"] = Config.Colors[Webhook.color] or 5793266,
                ["title"] = "**".. Webhook.title .."**",
                ["description"] = description,
            }},
        }
    
        if player1 then
            Player_Details = GetPlayerDetails(player1, Webhook)
            message['embeds'][1].fields = {
                {
                    ["name"] = "Spieler: "..GetPlayerName(player1),
                    ["value"] = Player_Details,
                    ["inline"] = true
                }
            }
    
            message['embeds'][1].fields[2]  = {
                ["name"] = "Zeitstempel:",
                ["value"] = "<t:".. math.floor(tonumber(os.time())) ..":R>",
                ["inline"] = false
            }
        end
    
        if player2 then
            Player_Details2 = GetPlayerDetails(player2, Webhook)
            message['embeds'][1].fields[2]  = {
                ["name"] = "Spieler: "..GetPlayerName(player2),
                ["value"] = Player_Details2,
                ["inline"] = true
            }
    
            message['embeds'][1].fields[3]  = {
                ["name"] = "Zeitstempel:",
                ["value"] = "<t:".. math.floor(tonumber(os.time())) ..":R>",
                ["inline"] = false
            }
        end
    
        if not message['embeds'][1].fields then
            message['embeds'][1].fields = {
                {
                    ["name"] = "Zeitstempel:",
                    ["value"] = "<t:".. math.floor(tonumber(os.time())) ..":R>",
                    ["inline"] = false
                }
            }
        end
        
        sendWebhooks(message, Webhook)
    else
        print("CryptoHooker: Webhook nicht gefunden: "..type)
    end
end

function sendWebhooks(embed, Webhook)
    PerformHttpRequest(Webhook.url, function(err, text, headers)
    end, 'POST', json.encode(embed), {
        ['Content-Type'] = 'application/json'
    })
end

function GetPlayerDetails(src, config, channel)
    local ids = ExtractIdentifiers(src)

	if config.elements['Postals'] then
        postal = getPlayerLocation(src)
        _postal = "\n**Postleitzahl:** ".. postal ..""
    else
        _postal = ""
    end

    if config.elements['DiscordID'] then
        if ids.discord then
            _discordID ="\n**Discord ID:** <@" ..ids.discord:gsub("discord:", "").."> ("..ids.discord:gsub("discord:", "")..")"
        else
            _discordID = "\n**Discord ID:** Unbekannt"
        end
    else
        _discordID = ""
    end

    if config.elements['SteamID'] then
        if ids.steam then
            url = "https://steamcommunity.com/profiles/" ..tonumber(ids.steam:gsub("steam:", ""),16)..""

            _steamID ="\n**Steam ID:** ["..ids.steam.."](".."https://steamcommunity.com/profiles/" ..tonumber(ids.steam:gsub("steam:", ""),16)..""..")"
        else
            _steamID = "\n**Steam ID:** Unbekannt"
        end
    else
        _steamID = ""
    end

	if config.elements['License'] then
        if ids.license then
            _license ="\n**License:** " ..ids.license
        else
            _license = "\n**License:** Unbekannt"
        end
    else
        _license = ""
    end

	if config.elements['IP'] then
        if ids.ip then
            _ip ="\n**IP:** " ..ids.ip:gsub("ip:", "")
        else
            _ip = "\n**IP:** Unbekannt"
        end
    else
        _ip = ""
    end

	if config.elements['PlayerID'] then
        _playerID ="\n**Spieler ID:** " ..src..""
    else
        _playerID = ""
    end

    if config.elements['ESX'] then
        xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer ~= nil then
            _esx = "\n\n**ESX:**"
            if config.elements['ESX']['esxName'] then
                _esx = _esx.."\n**Charachter Name:** "..xPlayer.name
            end
            if config.elements['ESX']['esxJob'] then
                _esx = _esx.."\n**Job:** "..xPlayer.job.label.."\n**Job Rang:** "..xPlayer.job.grade
            end
            if config.elements['ESX']['esxMoney'] then
                _cash = ESX.Math.GroupDigits(xPlayer.getAccount('money').money)
                _bank = ESX.Math.GroupDigits(xPlayer.getAccount('bank').money)
                _blmon = ESX.Math.GroupDigits(xPlayer.getAccount('black_money').money)
                _crypto = ESX.Math.GroupDigits(xPlayer.getAccount('crypto').money)
                _esx = _esx.."\n**Bargeld:** $".._cash.."\n**Kontostand:** $".._bank.."\n**Schwarzgeld:** $".._blmon.."\n**Crypto:** ".._crypto
            end
        else
            _esx = ""
        end
    else
        _esx = ""
    end

    return _playerID.._postal.._discordID.._steamID.._license.._ip.._esx
end

function ExtractIdentifiers(src)
    local identifiers = {}
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        if string.find(id, "steam:") then
            identifiers['steam'] = id
        elseif string.find(id, "ip:") then
            identifiers['ip'] = id
        elseif string.find(id, "discord:") then
            identifiers['discord'] = id
        elseif string.find(id, "license:") then
            identifiers['license'] = id
        elseif string.find(id, "license2:") then
            identifiers['license2'] = id
        elseif string.find(id, "xbl:") then
            identifiers['xbl'] = id
        elseif string.find(id, "live:") then
            identifiers['live'] = id
        elseif string.find(id, "fivem:") then
            identifiers['fivem'] = id
        end
    end
    return identifiers
end

function getPlayerLocation(src)
    local raw = LoadResourceFile(GetCurrentResourceName(), "./postals.json")
    local postals = json.decode(raw)
    local nearest = nil
    local player = src
    local ped = GetPlayerPed(player)
    local playerCoords = GetEntityCoords(ped)
    local x, y = table.unpack(playerCoords)

	local ndm = -1
	local ni = -1
	for i, p in ipairs(postals) do
		local dm = (x - p.x) ^ 2 + (y - p.y) ^ 2
		if ndm == -1 or dm < ndm then
			ni = i
			ndm = dm
		end
	end

	if ni ~= -1 then
		local nd = math.sqrt(ndm)
		nearest = {i = ni, d = nd}
	end
	_nearest = postals[nearest.i].code
	return _nearest
end