fx_version 'bodacious'
game 'gta5'

shared_scripts {
	'@es_extended/imports.lua',
	'@es_extended/locale.lua',
	'config.lua',
	'locales/de.lua',
}


server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/server.lua'
}

client_scripts {
	'client/client.lua',
	'client/client_functions.lua'
}

ui_page "HTML/ui.html"

files {
	"HTML/ui.css",
	"HTML/ui.html",
	"HTML/ui.js",
	"HTML/imgs/*.png",
	"HTML/imgs/*.jpg"
}

