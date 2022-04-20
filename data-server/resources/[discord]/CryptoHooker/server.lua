AddEventHandler('chatMessage', function(source, name, msg)
    msg = "**"..msg.."**"
    print(msg)
    CreateLog(source, nil, msg, "chatMessage")
end)

RegisterNetEvent('CryptoHooker:chatMessage')
AddEventHandler('CryptoHooker:chatMessage', function(source, msg, chat_type)
    msg = "**"..msg.."**"
    CreateLog(source, nil, msg, chat_type)
end)

RegisterNetEvent('CryptoHooker:handcuff')
AddEventHandler('CryptoHooker:handcuff', function(trigger, target)
    msg = "**(ID:"..trigger..") "..GetPlayerName(trigger).." hat (ID:"..target..") "..GetPlayerName(target).." festgenommen**"
    CreateLog(trigger, target, msg, "handcuff")
end)

RegisterNetEvent('CryptoHooker:unhandcuff')
AddEventHandler('CryptoHooker:unhandcuff', function(trigger, target)
    msg = "**(ID:"..trigger..") "..GetPlayerName(trigger).." hat (ID:"..target..") "..GetPlayerName(target).." entfesselt**"
    CreateLog(trigger, target, msg, "unhandcuff")
end)

RegisterNetEvent('CryptoHooker:auto_unhandcuff')
AddEventHandler('CryptoHooker:auto_unhandcuff', function(target)
    msg = "** Die fesseln von (ID:"..target..") "..GetPlayerName(target).." haben sich automatisch gelöst**"
    CreateLog(target, nil, msg, "unhandcuff")
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    msg = "**Spieler (ID: "..playerId..") "..GetPlayerName(playerId).." ist dem Server beigetreten**"
    CreateLog(playerId, nil, msg, "joined")
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
    msg = "**Spieler (ID: "..playerId..") "..GetPlayerName(playerId).." hat den Server verlassen \n Grund: "..reason.."**"
    CreateLog(playerId, nil, msg, "leave")
end)

AddEventHandler('CryptoHooker:weaponcraft', function(source, item, count)
    msg = "**"..count.."x "..ESX.GetWeaponLabel(item).." hergestellt**"
    CreateLog(source, nil, msg, "weaponcraft")
end)

