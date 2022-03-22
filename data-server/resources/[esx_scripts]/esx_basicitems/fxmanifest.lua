fx_version 'adamant'

game 'gta5'

description 'ESX Basic Items'

version '0.0.0'


ui_page 'html/index.html'

files {
	'html/index.html',
	'html/index.js',
	'html/style.css',
	'html/static/img/bildschirm.png'
}

shared_script '@es_extended/imports.lua'

server_scripts {
    '@es_extended/locale.lua',
    'server.lua',
    'config.lua'
}

client_scripts {
    '@es_extended/locale.lua',
    'client.lua',
    'config.lua'
}

dependencies {
    'es_extended',
    'oxmysql',
    'esx_status',
    'esx_basicneeds'
}