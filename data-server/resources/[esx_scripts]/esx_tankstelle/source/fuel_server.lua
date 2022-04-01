ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('fuel:pay')
AddEventHandler('fuel:pay', function(price)
	local xPlayer = ESX.GetPlayerFromId(source)
	local amount = ESX.Math.Round(price)

	if price > 0 then
		xPlayer.removeMoney(amount)
	end
end)


RegisterServerEvent('esx_tankstelle:removejerry')
AddEventHandler('esx_tankstelle:removejerry', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.hasWeapon("WEAPON_PETROLCAN") then
		local loadoutNum, weapon = xPlayer.getWeapon("WEAPON_PETROLCAN")
		xPlayer.removeWeapon("WEAPON_PETROLCAN", weapon.ammo)
	end
end)

ESX.RegisterServerCallback('fuel:money', function(playerId, cb)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local money = xPlayer.getMoney()

	cb(money)
end)

RegisterServerEvent('esx_tankstelle:setjerryfuel')
AddEventHandler('esx_tankstelle:setjerryfuel', function(amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.hasWeapon("WEAPON_PETROLCAN") then
		local loadoutNum, weapon = xPlayer.getWeapon("WEAPON_PETROLCAN")
		xPlayer.setWeaponAmmo("WEAPON_PETROLCAN", amount)
	end
end)

ESX.RegisterServerCallback('fuel:money', function(playerId, cb)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local money = xPlayer.getMoney()

	cb(money)
end)
