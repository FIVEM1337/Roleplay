fx_version 'bodacious'
game 'gta5'

shared_scripts {
	'@es_extended/imports.lua',
	'config.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server.lua',
	'server_functions.lua'
}

client_scripts {
	'client.lua'
}
