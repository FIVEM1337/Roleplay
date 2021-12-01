fx_version 'adamant'

game 'gta5'

description 'Tattoo Shop'

version '1.4.2'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/de.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/de.lua',
	'config.lua',
	'client/tattooList.lua',
	'client/main.lua'
}

dependencies {
	'es_extended',
	'skinchanger',
	'esx_skin'
}
