fx_version 'bodacious'
game 'gta5'

description 'esx_tuning'
version '1.0.0'

lua54 'on'
is_cfxv2 'yes'
use_fxv2_oal 'true'

ui_page 'client/ui/index.html'
files {
	'client/ui/index.html',
	'client/ui/js/**/*.js',
	'client/ui/css/**/*.css',
	'client/ui/img/**/*.png',
	'client/ui/sounds/**/*.ogg'
}

shared_scripts {
	'@es_extended/imports.lua',
	'@es_extended/locale.lua',
	'config/config.lua',
	'config/menus.lua',
	'config/labels.lua',
	'config/vehicles.lua'
}

client_scripts {
	'client/core.lua',
	'client/helper.lua'
}

server_scripts {
	'server/core.lua'
}

dependencies {
	'es_extended'
}
