local M = {
    'nvim-telescope/telescope.nvim',
    lazy = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            'nvim-telescope/telescope-file-browser.nvim',
            lazy = false,
        }
    },
}

function M.config()
    local actions = require('telescope.actions')
    local telescope = require('telescope')

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
            layout_strategy = 'horizontal',
            sorting_strategy = 'ascending',
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
        extensions = {
            file_browser = {
                hijack_netrw = true,
            },
        },
    }

    telescope.load_extension "file_browser"
end

function M.init()
    local nmap = require('tmthy.utils').nmap
    local ts = require('telescope.builtin')

    -- "s" for search, e.g. "sf" => "search files"
    nmap('<leader><space>', function()
        if vim.loop.fs_stat(".git") then
            ts.git_files()
        else
            local opts = {}
            local client = vim.lsp.get_active_clients()[1]

            if client then
                opts.cwd = client.config.root_dir
            end

            ts.find_files(opts)
        end
    end, "Search Files")

    nmap('<leader>sg', ts.git_files, "Search Git Files")
    nmap('<leader>sr', ts.oldfiles, "Search Recent Files")
    nmap('<leader>sk', ts.keymaps, "Search Keymaps")

    nmap('<leader>sd', ts.diagnostics, "Search Diagnostic Messages")

    nmap('<leader>s\'', ts.registers, "Search Registers")
    nmap('<leader>sh', ts.help_tags, "Search Help Tags")

    nmap('<leader>sb', ts.buffers, "Search Active Buffers")

    local file_browser = require('telescope').extensions.file_browser

    nmap('<leader>ff', function() file_browser.file_browser { files = true } end, 'Open File Browser')
    nmap('<leader>fb', function() file_browser.file_browser { files = false } end, 'Open Folder Browser')
end

return M
