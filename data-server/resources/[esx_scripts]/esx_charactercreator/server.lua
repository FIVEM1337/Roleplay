ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('register:saveSkin')
AddEventHandler('register:saveSkin', function(skin)

  local xPlayer = ESX.GetPlayerFromId(source)
  MySQL.Async.execute(
    'UPDATE users SET `skin` = @skin WHERE identifier = @identifier',
    {
      ['@skin']       = json.encode(skin),
      ['@identifier'] = xPlayer.identifier
    }
  )

end)

ESX.RegisterServerCallback('esx_charactercreator:getGroup', function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)
    cb(xPlayer.getGroup())
  
end)