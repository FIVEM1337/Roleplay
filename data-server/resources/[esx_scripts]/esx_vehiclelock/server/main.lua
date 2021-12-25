ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_vehiclelock:requestPlayerCars', function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE owner = @owner AND plate = @plate', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = plate
	}, function(result)
		if result[1] == nil then
			MySQL.Async.fetchAll('SELECT 1 FROM job_vehicles WHERE job = @job AND plate = @plate', {
				['@job'] = xPlayer.job.name,
				['@plate'] = plate
			}, function(result)
				cb(result[1] ~= nil)
			end)
		else
			cb(result[1] ~= nil)
		end
	end)
end)
