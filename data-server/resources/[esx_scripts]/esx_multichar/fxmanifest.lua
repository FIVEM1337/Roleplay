fx_version 'bodacious'
game 'gta5'


server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'server.lua',
  }
  
  client_scripts {
    '@NativeUILua_Reloaded/src/NativeUIReloaded.lua',
    'config.lua',
    'client.lua',
  }