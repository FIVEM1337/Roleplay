local inMenu = false

RegisterNetEvent("esx_scratchcard:nuiOpenCard")
AddEventHandler("esx_scratchcard:nuiOpenCard", function(key, price, amount, price_type)
  if inMenu then return end
  SetNuiFocus(true, true)
  SendNUIMessage({
    type = 'openScratch',
    key = key,
    price = price,
    amount = amount,
    price_type = price_type,
    win_message = _U('scratch_won'),
    lose_message = _U('scratch_lost'),
    currency = _U('currency'),
    scratchAmount = Config.ScratchAmount,
    resourceName = GetCurrentResourceName(),
    debug = debugIsEnabled
  })
  inMenu = true
end)

RegisterNUICallback('nuiCloseCard', function()
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'closeScratch'})
  TriggerEvent("esx_scratchcard:stopScratchingEmote")
  inMenu = false
end)