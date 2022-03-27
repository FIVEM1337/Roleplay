local Playertasks               = {}

function Start(source, label)
	routetable = getroutetable(label)
	SetTimeout(routetable.time * 1000, function()
		if not Playertasks[source] then
			return
		end

		if not Playertasks[source].label then
			return
		end

		CraftFinish(source, Playertasks[source].label)
	
	end)
end

ESX.RegisterServerCallback('esx_routen:done', function(source, cb)
	if Playertasks[source] then
		if Playertasks[source].label then
			cb(true)
		else
			cb(false)
		end
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_routen:getitemlabel', function(source, cb, item)
	cb(ESX.GetItemLabel(item))
end)

RegisterServerEvent('esx_routen:startRoute')
AddEventHandler('esx_routen:startRoute', function(label)
	_source = source
	if not Playertasks[source] then
		Playertasks[source] = {}
	end 

	if not Playertasks[source].label then
		Playertasks[source].label = label

		local hasInventoryItem = hasInventoryItemFunc(_source, label)
		local hasInventorySpace = hasInventorySpaceFunc(_source, label)

		while true do
			Wait(1)
			if hasInventoryItem ~= nil and hasInventorySpace ~= nil then
				if hasInventoryItem and hasInventorySpace then
					TriggerClientEvent('esx_routen:changestatus', _source, true)
					TriggerClientEvent('dopeNotify:Alert', _source, "", "Du hast die Interaktion gestartet", 2000, 'info')
					Start(_source, label)
					break
				else
					break
				end
			end
		end
	end
end)

RegisterServerEvent('esx_routen:stopRoute')
AddEventHandler('esx_routen:stopRoute', function()
	Stop(source)
end)


function CraftFinish(source, label)
	local xPlayer = ESX.GetPlayerFromId(source)
	local dosomethingtable = getdosomethingtable(label)

	local hasInventoryItem
	local hasInventorySpace

	if not dosomethingtable then
		TriggerClientEvent('dopeNotify:Alert', source, "", "Interner Fehler", 2000, 'error')
		Stop(source)
		return
	end

	if not randomChange(dosomethingtable.chance) then
		if dosomethingtable.removeonfail then
			if tablelength(dosomethingtable.neededitems) > 0 then
				for k, need in ipairs(dosomethingtable.neededitems) do
					if need.remove then
						local itemtype = getItemType(need.item)
						if itemtype == "money" then
							xPlayer.removeAccountMoney(need.item, need.count)
						elseif itemtype == "weapon" then
							local loadoutNum, weapon = xPlayer.getWeapon(need.item)
							xPlayer.removeWeapon(need.item, weapon.ammo)
						elseif itemtype == "item" then
							xPlayer.removeInventoryItem(need.item, need.count)
						elseif itemtype == "unknown" then
							TriggerClientEvent('dopeNotify:Alert', source, "", "Item existiert nicht: "..need.item , 2000, 'error')
							return
						end
					end
				end
			end
		end
		TriggerClientEvent('dopeNotify:Alert', source, "", "Herstellen ist fehlgeschlagen", 2000, 'error')
		Start(source, label)
		return
	end


	-- Weapon Remove seperate because check if weapon already exist
	if tablelength(dosomethingtable.reciveitems) > 0 then
		for k, recive in ipairs(dosomethingtable.reciveitems) do
			local itemtype = getItemType(recive.item)
			if itemtype == "weapon" then
				if not xPlayer.hasWeapon(recive.item) then
					xPlayer.addWeapon(recive.item, recive.count)
				else
					TriggerClientEvent('dopeNotify:Alert', source, "", "Du hast bereits diese Waffe", 2000, 'error')
					Stop(source)
					return
				end
			end
			if tablelength(dosomethingtable.reciveitems) == k then
				addedweapon = true
			end
		end
	else
		addedweapon = true
	end

	-- Give Player Reward
	if tablelength(dosomethingtable.reciveitems) > 0 then
		for k, recive in ipairs(dosomethingtable.reciveitems) do
			local itemtype = getItemType(recive.item)
			if itemtype == "money" then
				xPlayer.addAccountMoney(recive.item, recive.count)
			elseif itemtype == "item" then
				xPlayer.addInventoryItem(recive.item, recive.count)
			elseif itemtype == "unknown" then
				TriggerClientEvent('dopeNotify:Alert', source, "", "Item existiert nicht: "..recive.item , 2000, 'error')
				return
			end
			
			if tablelength(dosomethingtable.reciveitems) == k then
				addeditem = true
			end
		end
	else
		addeditem = true
	end


	if tablelength(dosomethingtable.neededitems) > 0 then
		for k, need in ipairs(dosomethingtable.neededitems) do
			if need.remove then
				local itemtype = getItemType(need.item)
				if itemtype == "money" then
					xPlayer.removeAccountMoney(need.item, need.count)
				elseif itemtype == "weapon" then
					local loadoutNum, weapon = xPlayer.getWeapon(need.item)
					xPlayer.removeWeapon(need.item, weapon.ammo)
				elseif itemtype == "item" then
					xPlayer.removeInventoryItem(need.item, need.count)
				elseif itemtype == "unknown" then
					TriggerClientEvent('dopeNotify:Alert', source, "", "Item existiert nicht: "..need.item , 2000, 'error')
					return
				end
			end
	
			if tablelength(dosomethingtable.neededitems) == k then
				removeditem = true
			end
		end
	else
		removeditem = true
	end

	while true do
		Wait(1)
		if addedweapon ~= nil and addeditem ~= nil and removeditem ~= nil then
			if addedweapon and addeditem and removeditem then
				hasInventoryItem = hasInventoryItemFunc(source, label)
				hasInventorySpace = hasInventorySpaceFunc(source, label)
				break
			end
		end
	end


	while true do
		Wait(1)
		if hasInventoryItem ~= nil and hasInventorySpace ~= nil then
			if hasInventoryItem and hasInventorySpace then
				Start(source, label)
				break
			else
				break
			end
		end
	end
end

function hasInventoryItemFunc(source, label)
	local xPlayer = ESX.GetPlayerFromId(source)
	local dosomethingtable = getdosomethingtable(label)
	local itemsdonthave = {}
	if not Playertasks[source] then
		TriggerClientEvent('dopeNotify:Alert', source, "", "Interner Fehler", 2000, 'error')
		Stop(source)
		return
	end

	if not Playertasks[source].label == label then
		TriggerClientEvent('dopeNotify:Alert', source, "", "Interner Fehler", 2000, 'error')
		Stop(source)
		return
	end

	if not dosomethingtable then
		TriggerClientEvent('dopeNotify:Alert', source, "", "Interner Fehler", 2000, 'error')
		Stop(source)
		return
	end

	local haveitem = true
	if tablelength(dosomethingtable.neededitems) > 0 then
		for k, need in ipairs(dosomethingtable.neededitems) do
			itemtype = getItemType(need.item)
			if itemtype == "money" then
				if xPlayer.getAccount(need.item).money >= 0 then
					if xPlayer.getAccount(need.item).money >= need.count then
					else
						haveitem = false
						if xPlayer.getAccount(need.item) then
							table.insert(itemsdonthave, need.count - xPlayer.getAccount(need.item).money.."x "..getItemLabel(need.item).."<pre></pre>")
						else
							table.insert(itemsdonthave, need.count.."x "..getItemLabel(need.item).."<pre></pre>")
						end
					end
				else
					haveitem = false
				end
	
			elseif itemtype == "weapon" then
				if xPlayer.hasWeapon(need.item) then
				else
					haveitem = false
					table.insert(itemsdonthave, need.count.."x "..getItemLabel(need.item).."<pre></pre>")
				end
	
			elseif itemtype == "item" then
				if xPlayer.getInventoryItem(need.item).count >= need.count then
				else
					haveitem = false
					if xPlayer.getInventoryItem(need.item) then
						table.insert(itemsdonthave, need.count - xPlayer.getInventoryItem(need.item).count.."x "..getItemLabel(need.item).."<pre></pre>")
					else
						table.insert(itemsdonthave, need.count.."x "..getItemLabel(need.item).."<pre></pre>")
					end
				end
			elseif itemtype == "unknown" then
				TriggerClientEvent('dopeNotify:Alert', source, "", "Item existiert nicht: "..need.item , 2000, 'error')
				return
			end

			if tablelength(dosomethingtable.neededitems) == k then
				if haveitem then
					return true
				else
					TriggerClientEvent('dopeNotify:Alert', source, "", "Dir Fehlen: <pre></pre>"..table.concat(itemsdonthave, " "), 2000, 'error')
					Stop(source)
					return false
				end
			end
		end
	else
		return true
	end
end

function hasInventorySpaceFunc(source, label)
	local xPlayer = ESX.GetPlayerFromId(source)
	dosomethingtable = getdosomethingtable(label)
	space = xPlayer.getMaxWeight() - xPlayer.getWeight()

	if not dosomethingtable then
		TriggerClientEvent('dopeNotify:Alert', source, "", "Interner Fehler", 2000, 'error')
		Stop(source)
		return
	end

	itemweight = 0
	needweight = 0
	reciveweight = 0

	if tablelength(dosomethingtable.neededitems) > 0 then
		for k, need in ipairs(dosomethingtable.neededitems) do
			itemtype = getItemType(need.item)
			if itemtype == "item" then
				if ESX.Items[need.item] then
					itemweight = ESX.Items[need.item].weight * need.count
					needweight = needweight + itemweight
				end
			end
		end
	end

	if tablelength(dosomethingtable.reciveitems) > 0 then
		for k, recive in ipairs(dosomethingtable.reciveitems) do
			itemtype = getItemType(recive.item)
			if itemtype == "item" then
				if ESX.Items[recive.item] then
					itemweight = ESX.Items[recive.item].weight * recive.count
					reciveweight = reciveweight + itemweight
				end
			end
		end
	end

	itemweight = needweight - reciveweight
	space = space - itemweight

	if space >= 0 then
		return true
	else
		TriggerClientEvent('dopeNotify:Alert', source, "", "Dein Inventrar ist voll", 2000, 'error')
		Stop(source)
		return false
	end
end

function getdosomethingtable(label)
	for k, v in pairs (routen) do
		for k, v in pairs (v) do
			for k, v in pairs (v) do
				if (type(v) == "table") then
					for k, v in pairs (v.dosomething) do
						if v.label == label then
							return v
						end
					end
				end
			end
		end
	end
end


function getroutetable(label)
	for k, v in pairs (routen) do
		for k, v in pairs (v) do
			for k, v in pairs (v) do
				route = v
				if (type(v) == "table") then
					route = v
					for k, v in pairs (v.dosomething) do
						if v.label == label then
							return route
						end
					end
				end
			end
		end
	end
end

function tablelength(T)
	local count = 0
	for _ in pairs(T) do 
		count = count + 1 
	end
	return count
end


function getItemType(item)
	if item == "money" or item == "bank" or item == "black_money" or item == "crypto" then
		return "money"
	elseif ESX.GetWeaponLabel(item) then
		return "weapon"
	elseif ESX.GetItemLabel(item) then
		return "item"
	else
		return "unknown"
	end
end


function randomChange(percent)
	assert(percent >= 0 and percent <= 100)
	return percent >= math.random(1, 100)
end

function Stop(source)
	TriggerClientEvent('dopeNotify:Alert', source, "", "Interaktion wurde beendet", 2000, 'info')
	TriggerClientEvent('esx_routen:changestatus', source, false)
	Playertasks[source] = {}
end


function getItemLabel(item)
	if item == "money" then
		return "Bargeld"
	elseif item == "bank" then
		return "Bankgeld"
	elseif item == "black_money" then
		return "Schwarzgeld"
	elseif item == "crypto" then
		return "Bitcoins"
	elseif ESX.GetWeaponLabel(item) then
		return ESX.GetWeaponLabel(item)
	elseif ESX.GetItemLabel(item) then
		return ESX.GetItemLabel(item)
	else
		return item
	end
end