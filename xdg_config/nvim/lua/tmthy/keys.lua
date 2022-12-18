-- Key mappings that don't require plugins 

local map = vim.keymap.set
local api = vim.api

map({'n','v'}, '<Space>', '<Nop>', { silent = true })

map('n', '<leader>q', function() api.nvim_buf_delete() end)

map('i', 'jk', '<Esc>')


-- Key mappings that do require plugins

local ts = require('telescope.builtin')

-- "s" for search, e.g. "sf" => "search files"
map('n', '<leader>sf', ts.find_files)
map('n', '<leader>sg', ts.git_files)
map('n', '<leader>sr', ts.oldfiles)

map('n', '<leader>sd', ts.diagnostics)

map('n', '<leader>s\'', ts.registers)
map('n', '<leader>sh', ts.help_tags)

-- LSP keybinds are only for buffers where a language-server has loaded
local on_attach = function(client, bufnr)
    local nmap = function(keys, func, desc)
        map('n', keys, func, { buffer = bufnr, desc = desc, remap = false })
    end

    -- Source [a]ctions
    nmap('<leader>ar', vim.lsp.buf.rename, 'LSP: Rename Symbol')
    nmap('<leader>av', vim.lsp.buf.code_action, 'LSP: View Code Actions')

    -- [g]oto commands
    nmap('<leader>gd', vim.lsp.buf.definition, 'LSP: Goto Definition')
    nmap('<leader>gD', vim.lsp.buf.declaration, 'LSP: Goto Decleration')
    nmap('<leader>gr', ts.lsp_references, 'LSP: Goto References')
    nmap('<leader>gi', vim.lsp.buf.implementation, 'LSP: Goto Implementation')
    nmap('<leader>gt', vim.lsp.buf.type_definition, 'LSP: Goto Type Definition')

    -- search document symbols
    nmap('<leader>ss', ts.lsp_document_symbols, 'LSP: View Document Symbols')
end

return {
    on_attach = on_attach
}
