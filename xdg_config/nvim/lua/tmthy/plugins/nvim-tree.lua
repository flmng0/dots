local M = {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
        'nvim-tree/nvim-web-devicons'
    }
}

function M.config()
    require('nvim-tree').setup {
        disable_netrw = true,
        view = {
            hide_root_folder = true,
        },
    }
end

function M.init()
    local nmap = require('tmthy.utils').nmap
    local tree = require('nvim-tree.api').tree

    nmap('<leader>;', tree.focus, 'Open and Focus File Tree')
    nmap('<leader>fn', tree.open, 'Open File Tree')
    nmap('<leader>fd', tree.close, 'Close File Tree')
end

return M
