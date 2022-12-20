-- Key mappings that don't require plugins

local map = vim.keymap.set

map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
map('i', '<C-Space>', '<Nop>')

map('i', 'jk', '<Esc>')

map('n', '<leader>]', ':bnext<CR>')
map('n', '<leader>[', ':bprevious<CR>')

