fx_version 'bodacious'

description 'ESX Vehicle Shop'
game 'gta5'

version '1.2.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/de.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/de.lua',
	'locales/en.lua',
	'config.lua',
	'client/utils.lua',
	'client/main.lua'
}

ui_page "HTML/ui.html"

files {
	"HTML/ui.css",
	"HTML/ui.html",
	"HTML/ui.js",
	"HTML/imgs/*.png",
	"HTML/imgs/*.jpg"
}

dependency 'es_extended'

exports {
	'GeneratePlate',
	'OpenShopMenu'
}
