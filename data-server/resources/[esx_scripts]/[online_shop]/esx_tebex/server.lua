local ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)


function add_crypto(_, arg)
	local id = arg[1]
	local amount = arg[2]
	local xPlayer = ESX.GetPlayerFromId(id)

	if xPlayer then
		xPlayer.addAccountMoney('crypto', tonumber(amount))
	end
end

RegisterCommand("add_crypto", add_crypto, true)