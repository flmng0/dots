return {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'ThePrimeagen/refactoring.nvim',
        'ThePrimeagen/harpoon',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
        },
    },

    opts = function()
        local actions = require('telescope.actions')
        local telescope = require('telescope')

        require('refactoring').setup {}
        require('harpoon').setup {}

        telescope.setup {
            defaults = {
                theme = 'kanagawa',
                mappings = {
                    i = {
                        ['<Esc>'] = actions.close,
                        ['<C-j>'] = actions.move_selection_next,
                        ['<C-k>'] = actions.move_selection_previous,
                    },
                    n = {
                        ['q'] = actions.close,
                    },
                },
                sorting_strategy = 'ascending',
                scroll_strategy = 'limit',
                layout_strategy = 'horizontal',
                layout_config = {
                    horizontal = {
                        prompt_position = 'top',
                        preview_width = 0.55,
                        results_width = 0.8,
                    },
                    vertical = {
                        mirror = false,
                    },
                    width = 0.87,
                    height = 0.80,
                    preview_cutoff = 120,
                },
            },
        }

        telescope.load_extension 'fzf'
        telescope.load_extension 'refactoring'
        -- Find harpoon-specific keybinds in tmthy.keys
        telescope.load_extension 'harpoon'
    end,

    init = function()
        local utils = require('tmthy.utils')
        local nmap = utils.nmap
        local vmap = utils.vmap
        local ts = require('telescope.builtin')
        local extensions = require('telescope').extensions

        -- Leader for searching
        nmap('<leader><space>', ts.find_files, 'Search Files')
        nmap('<leader>.', ts.buffers, 'Search Active Buffers')
        nmap('<leader>,', ts.git_files, 'Search Git Files')

        nmap('<leader>l', ts.live_grep, 'Live Grep')
        nmap('<leader>o', ts.oldfiles, 'Search Old Files')
        nmap('<leader>k', ts.keymaps, 'Search Keymaps')

        nmap('<leader>d', ts.diagnostics, 'Show Diagnostic Messages')

        nmap('<leader>\'', ts.registers, 'Show Registers')
        nmap('<leader>h', ts.help_tags, 'Search Help Tags')

        -- Reminder: done in a string so that it enters normal mode first
        vmap(
            '<leader>R',
            [[<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>]],
            'Search Available Refactors'
        )

        -- Not sure why I chose '[' for the keybind. It just feels right.
        nmap('<leader>[', extensions.harpoon.marks, 'View Harpoons')
    end,
}
