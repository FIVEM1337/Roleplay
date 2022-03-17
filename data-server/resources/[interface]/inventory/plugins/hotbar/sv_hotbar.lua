Events.RegisterEvent('inventory:getHotbar', function (source)
  local xPlayer = ESX.GetPlayerFromId(source)
  if not xPlayer then return end
  
  local hotbar = getHotbar(xPlayer)

  return hotbar
end)