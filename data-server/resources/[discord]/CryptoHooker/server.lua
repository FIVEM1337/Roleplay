local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('chatMessage', function(source, name, message)
	TriggerEvent('CryptoHooker:SendChatLog', source, name, message)
end)

RegisterServerEvent('CryptoHooker:SendChatLog')
AddEventHandler('CryptoHooker:SendChatLog', function(source, name, message)
	local Webhook = Config.Webhooks["chat-log"]
	local xPlayer = ESX.GetPlayerFromId(source)

    local embed = {
        {
            ["title"] = Webhook.Title,
            ["description"] = message,
			["color"] = Webhook.Color,
			["fields"] = {
				{
					["name"] = "User Name:",
					["value"] = name,
					["inline"] = true
				},
				{
					["name"] = "User ID:",
					["value"] = source,
					["inline"] = true
				},
				{
					["name"] = "Character Name",
					["value"] = xPlayer.getName(),
				}
			},
            ["footer"] = {
                ["text"] = "Indentifer: " .. xPlayer.identifier,
            }
        }
    }
	PerformHttpRequest(Webhook.URl, function(err, text, headers) end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json' })
end)
