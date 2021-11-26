fx_version 'adamant'

game 'gta5'

description 'AESX Admin Panel'

version '1.0.0'

client_scripts {
	'client/main.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua'
}

shared_script {
    'config.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/index.js',
    'html/index.css',
    'html/img/solarscripts.png'

}


