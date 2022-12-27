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
            enable = true,
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

    nmap('\\', function()
        if vim.bo.filetype ~= 'NvimTree' then
            tree.focus()
        else
            tree.close()
        end
    end, 'Open File Tree')
end

return M