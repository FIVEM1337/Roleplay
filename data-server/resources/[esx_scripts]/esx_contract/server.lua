ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Webhook = ''

RegisterServerEvent('esx_contract:changeVehicleOwner')
AddEventHandler('esx_contract:changeVehicleOwner', function(data)
	_source = data.sourceIDSeller
	target = data.targetIDSeller
	plate = data.plateNumberSeller
	model = data.modelSeller
	source_name = data.sourceNameSeller
	target_name = data.targetNameSeller
	vehicle_price = tonumber(data.vehicle_price)

	local xPlayer = ESX.GetPlayerFromId(_source)
	local tPlayer = ESX.GetPlayerFromId(target)
	local webhookData = {
		model = model,
		plate = plate,
		target_name = target_name,
		source_name = source_name,
		vehicle_price = vehicle_price
	}
	local result = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @identifier AND plate = @plate', {
		['@identifier'] = xPlayer.identifier,
		['@plate'] = plate
	})

	if Config.RemoveMoneyOnSign then
		local bankMoney = tPlayer.getAccount('bank').money

		if result[1] ~= nil  then
			if bankMoney >= vehicle_price then
				MySQL.Async.execute('UPDATE owned_vehicles SET owner = @target WHERE owner = @owner AND plate = @plate', {
					['@owner'] = xPlayer.identifier,
					['@target'] = tPlayer.identifier,
					['@plate'] = plate
				}, function (result2)
					if result2 ~= 0 then	
						tPlayer.removeAccountMoney('bank', vehicle_price)
						xPlayer.addAccountMoney('bank', vehicle_price)

						TriggerClientEvent('dopeNotify:Alert', _source, "", "Du hast das Fahrzeug erfolgreich verkauft <b>"..model.."</b> mit dem Kennzeichen <b>"..plate.."</b>", 5000, 'success')
						TriggerClientEvent('dopeNotify:Alert', target, "", "Du hast das Fahrzeug erfolgreich gekauft <b>"..model.."</b> mit dem Kennzeichen <b>"..plate.."</b>", 5000, 'success')

						if Webhook ~= '' then
							sellVehicleWebhook(webhookData)
						end
					end
				end)
			else
				TriggerClientEvent('dopeNotify:Alert', _source, "", target_name.." kann sichd as Fahrzeug nicht leisten", 5000, 'error')
				TriggerClientEvent('dopeNotify:Alert', target, "", "Du hast nicht Genug Geld um dir "..source_name.."'s Fahrzeug zu kaufen", 5000, 'error')


			end
		else
			TriggerClientEvent('dopeNotify:Alert', _source, "", "Das Fahrzeug mit dem Kennzeichen <b>"..plate.."</b> ist nicht dein eigentum", 5000, 'error')
			TriggerClientEvent('dopeNotify:Alert', target, "", source_name.." versucht, dir ein Fahrzeug zu verkaufen, das ihm nicht gehört", 5000, 'error')
		end
	else
		if result[1] ~= nil then
			MySQL.Async.execute('UPDATE owned_vehicles SET owner = @target WHERE owner = @owner AND plate = @plate', {
				['@owner'] = xPlayer.identifier,
				['@target'] = tPlayer.identifier,
				['@plate'] = plate
			}, function (result2)
				if result2 ~= 0 then
					TriggerClientEvent('dopeNotify:Alert', _source, "", "Du hast das Fahrzeug erfolgreich verkauft <b>"..model.."</b> mit dem Kennzeichen <b>"..plate.."</b>", 5000, 'success')
					TriggerClientEvent('dopeNotify:Alert', target, "", "Du hast das Fahrzeug erfolgreich gekauft <b>"..model.."</b> mit dem Kennzeichen <b>"..plate.."</b>", 5000, 'success')

					if Webhook ~= '' then
						sellVehicleWebhook(webhookData)
					end
				end
			end)
		else
			TriggerClientEvent('dopeNotify:Alert', _source, "", "Das Fahrzeug mit dem Kennzeichen <b>"..plate.."</b> ist nicht dein eigentum", 5000, 'error')
			TriggerClientEvent('dopeNotify:Alert', target, "", source_name.." versucht, dir ein Fahrzeug zu verkaufen, das ihm nicht gehört", 5000, 'error')
		end
	end
end)

ESX.RegisterServerCallback('esx_contract:GetTargetName', function(source, cb, targetid)
	local target = ESX.GetPlayerFromId(targetid)
	local targetname = target.getName()

	cb(targetname)
end)

RegisterServerEvent('esx_contract:SendVehicleInfo')
AddEventHandler('esx_contract:SendVehicleInfo', function(description, price)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerClientEvent('esx_contract:GetVehicleInfo', _source, xPlayer.getName(), os.date(Config.DateFormat), description, price, _source)
end)

RegisterServerEvent('esx_contract:SendContractToBuyer')
AddEventHandler('esx_contract:SendContractToBuyer', function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerClientEvent("esx_contract:OpenContractOnBuyer", data.targetID, data)
	TriggerClientEvent('esx_contract:startContractAnimation', data.targetID)

	if Config.RemoveContractAfterUse then
		xPlayer.removeInventoryItem('use_car_contract', 1)
	end
end)

ESX.RegisterUsableItem('use_car_contract', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerClientEvent('esx_contract:OpenContractInfo', _source)
	TriggerClientEvent('esx_contract:startContractAnimation', _source)
end)

-------------------------- SELL VEHICLE WEBHOOK

function sellVehicleWebhook(data)
	local information = {
		{
			["color"] = Config.sellVehicleWebhookColor,
			["author"] = {
				["icon_url"] = Config.IconURL,
				["name"] = Config.ServerName..' - Logs',
			},
			["title"] = 'VEHICLE SALE',
			["description"] = '**Vehicle: **'..data.model..'**\nPlate: **'..data.plate..'**\nBuyer name: **'..data.target_name..'**\nSeller name: **'..data.source_name..'**\nPrice: **'..data.vehicle_price..'€',

			["footer"] = {
				["text"] = os.date(Config.WebhookDateFormat),
			}
		}
	}
	PerformHttpRequest(Webhook, function(err, text, headers) end, 'POST', json.encode({username = Config.BotName, embeds = information}), {['Content-Type'] = 'application/json'})
end