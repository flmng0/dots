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
    astro = {},
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

    elixirls = {},

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

return servers
