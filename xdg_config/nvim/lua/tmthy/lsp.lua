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
local on_attach = require('tmthy.keys').on_attach

for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities
    }
end

require('fidget').setup()
