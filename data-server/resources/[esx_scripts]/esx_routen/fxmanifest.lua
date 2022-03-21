fx_version 'bodacious'
game 'gta5'

description 'esx_routen'
version '1.0'

shared_scripts {
	'@es_extended/imports.lua',
	'config.lua',
}

client_scripts {
	"@NativeUILua_Reloaded/src/NativeUIReloaded.lua",
	'client.lua'
}

server_scripts {
	'server.lua'
}


dependencies {
	'es_extended'
}
