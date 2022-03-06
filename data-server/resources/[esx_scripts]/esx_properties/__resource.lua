resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts {
	"@NativeUILua_Reloaded/src/NativeUIReloaded.lua", -- disable this when you do not want to use NativeUIReloaded
    --'@NativeUI/NativeUI.lua', -- if you want to use NativeUI instead of NativeUI Reloaded -> Activate this!
	'config.lua',
	'client.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server.lua',
}