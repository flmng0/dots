return {
    'nvim-tree/nvim-tree.lua',
    tag = 'nightly',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },

    config = function()
        require('nvim-tree').setup {
            hijack_unnamed_buffer_when_opening = true,
            diagnostics = {
                enable = true,
            },
            view = {
                adaptive_size = true,
            },
            renderer = {
                group_empty = true,
                full_name = true,
                highlight_opened_files = "all",
            },
            actions = {
                open_file = {
                    quit_on_open = true,
                },
                change_dir = {
                    global = true,
                },
                expand_all = {
                    exclude = { '.git', 'target', 'build', 'node_modules' },
                },
            },
        }
    end,

    init = function()
        local nmap = require('tmthy.utils').nmap
        local tree = require('nvim-tree.api').tree

        nmap('\\', function()
            if vim.bo.filetype ~= 'NvimTree' then
                tree.focus()
            else
                tree.close()
            end
        end, 'Open File Tree')
    end,
}