local ESX = nil

local time = os.date("*t")
local date = ("%02d.%02d.%02d %02d:%02d:%02d"):format(time.day, time.month, time.year, time.hour + 1, time.min, time.sec)
local p="(%d+).(%d+).(%d+) (%d+):(%d+):(%d+)"
day,month,year,hour,min,sec=date:match(p)
local nowtimestamp = os.time({year = year, month = month, day = day, hour = hour, min = min, sec = sec})

-- ESX
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Open Visum card
RegisterServerEvent('esx_visum:open')
AddEventHandler('esx_visum:open', function(ID, targetID)
	local identifier = ESX.GetPlayerFromId(ID).identifier
	local _source 	 = ESX.GetPlayerFromId(targetID).source

	MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, height, state, visum FROM users WHERE identifier = @identifier', {['@identifier'] = identifier},
	function (user)
		if (user[1] ~= nil) then
			if (string.len(user[1].visum) >= 1) then
				local array = {
					user = user
				}

				TriggerClientEvent('esx_visum:open', _source, array)
			else
				TriggerClientEvent('esx:showNotification', _source, "Du hast keinen Visum..")
			end
		end
	end)
end)


RegisterCommand("buy", function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, height, state, visum FROM users WHERE identifier = @identifier', {['@identifier'] = xPlayer.identifier},
	function (user)
		if (user[1] ~= nil) then
			if (string.len(user[1].visum) >= 1) then
				BuyVisum(xPlayer, user[1].visum)
			else
				BuyVisum(xPlayer, nil)
			end
		end
	end)
end)

function BuyVisum(xPlayer, currentvisum)
	if currentvisum then
		day,month,year,hour,min,sec=currentvisum:match(p)
		local visumtimestamp = os.time({year = year, month = month, day = day, hour = hour, min = min, sec = sec})
		check = visumtimestamp - nowtimestamp
		if check >= 0 then
			TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "Visum", "Du hast noch ein aktives Visum!", 5000, 'error')
			return
		end
	end

	if xPlayer.getMoney() >= Config.Cost then
		xPlayer.removeMoney(Config.Cost)
		visum_date = ("%02d.%02d.%02d %02d:%02d:%02d"):format(time.day, time.month, time.year, time.hour + 3, time.min, time.sec)
		MySQL.Async.execute(
			'UPDATE users SET `visum` = @visum WHERE identifier = @identifier',
			{
			  ['@visum']       = visum_date,
			  ['@identifier'] = xPlayer.identifier
			}
		)
		TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "Visum", "Du hast nun ein neues Visum!", 5000, 'success')
	else
		TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "Visum", "Nicht genügend Geld!", 5000, 'error')
	end
end