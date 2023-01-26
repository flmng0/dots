return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',

        'j-hui/fidget.nvim',
    },

    config = function()
        local ts = require('telescope.builtin')

        -- LSP keybinds are only for buffers where a language-server has loaded
        local on_attach = function(_, bufnr)
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

        require('mason').setup {
            ui = {
                border = "single",
            }
        }

        local servers = {
            clangd = {},
            rust_analyzer = {},
            tsserver = {},
            sumneko_lua = {},
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

        local server_names = {}
        for lsp, _ in pairs(servers) do
            server_names[#server_names + 1] = lsp
        end

        require('mason-lspconfig').setup {
            ensure_installed = server_names,
        }

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

        local lspconfig = require('lspconfig')

        for lsp, opts in pairs(servers) do
            local real_opts = vim.tbl_deep_extend('force', {
                on_attach = on_attach,
                capabilities = capabilities,
            }, opts)
            lspconfig[lsp].setup(real_opts)
        end

        -- Setup vim lua stuff
        local rtp = vim.split(package.path, ';')
        table.insert(rtp, 'lua/?.lua')
        table.insert(rtp, 'lua/?/init.lua')

        lspconfig.sumneko_lua.setup {
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
                Lua = {
                    runtime = {
                        version = 'LuaJIT',
                        path = rtp
                    },
                    diagnostics = {
                        globals = { 'vim' }
                    },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file('', true),
                        checkThirdParty = false
                    },
                    telementry = { enable = false }
                }
            }
        }

        require('fidget').setup {}
    end
}
