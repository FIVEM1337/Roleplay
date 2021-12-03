fx_version 'adamant'
game 'gta5'

ui_page 'html/index.html'

client_scripts {
  'client/*.lua',
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'config.lua',
  'server/*.lua',
}

files {
  'html/*.css',
  'html/*.js',
  'html/*.png',
  'html/index.html',
}
