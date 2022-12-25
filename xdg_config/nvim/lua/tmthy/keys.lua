-- Key mappings that don't require plugins
local utils = require('tmthy.utils')
local map = utils.map
local nmap = utils.nmap

map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
map('i', '<C-Space>', '<Nop>')

map('i', 'jk', '<Esc>')

nmap('<leader>]', ':bnext<CR>')
nmap('<leader>[', ':bprevious<CR>')

-- Key mappings that do require plugins
nmap('<leader>q', function()
    local old = vim.api.nvim_get_current_buf()
    require('bufferline').cycle(1)
    vim.api.nvim_buf_delete(old, {})
end)
