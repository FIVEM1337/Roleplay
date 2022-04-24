function StartPayCheck()
	CreateThread(function()
		while true do
			Wait(Config.PaycheckInterval)
			local xPlayers = ESX.GetExtendedPlayers()
			for _, xPlayer in pairs(xPlayers) do
				local job     = xPlayer.job.grade_name
				local salary  = xPlayer.job.grade_salary
				if salary > 0 then
					if Config.EnableSocietyPayouts then -- possibly a society
						TriggerEvent('esx_society:getSociety', xPlayer.job.name, function (society)
							if society ~= nil then -- verified society
								TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function (account)
									if account.money >= salary then -- does the society money to pay its employees?
										xPlayer.addAccountMoney('bank', salary)
										account.removeMoney(salary)
										TriggerClientEvent('dopeNotify:Alert', xPlayer.source, _U('bank'), _U('received_salary', salary), 5000, 'info')
									else
										TriggerClientEvent('dopeNotify:Alert', xPlayer.source, _U('bank'), _U('company_nomoney', salary), 5000, 'info')
									end
								end)
							else -- not a society
								xPlayer.addAccountMoney('bank', salary)
								TriggerClientEvent('dopeNotify:Alert', xPlayer.source, _U('bank'), _U('received_salary', salary), 5000, 'info')
							end
						end)
					else -- generic job
						xPlayer.addAccountMoney('bank', salary)
						TriggerClientEvent('dopeNotify:Alert', xPlayer.source, _U('bank'), _U('received_salary', salary), 5000, 'info')
					end
				else
					xPlayer.addAccountMoney('bank', Config.NoJobCash)
					TriggerClientEvent('dopeNotify:Alert', xPlayer.source, _U('bank'), _U('received_help', Config.NoJobCash), 5000, 'info')
				end
			end
		end
	end)
end
