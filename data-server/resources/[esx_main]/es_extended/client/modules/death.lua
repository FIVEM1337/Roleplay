CreateThread(function()
	local isDead = false

	while true do
		local sleep = 1500
		local player = PlayerId()

		if NetworkIsPlayerActive(player) then
			local playerPed = PlayerPedId()

			if IsPedFatallyInjured(playerPed) and not isDead then
				sleep = 0
				isDead = true

				local killerEntity, deathCause = GetPedSourceOfDeath(playerPed), GetPedCauseOfDeath(playerPed)
				local killerClientId = NetworkGetPlayerIndexFromPed(killerEntity)

				if killerEntity ~= playerPed and killerClientId and NetworkIsPlayerActive(killerClientId) then
					PlayerKilledByPlayer(GetPlayerServerId(killerClientId), killerClientId, deathCause)
				else
					PlayerKilled(deathCause)
				end

			elseif not IsPedFatallyInjured(playerPed) and isDead then
				sleep = 0
				isDead = false
			end
		end
	Wait(sleep)
	end
end)

function PlayerKilledByPlayer(killerServerId, killerClientId, deathCause)
	local victimCoords = GetEntityCoords(PlayerPedId())
	local killerCoords = GetEntityCoords(GetPlayerPed(killerClientId))
	local distance = #(victimCoords - killerCoords)

	local data = {
		victimCoords = {x = ESX.Math.Round(victimCoords.x, 1), y = ESX.Math.Round(victimCoords.y, 1), z = ESX.Math.Round(victimCoords.z, 1)},
		killerCoords = {x = ESX.Math.Round(killerCoords.x, 1), y = ESX.Math.Round(killerCoords.y, 1), z = ESX.Math.Round(killerCoords.z, 1)},

		killedByPlayer = true,
		deathCause = deathCause,
		distance = ESX.Math.Round(distance, 1),

		killerServerId = killerServerId,
		killerClientId = killerClientId
	}

	TriggerEvent('esx:onPlayerDeath', data)
	TriggerServerEvent('esx:onPlayerDeath', data)
end

function PlayerKilled(deathCause)
	local playerPed = PlayerPedId()
	local victimCoords = GetEntityCoords(playerPed)

	local data = {
		victimCoords = {x = ESX.Math.Round(victimCoords.x, 1), y = ESX.Math.Round(victimCoords.y, 1), z = ESX.Math.Round(victimCoords.z, 1)},

		killedByPlayer = false,
		deathCause = deathCause
	}

	TriggerEvent('esx:onPlayerDeath', data)
	TriggerServerEvent('esx:onPlayerDeath', data)
end



function GetPlayerDetails(src, config, channel)
    local check = {"PlayerID", "SteamID", "SteamURL", "Postal", "DiscordID", "License", "License2", "IP", "PlayTime", "playerPing"}
    if not webhooksFile[channel].Hide then
        webhooksFile[channel].Hide = {}
        for k,v in pairs(check) do
            webhooksFile[channel].Hide[v] = false
        end
    else
        for k,v in pairs(check) do
            if not webhooksFile[channel].Hide[v] then
                webhooksFile[channel].Hide[v] = false
            end
        end
    end


    local ids = ExtractIdentifiers(src)
	if config['postals'] and not webhooksFile[channel].Hide['Postal'] then
        postal = getPlayerLocation(src)
        _postal = "\n**Nearest Postal:** ".. postal ..""
    else
        _postal = ""
    end

    if config['discordId'] and not webhooksFile[channel].Hide['DiscordID'] then
        if ids.discord then
            _discordID ="\n**Discord ID:** <@" ..ids.discord:gsub("discord:", "").."> ("..ids.discord:gsub("discord:", "")..")"
        else
            _discordID = "\n**Discord ID:** N/A"
        end
    else
        _discordID = ""
    end

    if GetConvar("steam_webApiKey", "false") ~= 'false' then
        if config['steamId'] and not webhooksFile[channel].Hide['SteamID'] then
            if ids.steam then
                _steamID ="\n**Steam ID:** " ..ids.steam..""
            else
                _steamID = "\n**Steam ID:** N/A"
            end
        else
            _steamID = ""
        end

        if config['steamUrl'] and not webhooksFile[channel].Hide['SteamURL'] then
            if ids.steam then
                _steamURL ="\nhttps://steamcommunity.com/profiles/" ..tonumber(ids.steam:gsub("steam:", ""),16)..""
            else
                _steamURL = "\n**Steam URL:** N/A"
            end
        else
            _steamURL = ""
        end
    else
        _steamID = ""
        _steamURL = ""
        TriggerEvent('Prefech:Cryptohooker:errorLog', 'You need to set a steam api key in your server.cfg for the steam identifiers to work!.')
    end

	if config['license'] and not webhooksFile[channel].Hide['License'] then
        if ids.license then
            _license ="\n**License:** " ..ids.license
        else
            _license = "\n**License:** N/A"
        end
    else
        _license = ""
    end

    if config['license2'] and not webhooksFile[channel].Hide['License2'] then
        if ids.license2 then
            _license2 ="\n**License 2:** " ..ids.license2
        else
            _license2 = "\n**License 2:** N/A"
        end
    else
        _license2 = ""
    end

	if config['ip'] and not webhooksFile[channel].Hide['IP'] then
        if ids.ip then
            _ip ="\n**IP:** " ..ids.ip:gsub("ip:", "")
        else
            _ip = "\n**IP:** N/A"
        end
    else
        _ip = ""
    end

    if config.Session or config.PlayTime and not webhooksFile[channel].Hide['PlayTime'] then
        if GetResourceState('Prefech_playTime') == "started" then
            playtime = exports.Prefech_playTime:getPlayTime(src)
            if config.Session and channel ~= 'joins' and playtime ~= nil then
                playTimeArgs = SecondsToClock(playtime.Session)
                _session = "\n**Session Time:** `"..string.format("%02d:%02d:%02d", playTimeArgs.hours, playTimeArgs.minutes, playTimeArgs.seconds)..'`'
            else
                _session = ""
            end
            if config.PlayTime and channel ~= 'joins' and playtime ~= nil then
                playTimeArgs = SecondsToClock(playtime.Total + playtime.Session)
                _total = "\n**Total Time:** `"..string.format("%d days and %02d:%02d:%02d", playTimeArgs.days, playTimeArgs.hours, playTimeArgs.minutes, playTimeArgs.seconds)..'`'
            else
                _total = ""
            end
        else
            TriggerEvent('Prefech:Cryptohooker:errorLog', 'Prefech_playTime is not installed.')
            _total = ""
            _session = ""
        end
    else
        _total = ""
        _session = ""
    end

	if config['playerId'] and not webhooksFile[channel].Hide['PlayerID'] then
        if channel ~= 'joins' then
            _playerID ="\n**Player ID:** " ..src..""
        else
            _playerID = "\n**Player ID:** N/A"
        end
    else
        _playerID = ""
    end

    if config['playerPing'] and not webhooksFile[channel].Hide['playerPing'] then
        _ping = "\n**Ping:** `"..GetPlayerPing(src)..'ms`'
    else
        _ping = ""
    end

    if config['playerHealth'] or config['playerArmor'] then
        _hp = "\n"
        local playerPed = GetPlayerPed(src)
        if config['playerHealth'] and not webhooksFile[channel].Hide['playerHealth'] then
            local maxHealth = math.floor(GetEntityMaxHealth(playerPed) / 2)
            local health = math.floor(GetEntityHealth(playerPed) / 2)
            _hp = _hp.."**Health:** ❤: `"..health.."/"..maxHealth.."`"
        end
        if config['playerArmor'] and not webhooksFile[channel].Hide['playerArmor'] then
            if config['playerHealth'] then
                _hp = _hp.." **|** "
            end
            local maxArmour = GetPlayerMaxArmour(src)
            local armour = GetPedArmour(playerPed)
            _hp = _hp.."**Armor:** 🛡: `"..armour.."/"..maxArmour.."`"
        end
    else
        _hp = ""
    end

    if config['useESX'] and channel ~= 'joins' and ESX ~= nil then
        xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer ~= nil then
            _esx = "\n\n**ESX:**"
            if config['esxName'] and not webhooksFile[channel].Hide['esxName'] then
                _esx = _esx.."\n**Charachter Name:** "..xPlayer.name
            end
            if config['esxJob'] and not webhooksFile[channel].Hide['esxJob'] then
                _esx = _esx.."\n**Job:** "..xPlayer.job.name.."\n**Job Grade:** "..xPlayer.job.grade
            end
            if config['esxMoney'] and not webhooksFile[channel].Hide['esxMoney'] then
                _cash = ESX.Math.GroupDigits(xPlayer.getAccount('money').money)
                _bank = ESX.Math.GroupDigits(xPlayer.getAccount('bank').money)
                _blmon = ESX.Math.GroupDigits(xPlayer.getAccount('black_money').money)
                _esx = _esx.."\n**Money:** $".._cash.."\n**Bank Balance:** $".._bank.."\n**Black Money:** $".._blmon
            end
        else
            _esx = ""
        end
    else
        _esx = ""
    end

    return _playerID.._postal.._hp.._discordID.._steamID.._steamURL.._license.._license2.._session.._total.._ip.._esx
end