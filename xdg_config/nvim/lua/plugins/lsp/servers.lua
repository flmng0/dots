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
    'heex',
    'elixir',
}

local root_pattern = require('lspconfig.util').root_pattern

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
        init_options = {
            userLanguages = {
                elixir = 'phoenix-heex',
                heex = 'phoenix-heex',
                -- svelte = "html",
            },
        },
        includeLanguages = {
            ['phoenix-heex'] = 'html',
        },
        root_dir = root_pattern(
            'tailwind.config.js',
            'tailwind.config.mjs',
            'tailwind.config.cjs',
            'tailwind.config.ts'
        ),
    },

    cssls = {},

    unocss = {
        filetypes = css_langs,
    },

    emmet_ls = {
        init_options = {
            jsx = {
                options = {
                    ['markup.attributes'] = {
                        ['className'] = 'class',
                    },
                },
            },
        },
        filetypes = {
            'html',
            'svelte',
            'heex',
            'typescriptreact',
            'javascriptreact',
        },
    },

    elixirls = {},

    denols = {
        root_dir = root_pattern('deno.json'),
    },

    -- These below servers either have custom logic, or are setup by their
    -- respective plugins, however, since we're using mason-lspconfig, the
    -- servers can still be configured here.

    -- Setup is done by typescript.nvim
    tsserver = {
        root_dir = root_pattern('package.json', 'package.jsonc'),
        single_file_support = false,
    },

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
