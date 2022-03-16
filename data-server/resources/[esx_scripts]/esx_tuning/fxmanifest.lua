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

client_scripts {
	'@es_extended/locale.lua',
	'client/core.lua',
	'client/helper.lua',
	'config/config.lua',
	'config/menus.lua',
	'config/labels.lua',
	'config/vehicles.lua',
}

server_scripts {
	'@es_extended/locale.lua',
	'server/core.lua',
	'config/config.lua',
	'config/menus.lua',
	'config/labels.lua',
	'config/vehicles.lua',
}