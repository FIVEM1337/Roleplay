ESX.RegisterCommand('openinv', 'admin', function(xPlayer, args, showError)
  local target = ESX.GetPlayerFromId(args.id)
  if not target then 
      xPlayer.triggerEvent("inventory:notify", Locales.playerDoesNotExist, "error")
      return 
  end
  
  if xPlayer.getIdentifier() == target.getIdentifier() then
    xPlayer.triggerEvent("inventory:notify", Locales.cannotViewYourOwnInventory, "error")
    return
  end
  
  if GetPlayerName(args.id) then 
    xPlayer.triggerEvent("inventory:openPlayerInventory", args.id)
  else 
    xPlayer.triggerEvent("inventory:notify", Locales.playerDoesNotExist, "error")
  end
end, false, {help = Locales.openPlayerInventory, arguments = {
  {name = 'id', help = 'Player ID', type = 'number'},
}})