fx_version 'cerulean'
games {'common'}
ui_page 'html/index.html'

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
