local M = {
    'nvim-tree/nvim-tree.lua',
    tag = 'nightly',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },
}

function M.config()
    require('nvim-tree').setup {
        diagnostics = {
            enabled = true,
        },
        view = {
            adaptive_size = true,
        },
        actions = {
            open_file = {
                quit_on_open = true,
            },
        },
    }
end

function M.init()
    local nmap = require('tmthy.utils').nmap
    local tree = require('nvim-tree.api').tree

    nmap('\\', tree.toggle, 'Open File Tree')
end

return M
