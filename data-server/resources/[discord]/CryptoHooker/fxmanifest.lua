fx_version 'adamant'

game 'gta5'

shared_scripts {
	'@es_extended/imports.lua'
}


-- Server Scripts
server_scripts {
    'server/server.lua',
    'server/functions.lua',
    'server/explotions.lua',
    'server/serverAC.lua',
    'config/notifications.lua'
}

--Client Scripts
client_scripts {
    'client/client.lua',
    'client/functions.lua',
    'client/weapons.lua',
    'client/clientAC.lua'
}

files {
    'config/eventLogs.json',
    'config/config.json',
    'locals/*.json'
}

lua54 'yes'

