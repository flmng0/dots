return {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'j-hui/fidget.nvim',

        -- Formatters
        'jose-elias-alvarez/null-ls.nvim',
        'jay-babu/mason-null-ls.nvim',

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

        -- TypeScript!
        {
            'jose-elias-alvarez/typescript.nvim',
        },
    },

    config = function()
        -- setup neovim library completions
        require('neodev').setup()

        local css_langs = {
            'aspnetcorerazor',
            'astro',
            'astro-markdown',
            'html',
            'markdown',
            'mdx',
            'css',
            'less',
            'postcss',
            'sass',
            'scss',
            'javascript',
            'javascriptreact',
            'typescript',
            'typescriptreact',
            'svelte',
            'vue',
        }

        local servers = {
            clangd = {},
            lua_ls = {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'awesome', 'client', 'root', 'screen' },
                        },
                        workspace = {
                            library = {
                                -- AwesomeWM runtime
                                '/usr/share/awesome/lib',
                            },
                            checkThirdParty = false,
                        },
                        telemetry = { enable = false },
                    },
                },
            },
            jsonls = {
                on_new_config = function(new_config)
                    new_config.settings.json.schemas = new_config.settings.json.schemas or {}
                    local new_schemas = require('schemastore').json.schemas()
                    vim.list_extend(new_config.settings.json.schemas, new_schemas, 1, #new_schemas)
                end,
                settings = {
                    json = {
                        format = {
                            enable = true,
                        },
                        validate = {
                            enabled = true,
                        },
                    },
                },
            },
            gopls = {},
            svelte = {},
            tailwindcss = {
                filetypes = css_langs,
            },

            -- These below servers either have custom logic, or are setup by their
            -- respective plugins, however, since we're using mason-lspconfig, the
            -- servers can still be configured here.

            -- Setup is done by typescript.nvim
            tsserver = {},
            -- Setup is done by rust-tools
            rust_analyzer = {
                cmd = { 'rustup', 'run', 'nightly', 'rust-analyzer' },
                settings = {
                    ['rust-analyzer'] = {
                        rustfmt = {
                            extraArgs = {
                                '+nightly',
                            },
                        },
                    },
                },
            },
        }

        local use_windows_thing = false
        if use_windows_thing then
            servers.rust_analyzer.settings['rust-analyzer'].cargo = {
                features = 'all',
                target = 'x86_64-pc-windows-gnu',
            }
        end

        local formatters = {
            'stylua',
            'prettierd',
        }

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

        require('mason-null-ls').setup {
            ensure_installed = formatters,
            automatic_installation = false,
            handlers = {},
        }

        local on_attach = function(client, buf)
            require('plugins.lsp.format').on_attach(client, buf)
            require('plugins.lsp.actions').on_attach(client, buf)
        end

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

        require('fidget').setup {}

        local nls = require('null-ls')
        nls.setup {
            sources = {
                nls.builtins.formatting.prettierd.with {
                    extra_filetypes = { 'svelte' },
                },
                nls.builtins.formatting.stylua,
                require('typescript.extensions.null-ls.code-actions'),
            },
        }
    end,
}
