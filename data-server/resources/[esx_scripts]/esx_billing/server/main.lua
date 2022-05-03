RegisterServerEvent('esx_billing:sendBill')
AddEventHandler('esx_billing:sendBill', function(playerId, sharedAccountName, label, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(playerId)
	amount = ESX.Math.Round(amount)

	if amount > 0 and xTarget then
		TriggerEvent('esx_addonaccount:getSharedAccount', sharedAccountName, function(account)
			if account then
				MySQL.insert('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (?, ?, ?, ?, ?, ?)', {xTarget.identifier, xPlayer.identifier, 'society', sharedAccountName, label, amount},
				function(rowsChanged)
					TriggerClientEvent('dopeNotify:Alert', xTarget.source, "", _U('received_invoice'), 5000, 'info')
				end)
			else
				MySQL.insert('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (?, ?, ?, ?, ?, ?)', {xTarget.identifier, xPlayer.identifier, 'player', xPlayer.identifier, label, amount},
				function(rowsChanged)
					TriggerClientEvent('dopeNotify:Alert', xTarget.source, "", _U('received_invoice'), 5000, 'info')
				end)
			end
		end)
	end
end)

ESX.RegisterServerCallback('esx_billing:getBills', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.query('SELECT amount, id, label FROM billing WHERE identifier = ?', {xPlayer.identifier},
	function(result)
		cb(result)
	end)
end)

ESX.RegisterServerCallback('esx_billing:getTargetBills', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	if xPlayer then
		MySQL.query('SELECT amount, id, label FROM billing WHERE identifier = ?', {xPlayer.identifier},
		function(result)
			cb(result)
		end)
	else
		cb({})
	end
end)

ESX.RegisterServerCallback('esx_billing:payBill', function(source, cb, billId)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.single('SELECT sender, target_type, target, amount FROM billing WHERE id = ?', {billId},
	function(result)
		if result then
			local amount = result.amount
			local xTarget = ESX.GetPlayerFromIdentifier(result.sender)

			if result.target_type == 'player' then
				if xTarget then
					if xPlayer.getMoney() >= amount then
						MySQL.update('DELETE FROM billing WHERE id = ?', {billId},
						function(rowsChanged)
							if rowsChanged == 1 then
								xPlayer.removeMoney(amount)
								xTarget.addMoney(amount)

								TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", _U('paid_invoice', ESX.Math.GroupDigits(amount)), 5000, 'succes')
								TriggerClientEvent('dopeNotify:Alert', xTarget.source, "", _U('received_payment', ESX.Math.GroupDigits(amount)), 5000, 'info')
							end

							cb()
						end)
					elseif xPlayer.getAccount('bank').money >= amount then
						MySQL.update('DELETE FROM billing WHERE id = ?', {billId},
						function(rowsChanged)
							if rowsChanged == 1 then
								xPlayer.removeAccountMoney('bank', amount)
								xTarget.addAccountMoney('bank', amount)

								TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", _U('paid_invoice', ESX.Math.GroupDigits(amount)), 5000, 'succes')
								TriggerClientEvent('dopeNotify:Alert', xTarget.source, "", _U('received_payment', ESX.Math.GroupDigits(amount)), 5000, 'info')
							end

							cb()
						end)
					else
						TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", _U('no_money'), 5000, 'error')
						TriggerClientEvent('dopeNotify:Alert', xTarget.source, "", _U('target_no_money'), 5000, 'error')
						cb()
					end
				else
					TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", _U('player_not_online'), 5000, 'error')
					cb()
				end
			else
				TriggerEvent('esx_addonaccount:getSharedAccount', result.target, function(account)
					if xPlayer.getMoney() >= amount then
						MySQL.update('DELETE FROM billing WHERE id = ?', {billId},
						function(rowsChanged)
							if rowsChanged == 1 then
								xPlayer.removeMoney(amount)
								account.addMoney(amount)
								TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", _U('paid_invoice', ESX.Math.GroupDigits(amount)), 5000, 'succes')
								if xTarget then
									TriggerClientEvent('dopeNotify:Alert', xTarget.source, "", _U('received_payment', ESX.Math.GroupDigits(amount)), 5000, 'succes')
								end
							end

							cb()
						end)
					elseif xPlayer.getAccount('bank').money >= amount then
						MySQL.update('DELETE FROM billing WHERE id = ?', {billId},
						function(rowsChanged)
							if rowsChanged == 1 then
								xPlayer.removeAccountMoney('bank', amount)
								account.addMoney(amount)
								TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", _U('paid_invoice', ESX.Math.GroupDigits(amount)), 5000, 'succes')

								if xTarget then
									TriggerClientEvent('dopeNotify:Alert', xTarget.source, "", _U('received_payment', ESX.Math.GroupDigits(amount)), 5000, 'succes')
								end
							end

							cb()
						end)
					else
						if xTarget then
							TriggerClientEvent('dopeNotify:Alert', xTarget.source, "", _U('target_no_money'), 5000, 'error')
						end

						TriggerClientEvent('dopeNotify:Alert', xPlayer.source, "", _U('no_money'), 5000, 'error')
						cb()
					end
				end)
			end
		end
	end)
end)
