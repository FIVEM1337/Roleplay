AddEventHandler('esx:playerLoaded', function(source)

			TriggerClientEvent('bankrobbery:loadDataCL', source, Banks, Safes)

		end)

		

		RegisterServerEvent('bankrobbery:loadDataSV')

		AddEventHandler('bankrobbery:loadDataSV', function()

			TriggerClientEvent('bankrobbery:loadDataCL', -1, Banks, Safes)

		end)

		

		-- inUse state:

		RegisterServerEvent('bankrobbery:inUseSV')

		AddEventHandler('bankrobbery:inUseSV', function(state)

			for i = 1, #Banks do

				Banks[i].InProgress = state

			end

			TriggerClientEvent('bankrobbery:inUseCL', -1, state)

		end)

		

		RegisterServerEvent('bankrobbery:KeypadStateSV')

		AddEventHandler('bankrobbery:KeypadStateSV', function(type, id, state)

			local xPlayer = ESX.GetPlayerFromId(source)

			if type == "first" then

				Banks[id].keypads[1].hacked = state

			elseif type == "second" then

				Banks[id].keypads[2].hacked = state

			end	

			TriggerClientEvent('bankrobbery:KeypadStateCL', -1, id, state, type)

		end)



		RegisterServerEvent('bankrobbery:OpenVaultDoorSV')

		AddEventHandler('bankrobbery:OpenVaultDoorSV', function(k,v,heading,amount)

			local xPlayer = ESX.GetPlayerFromId(source)

			TriggerClientEvent('bankrobbery:OpenVaultDoorCL', -1, k,v,heading,amount)

		end)



		RegisterServerEvent('bankrobbery:CloseVaultDoorSV')

		AddEventHandler('bankrobbery:CloseVaultDoorSV', function(k,v,heading,amount)

			local xPlayer = ESX.GetPlayerFromId(source)

			TriggerClientEvent('bankrobbery:CloseVaultDoorCL', -1, k,v,heading,amount)

		end)



		

		-- ## PACIFIC SAFE ## --

		RegisterServerEvent('bankrobbery:pacificSafeSV')

		AddEventHandler('bankrobbery:pacificSafeSV', function(id, state)

			local xPlayer = ESX.GetPlayerFromId(source)

			Banks[id].safe.cracked = state

			TriggerClientEvent('bankrobbery:pacificSafeCL', -1, id, state)

		end)



		-- DeskDoor::

		RegisterServerEvent('bankrobbery:deskDoorSV')

		AddEventHandler('bankrobbery:deskDoorSV', function(id, state)

			local xPlayer = ESX.GetPlayerFromId(source)

			Banks[id].deskDoor.lockpicked = state

			TriggerClientEvent('bankrobbery:deskDoorCL', -1, id, state)

		end)

		-- Open Door:

		RegisterServerEvent('bankrobbery:OpenDeskDoorSV')

		AddEventHandler('bankrobbery:OpenDeskDoorSV', function(k,v,heading,amount)

			local xPlayer = ESX.GetPlayerFromId(source)

			TriggerClientEvent('bankrobbery:OpenDeskDoorCL', -1, k,v,heading,amount)

		end)

		-- Close Door:

		RegisterServerEvent('bankrobbery:CloseDeskDoorSV')

		AddEventHandler('bankrobbery:CloseDeskDoorSV', function(k,v,heading,amount)

			local xPlayer = ESX.GetPlayerFromId(source)

			TriggerClientEvent('bankrobbery:CloseDeskDoorCL', -1, k,v,heading,amount)

		end)
		-- trigger function policeCount:

		getPoliceCount()