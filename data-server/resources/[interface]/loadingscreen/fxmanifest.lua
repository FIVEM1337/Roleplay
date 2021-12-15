-- Resource Metadata
fx_version 'cerulean'
games { 'gta5' }

description 'loadingscreen'
version '1.0.0'

loadscreen 'ui/index.html'
loadscreen_manual_shutdown 'yes'

files {
    'ui/index.html',
    'ui/style.css',
    'ui/default.mp4',
    'ui/music.mp3',
}


client_scripts {
	'client.lua'
}
