RegisterNetEvent('inventory:openPlayerInventory', function (pid)
  OpenInventory({type = 'player', id = pid, title = Locales.playerTitle, weight = true, delay = 1000})
end)