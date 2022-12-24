-- Key mappings that don't require plugins

local map = vim.keymap.set

map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
map('i', '<C-Space>', '<Nop>')

map('i', 'jk', '<Esc>')

map('n', '<leader>]', ':bnext<CR>')
map('n', '<leader>[', ':bprevious<CR>')

-- Key mappings that do require plugins

local bufferline = require('bufferline')
local ts = require('telescope.builtin')
local tree = require('nvim-tree.api').tree

map('n', '<leader>fn', tree.open, { desc = "Open File Tree" })
map('n', '<leader>ff', tree.focus, { desc = "Open and Focus File Tree" })
map('n', '<leader>fd', tree.close, { desc = 'Close File Tree' })

-- "s" for search, e.g. "sf" => "search files"
map('n', '<leader>sf', ts.find_files)
map('n', '<leader>sg', ts.git_files)
map('n', '<leader>sr', ts.oldfiles)
map('n', '<leader>sk', ts.keymaps)

map('n', '<leader>sd', ts.diagnostics)

map('n', '<leader>s\'', ts.registers)
map('n', '<leader>sh', ts.help_tags)

vim.keymap.set('n', '<leader>q', function()
    local old = vim.api.nvim_get_current_buf()
    bufferline.cycle(1)
    vim.api.nvim_buf_delete(old, {})
end)
