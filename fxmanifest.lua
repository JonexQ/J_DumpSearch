fx_version 'adamant'
game 'gta5'
lua54 'yes'

-- INFO --
name        'J_DumpSearch'
author      'Jonne'
version     '1.0.0'

shared_script {
	'shared/*.lua',
    '@ox_lib/init.lua',
}

client_scripts {
    '**/cl_*.lua',
}

server_scripts {
    '**/sv_*.lua',
}

dependencies {
	'ox_inventory',
    'ox_lib'
}