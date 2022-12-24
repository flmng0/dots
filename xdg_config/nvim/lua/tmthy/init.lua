vim.g.mapleader = ' '

require('tmthy.options')

-- plugins returns a boolean that is true when
-- packer is installed for the first time
if require('tmthy.plugins') then
    print('-----------------------------------------------')
    print('           Running first-time setup.           ')
    print('Please restart NeoVim after Packer is finished.')
    print('-----------------------------------------------')
    return
end

require('tmthy.keys')
require('tmthy.autocmds')

require('tmthy.config')

