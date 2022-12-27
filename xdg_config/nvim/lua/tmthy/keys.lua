local utils = require('tmthy.utils')
local map = utils.map
local nmap = utils.nmap

map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
map('i', '<C-Space>', '<Nop>')

map('i', 'jk', '<Esc>')

nmap('<leader>q', function()
    vim.api.nvim_buf_delete(0, {})
end, 'Close Current Buffer')

local bufferline = require('bufferline')
nmap('<C-]>', function() bufferline.cycle(1) end, 'Open Next Buffer')
nmap('<C-[>', function() bufferline.cycle(-1) end, 'Open Previous Buffer')

