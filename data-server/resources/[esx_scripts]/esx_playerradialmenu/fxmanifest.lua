fx_version 'cerulean'
game 'gta5'

version '1.0.0'

ui_page 'html/index.html'

shared_scripts {
    '@es_extended/imports.lua',
    '@es_extended/locale.lua',
    'config.lua',
    'locales/de.lua'
}

client_scripts {
    "@NativeUILua_Reloaded/src/NativeUIReloaded.lua",
    'client/client.lua',
    'client/clothing.lua'
}

server_scripts {
    'server/server.lua'
}

files {
    'html/index.html',
    'html/css/main.css',
    'html/js/main.js',
    'html/js/RadialMenu.js',
}

lua54 'yes'