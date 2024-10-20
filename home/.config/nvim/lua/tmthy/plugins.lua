local keys = require('tmthy.keys')

return {
    -- color scheme
    { 
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd [[ colorscheme kanagawa ]]
        end
    },

    -- auto detect indentation
    "tpope/vim-sleuth",

    -- completion
    {
        'saghen/blink.cmp',
        lazy = false,
        version = 'v0.*',
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            highlight = {
                use_nvim_cmp_as_default = true,
            },
            nerd_font_variant = 'normal',
            keymap = {
                accept = '<C-y>',
            },
        },
    },

    -- telescope for fuzzy finding
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' },
        lazy = true,
    },

    -- oil.nvim for directory editing
    {
        'stevearc/oil.nvim',
        dependencies = { 'echasnovski/mini.icons' },
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {},
    },

    -- mini.icons setup; used by multiple plugins
    { 'echasnovski/mini.icons', config = true },

    -- "thank you folke" everybody says in unison
    { 
        'folke/lazydev.nvim', 
        ft = 'lua',
        config = true
    },

    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'williamboman/mason.nvim', config = true },
            'williamboman/mason-lspconfig.nvim',

            { 'j-hui/fidget.nvim', config = true },
        },
        config = function()
            local default_capabilities = vim.lsp.protocol.make_client_capabilities()

            -- server-name => configuration
            local servers = {
                gopls = {}
            }

            require('mason').setup()

            -- keeping this function seperate for when I need to use a language-specific
            -- plugin as well, like flutter-tools
            local function setup_server(name)
                local config = servers[name] or {}
                config.capabilities = vim.tbl_deep_extend({}, default_capabilities, config.capabilities or {})
                require('lspconfig')[name].setup(config)
            end

            require('mason-lspconfig').setup({
                ensure_installed = vim.tbl_keys(servers),
                handlers = {
                    setup_server,
                }
            })
        end
    }
}
