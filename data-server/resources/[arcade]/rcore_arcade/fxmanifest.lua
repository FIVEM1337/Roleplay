fx_version 'adamant'
games { 'gta5' }


client_scripts {
	"@NativeUILua_Reloaded/src/NativeUIReloaded.lua",
	"config.lua",
	"client/main.lua",
	"client/events.lua",
	"client/class/*.lua",
	"client/threads.lua",
}

server_script {
	"config.lua",
	"server/server.lua",
}

files {
	"html/css/style.css",
	"html/css/reset.css",
	
	"html/css/img/monitor.png",
	"html/css/img/table.png",
	
	"html/*.html",
	
	"html/scripts/listener.js",
}

ui_page "html/index.html"