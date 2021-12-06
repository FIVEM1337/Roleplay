fx_version 'bodacious' 
game 'gta5'

client_scripts {
    'client/client.lua',
    'Config.lua',
}

server_scripts {
    'server/server.lua',
    'Config.lua',
    "@mysql-async/lib/MySQL.lua",
    'server/items.lua',
}

dependencies {
    'progressBars',
    'es_extended',
}