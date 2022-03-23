fx_version 'adamant'
games { 'gta5' }

author 'Musiker15'
description 'ESX Weapons with Clips, Components & Tints'
version '6.3'

shared_scripts {
	'@es_extended/imports.lua',
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua'
}

client_scripts {
	"@NativeUILua_Reloaded/src/NativeUIReloaded.lua",
	'client.lua',
	'menu.lua'
}

server_scripts {
	'server.lua'
}

dependencies {
	'es_extended'
}

dependencies {
	'es_extended'
}