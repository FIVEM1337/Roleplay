fx_version 'adamant'

game 'gta5'

description 'esx_gangjobs'

version '1.4.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'config.lua',
	'locales/de.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'config.lua',
	'locales/de.lua',
	'client/main.lua'
}

dependencies {
	'es_extended',
}