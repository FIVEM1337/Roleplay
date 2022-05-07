local FormattedToken = "Bot "..Config.DiscordToken

function DiscordRequest(method, endpoint, jsondata)
    local data = nil
    PerformHttpRequest("https://discordapp.com/api/"..endpoint, function(errorCode, resultData, resultHeaders)
		data = {data=resultData, code=errorCode, headers=resultHeaders}
    end, method, #jsondata > 0 and json.encode(jsondata) or "", {["Content-Type"] = "application/json", ["Authorization"] = FormattedToken})

    while data == nil do
        Citizen.Wait(0)
    end
	
    return data
end

AddEventHandler("playerConnecting", function(name, setCallback, deferrals)
	local source = source
	local identifier, steamId, discordId, ip, xbl, liveid

    deferrals.defer()
    deferrals.update("Heaven V » Prüft, ob Wartungsarbeiten aktiv sind.")

	if Config.maintanance then
		deferrals.done("\n\n\nHeaven V befindet sich aktuell in den Wartungsarbeiten!\n\nSchaue auf unser Discord Server vorbei für weitere Informationen.\nDiscord: https://discord.gg/27nKFqKsN5\n\n")
		return
	end

	for k,v in pairs(GetPlayerIdentifiers(source)) do
		if string.match(v, "license:") then
			identifier = string.gsub(v, "license:", "")
		elseif string.match(v, "steam:") then
			steamId = string.gsub(v, "steam:", "")
		elseif string.match(v, "discord:") then
			discordId = string.gsub(v, "discord:", "")
		elseif string.match(v, "ip:") then
			ip = string.gsub(v, "ip:", "")
		elseif string.match(v, "xbl:") then
			xbl = string.gsub(v, "xbl:", "")
		elseif string.match(v, "live:") then
			liveid = string.gsub(v, "live:", "")
		end
	end

	deferrals.update("Heaven V » Prüft, ob Steam und Dicord verbunden sind.")
	if not discordId and not steamId then
		deferrals.done("\n\n\nEs wurde kein Steam und Discord Account erkannt. \n\nBei Problemen oder Fragen wird dir auf unserem Discord Server geholfen.\nDiscord: https://discord.gg/27nKFqKsN5\n\n")
	elseif not discordId then
		deferrals.done("\n\n\nEs wurde kein Discord Account erkannt. \n\nBei Problemen oder Fragen wird dir auf unserem Discord Server geholfen.\nDiscord: https://discord.gg/27nKFqKsN5\n\n")
	elseif not steamId then
		deferrals.done("\n\n\nEs wurde kein Steam Account erkannt. \n\nBei Problemen oder Fragen wird dir auf unserem Discord Server geholfen.\nDiscord: https://discord.gg/27nKFqKsN5\n\n")
	end


	deferrals.update("Heaven V » Prüft, ob dein Account gesperrt ist.")
	banned = CheckBanned(source, identifier, steamId, discordId, ip)

	while banned == nil do
		Wait(0)
	end

	if banned then
		local banned_date = tostring(banned.date)
		local end_date = tostring(banned.end_date)
		deferrals.done("\n\n\nDein Account ist gesperrt!\n\nID: "..banned.id.."\nGrund: "..banned.reason.."\nWann: "..os.date("%H:%M:%S %d.%m.%Y",banned_date:sub(1, -6)).."\nBis: "..os.date("%H:%M:%S %d.%m.%Y",end_date:sub(1, -6)).."\n\nDu kannst in unserem Discord Server ein Entbannungsantrag stellen \nDiscord: https://discord.gg/27nKFqKsN5 \n\n")
		return
	end

	deferrals.update("Heaven V » Prüft, ob Änderungen an deinem Steam oder Discord Account vorhanden sind.")
	local discord_roles = GetRoles(source, discordId)
	status = CheckUser(source, identifier, steamId, discordId, ip)

	
	while status == nil do
		Wait(0)
	end

	if status then
		if status == 1 then
			deferrals.done("\n\n\nDein Discord-Account und Steam-Account hat sich verändert! \nVerwende den richtigen Discord-Account und Steam-Account oder kontaktiere uns über ein Discord Support Ticket.\n\n")
		elseif status == 2 then
			deferrals.done("\n\n\nDein Discord-Account hat sich verändert! \nVerwende den richtigen Discord-Account oder kontaktiere uns über ein Discord Support Ticket.\n\n")
		elseif status == 3 then
			deferrals.done("\n\n\nDein Steam-Account hat sich verändert! \nVerwende den richtigen Steam-Account oder kontaktiere uns über ein Discord Support Ticket.\n\n")
		else
			deferrals.update("Heaven V » Prüft, ob du berechtigt bist, dich mit dem Server zu verbinden.")
			local whitelisted
			for k, v in pairs(Config.user) do
				if not whitelisted then
					for i, x in pairs(discord_roles) do
						if v.role_id == x then
							whitelisted = v.name
							break
						end
					end
				end
			end

			if not whitelisted then
				for k, v in pairs(Config.perms) do
					if not whitelisted then
						for i, x in pairs(discord_roles) do
							if v.role_id == x then
								whitelisted = v.name
								break
							end
						end
					end
				end
			end
			if whitelisted then
				if status ~= 99 then
					SetGroup(source, identifier, steamId, discordId, ip)
				end
				deferrals.done()
			else
				deferrals.done("\n\n\nDu bist noch nicht berechtigt, um auf Heaven V spielen zu können!\n Komm auf unserem Discord Server, um dich zu verifizieren.\n\n Discord: https://discord.gg/27nKFqKsN5\n\n")
			end
		end
	end
end)

function SetGroup(source, identifier, steamId, discordId, ip)
	local discord_roles = GetRoles(source, discordId)
	local perms

	for k, v in pairs(Config.perms) do
		if not perms then
			for i, x in pairs(discord_roles) do
				if v.role_id == x then
					perms = v.group
					break
				end
			end
		end
	end

	MySQL.Async.execute('UPDATE users SET `group` = @group WHERE identifier = @identifier',
	{['@identifier'] = identifier,['@group'] = perms or "user"},
	function(rowsChanged)

	end)
end

function CheckBanned(source, identifier, steamId, discordId, ip)
	local banned = nil
	MySQL.Async.fetchAll('SELECT * FROM bans WHERE identifier = @identifier or steam = @steam or discord = @discord', {
        ['@identifier'] = identifier,
		['@steam'] = steamId,
		['@discord'] = discordId,
    }, function(result)
        if result then

			for k,v in pairs(result) do
				if not banned then
					local end_date = tostring(v.end_date)
					if tonumber(end_date:sub(1, -6)) >= os.time() then
						banned = v
					end
				end
			end
			if not banned then
				banned = false
			end
		else
			banned = false
		end
    end)

	while banned == nil do
		Wait(0)
	end
	return banned
end

function CheckUser(source, identifier, steamId, discordId, ip)
	local user
	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(result)
        if result[1] then
			user = result[1]

			if (not user.steam or user.steam == "" or string.match(tostring(user.steam),"[^%w]")) and (not user.discord or user.discord == "" or string.match(tostring(user.discord),"[^%w]")) then
				MySQL.Async.execute('UPDATE users SET steam = @steam, discord = @discord WHERE identifier = @identifier',
					{['@identifier'] = identifier,['@steam'] = steamId,['@discord'] = discordId},
					function(rowsChanged)
						user.steam = steamId
						user.discord = discordId
						return CkeckIfChanges(source, user, identifier, steamId, discordId, ip)
				end)
			elseif not user.steam or user.steam == "" or string.match(tostring(user.steam),"[^%w]") then
				MySQL.Async.execute('UPDATE users SET steam = @steam WHERE identifier = @identifier',
					{['@identifier'] = identifier,['@steam'] = steamId},
					function(rowsChanged)
						user.steam = steamId
						return CkeckIfChanges(source, user, identifier, steamId, discordId, ip)
				end)
			elseif not user.discord or user.discord == "" or string.match(tostring(user.discord),"[^%w]") then
				MySQL.Async.execute('UPDATE users SET discord = @discord WHERE identifier = @identifier',
					{['@identifier'] = identifier,['@discord'] = discordId},
					function(rowsChanged)
						user.discord = discordId
						return CkeckIfChanges(source, user, identifier, steamId, discordId, ip)
				end)
			else
				return CkeckIfChanges(source, user, identifier, steamId, discordId, ip)
			end
		else
			status = 99 
			return status
		end
    end)
end

function CkeckIfChanges(source, user, identifier, steamId, discordId, ip)
	status = 0
	if user.discord ~= discordId and user.steam ~= steamId then
		status = 1
		return status
	elseif user.discord ~= discordId then
		status = 2
		return status
	elseif user.steam ~= steamId then
		status = 3
		return status
	else
		return status
	end
end

function GetRoles(source, discordId)
	local member = DiscordRequest("GET", ("guilds/%s/members/%s"):format(Config.GuildId, discordId), {})
	if member.code == 200 then
		local data = json.decode(member.data)
		return data.roles
	end
end
