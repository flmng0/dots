local M = {}

local function rust_set_windows(client, opts)
    local rust_opts = {
        cargo = {
            target = 'x86_64-pc-windows-gnu',
        },
    }
    if #opts.args > 0 then
        rust_opts.cargo.features = vim.split(opts.args, ' ', {})
    end

    local config = {
        settings = vim.tbl_deep_extend('force', client.config.settings, {
            ['rust-analyzer'] = rust_opts,
        }),
    }
    client.notify('workspace/didChangeConfiguration', config)
end

-- LSP keybinds are only for buffers where a language-server has loaded
M.on_attach = function(client, bufnr)
    local ts = require('telescope.builtin')

    local nmap = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc, remap = false })
    end

    nmap('K', vim.lsp.buf.hover, 'LSP: View Symbol Information')

    -- Source actions
    -- nmap('<leader>r', vim.lsp.buf.rename, 'LSP: Rename Symbol')
    nmap('<leader>ca', vim.lsp.buf.code_action, 'LSP: View Code Actions')
    nmap('<leader>f', function()
        local buf = vim.api.nvim_get_current_buf()
        require('plugins.lsp.format').format(buf)
    end, 'LSP: Format Current Buffer')

    -- [g]oto commands
    nmap('<leader>gd', vim.lsp.buf.definition, 'LSP: Goto Definition')
    nmap('<leader>gD', vim.lsp.buf.declaration, 'LSP: Goto Decleration')
    -- I use trouble here instead.
    -- nmap('<leader>gr', ts.lsp_references, 'LSP: Goto References')
    nmap('<leader>gi', vim.lsp.buf.implementation, 'LSP: Goto Implementation')
    nmap('<leader>gt', vim.lsp.buf.type_definition, 'LSP: Goto Type Definition')

    -- search document symbols
    nmap('<leader>s', ts.lsp_document_symbols, 'LSP: Search Document Symbols')
    nmap('<leader>w', ts.lsp_workspace_symbols, 'LSP: Search Workspace Symbols')

    if client.name == 'rust_analyzer' then
        vim.api.nvim_buf_create_user_command(bufnr, 'RustWindows', function(opts)
            rust_set_windows(client, opts)
        end, { nargs = '*' })
    end

    if client.name == 'dartls' then
        nmap('<leader>F', function()
            require('plugins.lsp.util').choose_flutter_action()
        end, 'Flutter: Choose Flutter Action')
    end
end

return M
