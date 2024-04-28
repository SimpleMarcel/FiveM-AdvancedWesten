fx_version 'cerulean'
game 'gta5'

author 'MarcelSimple'
description 'Advanced Westen System'
version '1.0.2'

shared_script 'Einstellungen/Simple_Einstellungen.lua'

server_scripts {
    'Einstellungen/SimplePanel.lua',
    'Einstellungen/Simple_Security.lua',
	'Server/Simple_Server.lua'
}

client_script 'Client/Simple_Client.lua'

escrow_ignore {
    'Einstellungen/Simple_Einstellungen.lua',  
    'Einstellungen/Simple_Security.lua',
    'Einstellungen/SimplePanel.lua'
}

lua54 'yes'