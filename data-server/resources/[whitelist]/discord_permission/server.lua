--- Config ---
notWhitelisted = "Servername » Du bist nicht gewhitelisted. Bitte joine dafür auf unseren Discord Server » https://discord.gg/nWuSVADXCG" 
noDiscord = "Servername » Bitte öffne Discord bevor Du dich verbindest." 
noSteam = "Servername » Bitte öffne Steam bevor Du dich verbindest." 

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

function GetRoles(user)
	local discordId = nil
	for _, id in ipairs(GetPlayerIdentifiers(user)) do
		if string.match(id, "discord:") then
			discordId = string.gsub(id, "discord:", "")
			break
		end
	end

	if discordId then
		local endpoint = ("guilds/%s/members/%s"):format(Config.GuildId, discordId)
		local member = DiscordRequest("GET", endpoint, {})
		if member.code == 200 then
			local data = json.decode(member.data)
			local roles = data.roles
			return roles
		else
			return false
		end
	else
		return false
	end
end

function IsRolePresent(user)
	local discordId = nil
	for _, id in ipairs(GetPlayerIdentifiers(user)) do
		if string.match(id, "discord:") then
			discordId = string.gsub(id, "discord:", "")
			break
		end
	end

	if discordId then
		local endpoint = ("guilds/%s/members/%s"):format(Config.GuildId, discordId)
		local member = DiscordRequest("GET", endpoint, {})
		if member.code == 200 then
			local data = json.decode(member.data)
			local roles = data.roles
			for i=1, #roles do
				if roles[i] == Config.Roles["Whitelist"] then
					return true
				end
			end
			return false
		else
			return false
		end
	else
		return false
	end
end

Citizen.CreateThread(function()
	local guild = DiscordRequest("GET", "guilds/"..Config.GuildId, {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
		print("Permission system guild set to: "..data.name.." ("..data.id..")")
	else
		print("An error occured, please check your config and ensure everything is correct. Error: "..(guild.data or guild.code)) 
	end
end)

--- Code ---

AddEventHandler("playerConnecting", function(name, setCallback, deferrals)
    local src = source
    deferrals.defer()
    deferrals.update("Servername » Berechtigung werden geprüft")

    for k, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            identifierDiscord = v
        end
        if string.sub(v, 1, string.len("steam")) == "steam" then
            identifierSteam = v
        end

    end
	if identifierSteam then
    	if identifierDiscord then
    	    if IsRolePresent(src) then
    	        deferrals.done()
    	    else
    	        deferrals.done(notWhitelisted)
    	    end
    	else
    	    deferrals.done(noDiscord)
    	end
	else
		deferrals.done(noSteam)
	end
end)