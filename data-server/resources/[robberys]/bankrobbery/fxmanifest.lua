fx_version 'bodacious'
game 'gta5'

shared_scripts {
	'@es_extended/imports.lua',
	'config.lua',
	'language.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/server.lua',
	'server/protection_sv.lua',
}

client_scripts {
	'client/client.lua',
	'client/utils.lua',
	'client/protection_cl.lua',
}
