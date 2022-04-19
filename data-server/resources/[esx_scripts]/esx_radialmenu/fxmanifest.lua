fx_version 'cerulean'
game 'gta5'
lua54 'yes'

version      '1.0.0'
repository   'https://github.com/baguscodestudio/bcs_radialmenu'

shared_scripts {
	'@es_extended/imports.lua',
	'config.lua',
}

ui_page 'web/html/index.html'

files {
    'web/html/index.html',
    'web/html/assets/*.css',
    'web/html/assets/*.js'
}

client_scripts {
    'client/main.lua'
}

