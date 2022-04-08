ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback('esx_vehiclelock:requestPlayerCars', function(source, cb, plate)
	local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(vehicles)
		if vehicles[1] then
			local vehicle = vehicles[1]
			if vehicle.owner == xPlayer.identifier then
				cb(true)
			elseif vehicle.job == xPlayer.job.name then
				if vehicle.grade >= 0 then
					if vehicle.grade <= xPlayer.job.grade then
						cb(true)
					else
						cb(false)
					end
				elseif xPlayer.job.can_managecars then
					cb(true)
				else
					cb(false)
				end
			else
				cb(false)
			end
		end
	end)
end)


RegisterServerEvent('esx_vehicle:blink')
AddEventHandler('esx_vehicle:blink', function(vehicle)
	for k, v in ipairs(GetPlayers()) do
		TriggerClientEvent('esx_vehicle:blinkvehicle', vehicle)
	end
end)
