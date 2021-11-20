-- ================================================================================================--
-- ==                                VARIABLES - DO NOT EDIT                                     ==--
-- ================================================================================================--
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
    local _source = source

	if amount == nil then
		TriggerClientEvent('dopeNotify:Alert', _source, "", _U("invalid_amount"), 5000, 'error')
		return
	end

    local xPlayer = ESX.GetPlayerFromId(_source)
    if amount <= 0 then
		TriggerClientEvent('dopeNotify:Alert', _source, "", _U("invalid_amount"), 5000, 'error')
    else
        if amount > xPlayer.getMoney() then
            amount = xPlayer.getMoney()
        end
        xPlayer.removeMoney(amount)
        xPlayer.addAccountMoney('bank', tonumber(amount))
    end
	TriggerClientEvent('dopeNotify:Alert', _source, "",amount .. _U("deposit"), 5000, 'success')
end)

RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local base = 0

	if amount == nil then
		TriggerClientEvent('dopeNotify:Alert', _source, "", _U("invalid_amount"), 5000, 'error')
		return
	end

    amount = tonumber(amount)
    base = xPlayer.getAccount('bank').money
    if amount <= 0 then
		TriggerClientEvent('dopeNotify:Alert', _source, "", _U("invalid_amount"), 5000, 'error')
    else
        if amount > base then
            amount = base
        end
        xPlayer.removeAccountMoney('bank', amount)
        xPlayer.addMoney(amount)
    end
	TriggerClientEvent('dopeNotify:Alert', _source, "",amount .. _U("withdraw"), 5000, 'success')
end)

RegisterServerEvent('bank:balance')
AddEventHandler('bank:balance', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    balance = xPlayer.getAccount('bank').money
    TriggerClientEvent('currentbalance1', _source, balance)

end)

RegisterServerEvent('bank:transfer')
AddEventHandler('bank:transfer', function(to, amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local zPlayer = ESX.GetPlayerFromId(to)
    local balance = 0

	if amount == nil then
		TriggerClientEvent('dopeNotify:Alert', _source, "", _U("invalid_amount"), 5000, 'error')
		return
	end

    if zPlayer ~= nil and GetPlayerEndpoint(to) ~= nil then
		balance = xPlayer.getAccount('bank').money
		zbalance = zPlayer.getAccount('bank').money
		if tonumber(_source) == tonumber("34342") then
			TriggerClientEvent('dopeNotify:Alert', _source, "", _U("nice_try"), 5000, 'error')
		else
		    if balance <= 0 or balance < tonumber(amount) or tonumber(amount) <= 0 then
				TriggerClientEvent('dopeNotify:Alert', _source, "", _U("invalid_amount"), 5000, 'error')
		    else
				xPlayer.removeAccountMoney('bank', tonumber(amount))
				zPlayer.addAccountMoney('bank', tonumber(amount))	
				TriggerClientEvent('dopeNotify:Alert', source, "",amount .. _U("transfered") .. to .. _U("transfered2"), 5000, 'success')
				TriggerClientEvent('dopeNotify:Alert', to, "", _U("recived") .. source .. " " .. amount .. _U("recived2"), 5000, 'info')
			end
		end
	else
		TriggerClientEvent('dopeNotify:Alert', source, "", _U("not_found"), 5000, 'error')
	end
end)
