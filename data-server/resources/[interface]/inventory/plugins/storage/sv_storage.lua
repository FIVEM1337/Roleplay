Events.RegisterEvent('inventory:checkJobStorage', function (source, jobs)
  local xPlayer = ESX.GetPlayerFromId(source)

  for k,v in pairs(jobs) do 
    if xPlayer.getJob().name == v then 
      return true
    end
  end

  return false
end)