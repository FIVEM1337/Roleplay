ESX = nil
local blips_list = {}
local PlayerData = {}


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end

	while PlayerData.job == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		PlayerData = ESX.GetPlayerData()
		Citizen.Wait(111)
	end

	Wait(5000)
	PlayerData = ESX.GetPlayerData()
	DeleteBlips()
	for k, v in pairs(blips) do
		print(v.job)
		if v.job == false or v.job == nil or v.job == PlayerData.job.name then
			print("enter")
			blip = CreateBlip(v)
			table.insert(blips_list, blip)
		end
	end
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData = ESX.GetPlayerData()
	DeleteBlips()
	for k, v in pairs(blips) do
		if v.job == false or v.job == nil or v.job == PlayerData.job.name then
			blip = CreateBlip(v)
			table.insert(blips_list, blip)
		end
	end
end)

function DeleteBlips()
	for i, station in ipairs(blips_list) do
		if DoesBlipExist(station) then
			RemoveBlip(station)
		end
	end	
	blips_list = {}
end


function CreateBlip(config)
	local blip = AddBlipForCoord(config.coord)
	SetBlipSprite(blip, config.sprite)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, config.scale)
	SetBlipColour(blip, config.color)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName('STRING')	
	AddTextComponentSubstringPlayerName(config.name)
	EndTextCommandSetBlipName(blip)
	return blip
end