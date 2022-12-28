local M = {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'ThePrimeagen/refactoring.nvim',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
        },
    },
}

function M.config()
    local actions = require('telescope.actions')
    local telescope = require('telescope')

    require('refactoring').setup {}

    telescope.setup {
        defaults = {
            theme = 'onedark',
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
end

function M.init()
    local utils = require('tmthy.utils')
    local nmap = utils.nmap
    local vmap = utils.vmap
    local ts = require('telescope.builtin')

    -- "s" for search, e.g. "sf" => "search files"
    nmap('<leader><space>', ts.find_files, 'Search Files')

    nmap('<leader>sl', ts.live_grep, 'Search With Live Grep')
    nmap('<leader>sg', ts.git_files, 'Search Git Files')
    nmap('<leader>sp', ts.oldfiles, 'Search Previously Opened Files')
    nmap('<leader>sk', ts.keymaps, 'Search Keymaps')

    nmap('<leader>sd', ts.diagnostics, 'Search Diagnostic Messages')

    nmap('<leader>s\'', ts.registers, 'Search Registers')
    nmap('<leader>sh', ts.help_tags, 'Search Help Tags')

    nmap('<leader>sb', ts.buffers, 'Search Active Buffers')

    -- Reminder: done in a string so that it enters normal mode first
    vmap(
        '<leader>r',
        [[<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>]],
        'Search Available Refactors'
    )
end

return M
