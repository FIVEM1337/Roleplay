
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--
-- SET UP HERE WHETHER YOU USE THE NEWER ESX VERSION WITH LICENSE IDENTIFIERS
-- Set this to true, when you use ESX 1.2 or higher
local useNewESX = false

-- Kleiderschrank
ESX.RegisterServerCallback('clothes:requestData', function(source, cb)
    if source ~= nil then

        local clothesData = {}

		local steamID
		if useNewESX then
			steamID = string.gsub(GetPlayerIdentifiers(source)[2], "license:", "")
		else
			steamID = GetPlayerIdentifiers(source)[1]
		end
		
		

        MySQL.Async.fetchAll('SELECT * from user_clothes WHERE identifier = @identifier', {
            ['@identifier'] = steamID
        },
            function(result)
                if #result > 0 then
                    for k, v in pairs(result) do
                        table.insert(clothesData, {
                            id = result[k].id,
                            identifier = result[k].identifier,
                            name = result[k].name,
                            clothesData = json.decode(result[k].clothesData),
                        })

                    end

                    cb(clothesData)
    
                end
            end
        )
    end

end)

RegisterServerEvent('clothes:saveOutfit')
AddEventHandler('clothes:saveOutfit', function(label, skinRes)

    if source ~= nil then
		if label and skinRes ~= nil then
		
			local steamID
			if useNewESX then
				steamID = string.gsub(GetPlayerIdentifiers(source)[2], "license:", "")
			else
				steamID = GetPlayerIdentifiers(source)[1]
			end

			MySQL.Async.execute(
				'INSERT INTO user_clothes (identifier, name, clothesData) VALUES (@identifier, @name, @clothesData)', {
				  ['@identifier'] = steamID,
				  ['@name'] = label,
				  ['@clothesData'] = json.encode(skinRes),
			  }
			)
		end
    end

end)

RegisterServerEvent('clothes:removeOutfit')
AddEventHandler('clothes:removeOutfit', function(id)

    MySQL.Async.execute(
        'DELETE FROM user_clothes WHERE id = @id', {
          ['@id'] = id,
      }
    )

end)
