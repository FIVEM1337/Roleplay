if IsDuplicityVersion() then
  -- server Side
  ESX = nil
  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
else 
  -- client side
  ESX = nil
  CreateThread(function ()
    while ESX == nil do 
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Wait(1)
    end
  end)
end