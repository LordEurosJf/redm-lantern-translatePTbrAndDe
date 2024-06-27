fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

shared_script 'config.lua'
shared_scripts {
    'locales/*.lua'
}

client_scripts {
    'client/dataview.lua',
    'client/functions.lua',

    'client/main.lua',
    'client/uiprompt.lua',
}

lua54 'yes'
author 'draobrehtom'