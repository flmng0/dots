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
        command = 'Telescope',
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

    -- lsp setup
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'williamboman/mason.nvim', config = true },
            'williamboman/mason-lspconfig.nvim',

            { 'j-hui/fidget.nvim',       config = true },
        },
        config = function()
            local default_capabilities = vim.lsp.protocol.make_client_capabilities()

            -- server-name => configuration
            local servers = {
                gopls = {},
                lua_ls = {},
                ts_ls = {},
            }

            require('mason').setup()

            -- keeping this function seperate for when I need to use a language-specific
            -- plugin as well, like flutter-tools
            local function setup_server(name)
                local config = servers[name] or {}
                config.capabilities = vim.tbl_deep_extend('force', {}, default_capabilities, config.capabilities or {})
                require('lspconfig')[name].setup(config)
            end

            require('mason-lspconfig').setup({
                ensure_installed = vim.tbl_keys(servers),
                handlers = {
                    setup_server,
                }
            })
        end
    },

    -- conform for file formatting
    {
        'stevearc/conform.nvim',
        opts = {
            format_on_save = {
                timeout = 500,
                lsp_format = "fallback",
            }
        },
    },

    -- treesitter for highlighting and text-objects
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        dependencies = {
            {
                'nvim-treesitter/nvim-treesitter-textobjects',
            }
        },
        config = function()
            local configs = require('nvim-treesitter.configs')

            ---@diagnostic disable-next-line: missing-fields
            configs.setup({
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },

                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,

                        keymaps = {
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",

                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                        },
                    },

                    move = {
                        enable = true,
                        set_jumps = true,

                        goto_next_start = {
                            ["]m"] = { query = "@function.outer", desc = "Goto next function start" },
                            ["]a"] = { query = "@parameter.outer", desc = "Goto next parameter start" },
                            ["]="] = { query = "@assignment.outer", desc = "Goto next assignment start" },
                        },

                        goto_next_end = {
                            ["]M"] = { query = "@function.outer", desc = "Goto next function end" },
                            ["]A"] = { query = "@parameter.outer", desc = "Goto next parameter end" },
                        },

                        goto_previous_start = {
                            ["[m"] = { query = "@function.outer", desc = "Goto previous function start" },
                            ["[a"] = { query = "@parameter.outer", desc = "Goto previous parameter start" },
                            ["[="] = { query = "@assignment.outer", desc = "Goto previous assignment start" },
                        },

                        goto_previous_end = {
                            ["[M"] = { query = "@function.outer", desc = "Goto previous function end" },
                            ["[A"] = { query = "@parameter.outer", desc = "Goto previous parameter end" },
                        }
                    }
                },
            })
        end
    },

    -- mini.nvim plugins... various utilities really
    {
        'echasnovski/mini.nvim',
        version = false,
        config = function()
            -- shorthand
            local function mini_setup(module_name, opts)
                require(module_name).setup(opts or {})
            end

            mini_setup('mini.pairs')
            mini_setup('mini.surround')
            mini_setup('mini.move')
        end
    },
}
