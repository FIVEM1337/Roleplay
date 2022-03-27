ESX              = nil
local Vehicles   = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

CreateThread(function()
	local char = Config.PlateLetters
	char = char + Config.PlateNumbers
	if Config.PlateUseSpace then char = char + 1 end

	if char > 8 then
		print(('esx_vehicleshop: ^1WARNING^7 plate character count reached, %s/8 characters.'):format(char))
	end
	
end)

function RemoveOwnedVehicle(plate)
	MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	})
end

MySQL.ready(function()
	TriggerEvent('esx_vehicleshop:sendvehicledata')
end)




RegisterServerEvent('esx_vehicleshop:sendvehicledata')
AddEventHandler('esx_vehicleshop:sendvehicledata', function ()
	local vehicles = MySQL.Sync.fetchAll('SELECT * FROM vehicleshops')

	for i=1, #vehicles, 1 do
		local vehicle = vehicles[i]
		table.insert(Vehicles, vehicle)
	end

	TriggerClientEvent('esx_vehicleshop:sendVehicles', -1, Vehicles)
end)

RegisterServerEvent('esx_vehicleshop:setVehicleOwned')
AddEventHandler('esx_vehicleshop:setVehicleOwned', function (vehicleProps, CarType, Job)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, job, plate, vehicle, type) VALUES (@owner, @job, @plate, @vehicle, @type)',
		{
			['@owner']   = Job or xPlayer.identifier,
			['@job']   = Job or "private",
			['@plate']   = vehicleProps.plate,
			['@vehicle'] = json.encode(vehicleProps),
			['@type'] = CarType,
		}, function (rowsChanged)
		end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getVehicles', function (source, cb)
	cb(Vehicles)
end)

ESX.RegisterServerCallback('esx_vehicleshop:buyVehicle', function (source, cb, vehicleModel)
	local xPlayer     = ESX.GetPlayerFromId(source)
	local vehicleData = nil

	for i=1, #Vehicles, 1 do
		local vehicle = Vehicles[i]
		if Vehicles[i].model == vehicleModel then
			vehicleData = Vehicles[i]
			break
		end
	end


	if vehicleData.donator then
		local crypto = xPlayer.getAccount('crypto').money
		if crypto >= vehicleData.price then
			xPlayer.removeAccountMoney('crypto', tonumber(vehicleData.price))
			cb(true, vehicleData.type, nil, true)
		else
			cb(false, vehicleData.type, nil, true)
		end
	else
		if vehicleData.job ~= "" then
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..vehicleData.job, function(account)
				if account.money >= vehicleData.price then
					account.removeMoney(vehicleData.price)
					cb(true, vehicleData.type, vehicleData.job)
				else
					cb(false, vehicleData.type, nil, false)
				end
			end)
		else
			local bankMoney = xPlayer.getAccount('bank').money

			if xPlayer.getMoney() >= vehicleData.price then
				xPlayer.removeMoney(vehicleData.price)
				TriggerEvent('CryptoHooker:SendBuyLog', source, vehicleData.name, 1, vehicleData.price)
				cb(true, vehicleData.type, nil, false)
			else if bankMoney >= vehicleData.price then
				xPlayer.setAccountMoney('bank',bankMoney-vehicleData.price)
				TriggerEvent('CryptoHooker:SendBuyLog', source, vehicleData.name, 1, vehicleData.price)
				cb(true, vehicleData.type, nil, false)
			else
				cb(false, vehicleData.type, nil, false)
			end
		end
	end

end
end)


ESX.RegisterServerCallback('esx_vehicleshop:resellVehicle', function (source, cb, plate, model, sellable)
	local resellPrice = 0

	if not sellable then
		cb(nil, false)
		return
	end

	-- calculate the resell price
	for i=1, #Vehicles, 1 do
		if GetHashKey(Vehicles[i].model) == model then
			resellPrice = ESX.Math.Round(Vehicles[i].price / 100 * Config.ResellPercentage)
			break
		end
	end

	if resellPrice == 0 then
		TriggerClientEvent('dopeNotify:Alert', source, _U('vehicleshop'), "Das Auto gehört nicht dir!", 5000, 'error')
		cb(false)
	end

	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = plate
	}, function (result)
		if result[1] then -- does the owner match?

			local vehicle = json.decode(result[1].vehicle)
			if vehicle.model == model then
				if vehicle.plate == plate then
					xPlayer.addMoney(resellPrice)
					RemoveOwnedVehicle(plate)

					cb(true)
				else
					cb(false)
				end
			else
				cb(false)
			end

		else
			print("wls")
		end

	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getPlayerInventory', function (source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({ items = items })
end)

ESX.RegisterServerCallback('esx_vehicleshop:isPlateTaken', function (source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function (result)
		if result[1] then
			cb(true)
		else
			MySQL.Async.fetchAll('SELECT * FROM job_vehicles WHERE plate = @plate', {
				['@plate'] = plate
			}, function (result)
				if result[1] then
					cb(true)
				else
					cb(false)
				end
			end)
		end
	end)
end)
