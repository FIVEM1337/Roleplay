fx_version 'bodacious'
game 'gta5'

description 'esx_fuelstation'
version '1.0'

shared_scripts {
	'@es_extended/imports.lua',
	'config.lua',
}

server_scripts {
	'server.lua'
}

client_scripts {
	'client.lua',
	'client_functions.lua',
}
