local ts = require('telescope.builtin')

-- LSP keybinds are only for buffers where a language-server has loaded
local on_attach = function(_, bufnr)
    local nmap = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc, remap = false })
    end

    -- Source [a]ctions
    nmap('<leader>ar', vim.lsp.buf.rename, 'LSP: Rename Symbol')
    nmap('<leader>av', vim.lsp.buf.code_action, 'LSP: View Code Actions')
    nmap(
        '<leader>af',
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
    nmap('<leader>ss', ts.lsp_document_symbols, 'LSP: View Document Symbols')
end

require('mason').setup()

local servers = {
    'clangd',
    'rust_analyzer',
    'tsserver',
    'sumneko_lua',
    'gopls'
}

require('mason-lspconfig').setup {
    ensure_installed = servers,
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local lspconfig = require('lspconfig')

for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities
    }
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

require('fidget').setup()
