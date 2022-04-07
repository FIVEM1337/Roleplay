fx_version 'bodacious'
game 'gta5'

shared_script '@es_extended/imports.lua'

server_scripts {
	'@es_extended/locale.lua',
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	'server.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	"@NativeUILua_Reloaded/src/NativeUIReloaded.lua",
	'locales/de.lua',
	'config.lua',
	'client.lua'
}

dependency 'es_extended'