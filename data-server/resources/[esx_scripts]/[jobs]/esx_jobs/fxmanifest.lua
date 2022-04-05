fx_version 'bodacious'
game 'gta5'

description 'esx_jobs'

version '0.0.1'

shared_scripts {
	'@es_extended/imports.lua',
	'@es_extended/locale.lua',
	'config.lua',
	'locales/de.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua',
	'server/ambulance.lua'
}

client_scripts {
	"@NativeUILua_Reloaded/src/NativeUIReloaded.lua",
	'client/main.lua',
	'client/ambulance.lua'
}