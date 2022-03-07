ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('esx_clotheshop:buy')
AddEventHandler('esx_clotheshop:buy', function()

		local xPlayer = ESX.GetPlayerFromId(source)


		if xPlayer.getMoney() >= Config.Price then

				TriggerClientEvent('esx_clotheshop:confirm', source, true)
				xPlayer.removeMoney(Config.Price)

		else
				TriggerClientEvent('esx_clotheshop:confirm', source, false)
		end

end)

ESX.RegisterServerCallback('esx_clotheshop:checkHavePropertyStore', function(source, cb)

	local found = false
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		found = true
	end)

	cb(found)

end)

RegisterServerEvent('esx_clotheshop:saveOutfit')
AddEventHandler('esx_clotheshop:saveOutfit', function(label, skinRes)

	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)

		local dressing = store.get('dressing')

		if dressing == nil then
			dressing = {}
		end

		table.insert(dressing, {
			label = label,
			skin  = skinRes
		})

		store.set('dressing', dressing)

	end)

end)

ESX.RegisterServerCallback('esx_clotheshop:getPlayerOutfit', function(source, cb, num)

	local xPlayer  = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local outfit = store.get('dressing', num)
		cb(outfit.skin)
	end)

end)

RegisterServerEvent('esx_clotheshop:removeOutfit')
AddEventHandler('esx_clotheshop:removeOutfit', function(index)

		local xPlayer = ESX.GetPlayerFromId(source)

		TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)

				local dressing = store.get('dressing')

				if dressing == nil then
						dressing = {}
				end

				index = index
				
				table.remove(dressing, index)

				store.set('dressing', dressing)

		end)

end)

ESX.RegisterServerCallback('esx_clotheshop:getPlayerDressing', function(source, cb)

	local xPlayer  = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)

		local count    = store.count('dressing')
		local labels   = {}

		for i=1, count, 1 do
			local entry = store.get('dressing', i)
			table.insert(labels, entry.label)
		end

		cb(labels)

	end)

end)

RegisterServerEvent('skin:save')
AddEventHandler('skin:save', function(skin)

	local xPlayer = ESX.GetPlayerFromId(source)
	
--print(steamID)
	MySQL.Async.execute(
		'UPDATE users SET `skin` = @skin WHERE identifier = @identifier',
		{
			['@skin']       = json.encode(skin),
			['@identifier'] = xPlayer.identifier
		}
	)

end)


ESX.RegisterServerCallback('esx_clotheshop:getjobgrades', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.fetchAll('SELECT * FROM job_grades WHERE job_name = @job_name', {
		['@job_name'] = xPlayer.job.name
	}, function(result)
		cb(result)
	end)
end)




RegisterServerEvent('esx_clotheshop:setJobSkin')
AddEventHandler('esx_clotheshop:setJobSkin', function(sex, grade, skin, outfittype)
		local xPlayer = ESX.GetPlayerFromId(source)
		if sex == "male" then
			if outfittype == 1 then
				MySQL.Async.execute(
					'UPDATE job_grades SET skin_male1 = @skin_male WHERE job_name = @job_name AND label = @label',
					{
						['@skin_male']   = json.encode(skin),
						['@job_name'] = xPlayer.job.name,
						['@label']    = grade
					},
					function(rowsChanged)
				end)

			elseif outfittype == 2 then
				MySQL.Async.execute(
					'UPDATE job_grades SET skin_male2 = @skin_male WHERE job_name = @job_name AND label = @label',
					{
						['@skin_male']   = json.encode(skin),
						['@job_name'] = xPlayer.job.name,
						['@label']    = grade
					},
					function(rowsChanged)
				end)

			elseif outfittype == 3 then
				MySQL.Async.execute(
					'UPDATE job_grades SET skin_male3 = @skin_male WHERE job_name = @job_name AND label = @label',
					{
						['@skin_male']   = json.encode(skin),
						['@job_name'] = xPlayer.job.name,
						['@label']    = grade
					},
					function(rowsChanged)
				end)
			end
		else
			if outfittype == 1 then
				MySQL.Async.execute(
					'UPDATE job_grades SET skin_female1 = @skin_female WHERE job_name = @job_name AND label = @label',
					{
						['@skin_female']   = json.encode(skin),
						['@job_name'] = xPlayer.job.name,
						['@label']    = grade
					},
					function(rowsChanged)
				end)
			elseif outfittype == 2 then
				MySQL.Async.execute(
					'UPDATE job_grades SET skin_female2 = @skin_female WHERE job_name = @job_name AND label = @label',
					{
						['@skin_female']   = json.encode(skin),
						['@job_name'] = xPlayer.job.name,
						['@label']    = grade
					},
					function(rowsChanged)
				end)
			elseif outfittype == 3 then
					MySQL.Async.execute(
						'UPDATE job_grades SET skin_female3 = @skin_female WHERE job_name = @job_name AND label = @label',
						{
							['@skin_female']   = json.encode(skin),
							['@job_name'] = xPlayer.job.name,
							['@label']    = grade
						},
						function(rowsChanged)
					end)
			end
		end
end)
