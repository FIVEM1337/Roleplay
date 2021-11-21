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


RegisterServerEvent('CryptoHooker:SendBuyLog')
AddEventHandler('CryptoHooker:SendBuyLog', function(source, item, count, price)
	local Webhook = Config.Webhooks["buy-log"]
	local xPlayer = ESX.GetPlayerFromId(source)

    local embed = {
        {
            ["title"] = Webhook.Title,
			["color"] = Webhook.Color,
			["description"] = xPlayer.getName() .. " " .. "kauft " .. count .. "x " .. item.label,
			["fields"] = {
				{
					["name"] = "Itemname:",
					["value"] = item.label,
					["inline"] = true
				},
				{
					["name"] = "Amount:",
					["value"] = count,
					["inline"] = true
				},
				{
					["name"] = "Price:",
					["value"] = price,
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


RegisterServerEvent('CryptoHooker:SendDropLog')
AddEventHandler('CryptoHooker:SendDropLog', function(source, item, count, coords)
	local Webhook = Config.Webhooks["drop-log"]
	local xPlayer = ESX.GetPlayerFromId(source)

    local embed = {
        {
            ["title"] = Webhook.Title,
			["color"] = Webhook.Color,
			["description"] = xPlayer.getName() .. " has dropped " .. count .. "x " .. item.label,
			["fields"] = {
				{
					["name"] = "Item Name:",
					["value"] = item.label,
					["inline"] = true
				},
				{
					["name"] = "Anzahl:",
					["value"] = count,
					["inline"] = true
				},
				{
					["name"] = "coords:",
					["value"] = tostring(coords),
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

RegisterServerEvent('CryptoHooker:SendMoveLog')
AddEventHandler('CryptoHooker:SendMoveLog', function(source, item, count, from, to)
	local Webhook = Config.Webhooks["move-log"]
	local xPlayer = ESX.GetPlayerFromId(source)

    local embed = {
        {
            ["title"] = Webhook.Title,
			["color"] = Webhook.Color,
			["description"] = count.."x ".. item.label .. " von " .. from.. " zu ".. to .. " bewegt ",
			["fields"] = {
				{
					["name"] = "Item Name:",
					["value"] = item.label,
					["inline"] = true
				},
				{
					["name"] = "Anzahl:",
					["value"] = count,
					["inline"] = true
				},
				{
					["name"] = "From:",
					["value"] = from,
					["inline"] = true
				},
				{
					["name"] = "To:",
					["value"] = to,
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


RegisterServerEvent('CryptoHooker:SendUseLog')
AddEventHandler('CryptoHooker:SendUseLog', function(source, item, count)
	local Webhook = Config.Webhooks["use-log"]
	local xPlayer = ESX.GetPlayerFromId(source)

    local embed = {
        {
            ["title"] = Webhook.Title,
			["color"] = Webhook.Color,
			["description"] = xPlayer.getName() .. " benutzt " .. count.."x " .. item,
			["fields"] = {
				{
					["name"] = "Item Name:",
					["value"] = item,
					["inline"] = true
				},
				{
					["name"] = "Anzahl:",
					["value"] = count,
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
