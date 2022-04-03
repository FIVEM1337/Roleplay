RegisterServerEvent('esx_fuelstation:pay')
AddEventHandler('esx_fuelstation:pay', function(price)
	local xPlayer = ESX.GetPlayerFromId(source)
	local amount = ESX.Math.Round(price)

	if price > 0 then
		xPlayer.removeMoney(amount)
	end
end)