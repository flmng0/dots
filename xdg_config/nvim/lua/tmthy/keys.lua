local utils = require('tmthy.utils')

utils.vmap('J', [[:m '>+1<CR>gv=gv]], 'Move Selection Down')
utils.vmap('K', [[:m '<-2<CR>gv=gv]], 'Move Selection Up')

utils.imap('<C-Space>', '<Nop>')

utils.imap('jk', '<Esc>', 'Exit Insert Mode')

utils.nmap('<leader>q', function()
    vim.api.nvim_buf_delete(0, {})
end, 'Close Current Buffer')
utils.nmap('<leader>Q', function()
    vim.api.nvim_buf_delete(0, { force = true })
end, 'Force Close Current Buffer')

local bufferline = require('bufferline')
utils.nmap('<C-]>', function() bufferline.cycle(1) end, 'Open Next Buffer')
utils.nmap('<C-[>', function() bufferline.cycle(-1) end, 'Open Previous Buffer')
