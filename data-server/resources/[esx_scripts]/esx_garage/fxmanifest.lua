fx_version 'bodacious'
game 'gta5'

shared_scripts {
	'@es_extended/imports.lua',
	'conf/*.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',	
	'server.lua'
}

client_scripts {
	"@NativeUILua_Reloaded/src/NativeUIReloaded.lua",
	'client.lua'
}
