-- LSP keybinds are only for buffers where a language-server has loaded
local on_attach = function(_, bufnr)
    local ts = require('telescope.builtin')

    local nmap = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc, remap = false })
    end

    nmap('K', vim.lsp.buf.hover, 'LSP: View Symbol Information')

    -- Source actions
    -- nmap('<leader>r', vim.lsp.buf.rename, 'LSP: Rename Symbol')
    nmap('<leader>a', vim.lsp.buf.code_action, 'LSP: View Code Actions')
    nmap(
        '<leader>f',
        function()
            if vim.lsp.buf.format then
                vim.lsp.buf.format()
            elseif vim.lsp.buf.formatting then
                vim.lsp.buf.formatting()
            end
        end,
        'LSP: Format Current Buffer'
    )

    -- [g]oto commands
    nmap('<leader>gd', vim.lsp.buf.definition, 'LSP: Goto Definition')
    nmap('<leader>gD', vim.lsp.buf.declaration, 'LSP: Goto Decleration')
    nmap('<leader>gr', ts.lsp_references, 'LSP: Goto References')
    nmap('<leader>gi', vim.lsp.buf.implementation, 'LSP: Goto Implementation')
    nmap('<leader>gt', vim.lsp.buf.type_definition, 'LSP: Goto Type Definition')

    -- search document symbols
    nmap('<leader>s', ts.lsp_document_symbols, 'LSP: Search Document Symbols')
    nmap('<leader>w', ts.lsp_workspace_symbols, 'LSP: Search Workspace Symbols')
end

return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',

        'folke/neodev.nvim',

        'j-hui/fidget.nvim',
    },

    on_attach = on_attach,

    config = function()
        local servers = {
            clangd = {},
            tsserver = {},
            sumneko_lua = {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'awesome', 'client', 'root', 'screen' }
                        },
                        workspace = {
                            library = {
                                -- AwesomeWM runtime
                                '/usr/share/awesome/lib'
                            },
                            checkThirdParty = false
                        },
                        telemetry = { enable = false }
                    }
                }
            },
            -- Setup is done by rust-tools
            -- rust_analyzer = {},
            gopls = {},
            svelte = {},
            tailwindcss = {
                filetypes = {
                    'aspnetcorerazor', 'astro', 'astro-markdown', 'html', 'markdown', 'mdx', 'css', 'less',
                    'postcss', 'sass', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'svelte',
                    'vue'
                }
            }
        }

        -- setup neovim library completions
        require('neodev').setup()

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

        require('mason').setup {
            ui = {
                border = "single",
            }
        }

        local mason_lspconfig = require('mason-lspconfig')
        mason_lspconfig.setup {
            ensure_installed = vim.tbl_keys(servers),
        }

        local default_opts = {
            on_attach = on_attach,
            capabilities = capabilities,
        }

        for server_name, server_opts in pairs(servers) do
            local opts = vim.tbl_deep_extend('force', default_opts, server_opts)

            require('lspconfig')[server_name].setup(opts)
        end

        require('fidget').setup {}
    end
}
