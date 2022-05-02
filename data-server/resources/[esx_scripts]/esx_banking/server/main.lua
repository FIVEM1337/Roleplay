ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_banking:server:GetBankData', function(source, cb)
	local _char = ESX.GetPlayerFromId(source)
	local _charname = _char.getName()

	MySQL.Async.fetchAll('SELECT * FROM phone_banking WHERE identifier = @identifier', {
		['@identifier'] = _char.identifier
	}, function(result)
		if result[1] ~= nil then

			local num1, num2, num3, num4
			
			for num in result[1].cardnumber:gmatch('%d%d%d%d') do
				if not num1 then
					num1 = num
				elseif not num2 then
					num2 = num
				elseif not num3 then
					num3 = num
				elseif not num4 then
					num4 = num
				end
			end
			cb(_charname, num1, num2, num3, num4)
		else
			cb(_charname, nil)
		end
	end)
end)


RegisterServerEvent('esx_banking:server:depositvb')
AddEventHandler('esx_banking:server:depositvb', function(amount, inMenu)
	local _src = source
	local _char = ESX.GetPlayerFromId(_src)
	amount = tonumber(amount)
	Citizen.Wait(50)
	if amount == nil or amount <= 0 or amount > _char.getMoney() then
		TriggerClientEvent('dopeNotify:Alert', _src, "", "Ungültige Menge", 5000, 'error')
	else
		_char.removeMoney(amount)
		_char.addAccountMoney('bank', tonumber(amount))
		TriggerClientEvent('dopeNotify:Alert', _src, "", "Du hast $"..amount.." eingezahlt", 5000, 'info')
	end
end)

RegisterServerEvent('esx_banking:server:withdrawvb')
AddEventHandler('esx_banking:server:withdrawvb', function(amount, inMenu)
	local _src = source
	local _char = ESX.GetPlayerFromId(_src)
	local _base = 0
	amount = tonumber(amount)
	_base = _char.getAccount('bank').money
	Citizen.Wait(100)
	if amount == nil or amount <= 0 or amount > _base then
		TriggerClientEvent('dopeNotify:Alert', _src, "", "Ungültige Menge", 5000, 'error')
	else
		_char.removeAccountMoney('bank', amount)
		_char.addMoney(amount)
		TriggerClientEvent('dopeNotify:Alert', _src, "", "Du hast $"..amount.." abgehoben", 5000, 'info')
	end
end)

RegisterServerEvent('esx_banking:server:balance')
AddEventHandler('esx_banking:server:balance', function(inMenu)
	local _src = source
	local _char = ESX.GetPlayerFromId(_src)
	local balance = _char.getAccount('bank').money
	TriggerClientEvent('esx_banking:client:refreshbalance', _src, ESX.Math.GroupDigits(balance))
end)

RegisterServerEvent('esx_banking:server:transfervb')
AddEventHandler('esx_banking:server:transfervb', function(cardnumber, amountt, inMenu)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local zPlayer
	local balance = 0

	MySQL.Async.fetchAll('SELECT * FROM phone_banking WHERE cardnumber = @cardnumber', {
		['@cardnumber'] = cardnumber
	}, function(result)
		if result[1] ~= nil then
			balance = xPlayer.getAccount('bank').money
			zPlayer = ESX.GetPlayerFromIdentifier(result[1].identifier)

			if zPlayer then
				if xPlayer.source == zPlayer.source then
					TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", "Du kannst dir selbst kein Geld überweisen.", 5000, 'error')
					return
				end
				if balance <= 0 or balance < tonumber(amountt) or tonumber(amountt) <= 0 then
					TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", "Du hast nicht genug Geld auf deinem Bankkonto.", 5000, 'error')
				else
					xPlayer.removeAccountMoney('bank', tonumber(amountt))
					zPlayer.addAccountMoney('bank', tonumber(amountt))
					TriggerClientEvent('dopeNotify:Alert', zPlayer.source, "", "Du hast eine Überweisung von $"..amountt.." erhalten", 5000, 'info')
					TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", "Du hast $"..amountt.." überwiesen", 5000, 'info')
				end
			else
				TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", "Der Empfänger ist derzeit nicht verfügbar.", 5000, 'error')
			end
		else
			TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", "Diese Konto Nr ist ungültig oder existiert nicht.", 5000, 'error')
		end
	end)
end)
