return {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'j-hui/fidget.nvim',

        -- Formatters
        'jose-elias-alvarez/null-ls.nvim',

        {
            'b0o/SchemaStore.nvim',
            version = false,
        },

        -- NeoVim lua runtime in NeoVim
        'folke/neodev.nvim',

        -- Rust!
        {
            'simrat39/rust-tools.nvim',
            dependencies = {
                'nvim-lua/plenary.nvim',
                'mfussenegger/nvim-dap',
            },
        },

        -- Flutter!
        {
            'akinsho/flutter-tools.nvim',
            lazy = false,
            dependencies = {
                'nvim-lua/plenary.nvim',
                'stevearc/dressing.nvim',
            },
        },

        -- TypeScript!
        {
            'jose-elias-alvarez/typescript.nvim',
        },
    },

    config = function()
        -- setup neovim library completions
        require('neodev').setup()

        local servers = require('plugins.lsp.servers')

        local use_windows_thing = false
        if use_windows_thing then
            servers.rust_analyzer.settings['rust-analyzer'].cargo = {
                features = 'all',
                target = 'x86_64-pc-windows-gnu',
            }
        end

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

        require('mason').setup {
            ui = {
                border = 'single',
            },
        }

        local mlsp = require('mason-lspconfig')
        mlsp.setup {
            ensure_installed = vim.tbl_keys(servers),
        }

        local on_attach = require('plugins.lsp.actions').on_attach

        local default_opts = {
            on_attach = on_attach,
            capabilities = capabilities,
        }

        local function get_opts(server_name)
            local server_opts = servers[server_name]
            return vim.tbl_deep_extend('force', default_opts, server_opts or {})
        end

        mlsp.setup_handlers {
            function(server_name)
                local opts = get_opts(server_name)

                require('lspconfig')[server_name].setup(opts)
            end,

            ['rust_analyzer'] = function()
                local opts = get_opts('rust_analyzer')

                require('rust-tools').setup {
                    inlay_hints = {
                        auto = true,
                        only_current_line = false,
                        show_parameter_hints = true,
                        parameter_hints_prefix = ': ',
                        other_hints_prefix = '=> ',
                        max_len_align = false,
                        -- max_len_align_padding = 1,
                        right_align = false,
                        -- right_align_padding = 1,
                        highlight = 'Comment',
                    },
                    server = opts,
                }
            end,

            ['tsserver'] = function()
                local opts = get_opts('tsserver')

                require('typescript').setup {
                    server = opts,
                }
            end,
        }

        require('flutter-tools').setup {
            decorations = { device = true },
            lsp = {
                on_attach = on_attach,
                capabilities = capabilities,
            },
        }

        require('fidget').setup {}

        local nls = require('null-ls')
        nls.setup {
            debug = true,
            log_level = 'debug',
            sources = {
                nls.builtins.formatting.prettierd.with {
                    extra_filetypes = { 'svelte' },
                },
                -- nls.builtins.formatting.eslint_d.with {
                --     extra_filetypes = { 'svelte' },
                -- },
                nls.builtins.formatting.stylua,
                require('typescript.extensions.null-ls.code-actions'),
            },
        }
    end,
}
