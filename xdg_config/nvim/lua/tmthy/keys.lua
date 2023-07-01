local utils = require('tmthy.utils')

utils.vmap('J', [[:m '>+1<CR>gv=gv]], 'Move Selection Down')
utils.vmap('K', [[:m '<-2<CR>gv=gv]], 'Move Selection Up')

utils.imap('<C-Space>', '<Nop>')
utils.imap('jk', '<Esc>', 'Exit Insert Mode')

-- Still not sure why I chose '[' as the key... it just feels right.
utils.nmap('<C-[>', require('harpoon.mark').add_file, 'Add Harpoon File')

local harpoon_buttons = 5

for i = 1, harpoon_buttons do
    local keys = string.format('<leader>%s', i)
    local desc = string.format('Goto Harpooned File #%s', i)

    utils.nmap(keys, function()
        require('harpoon.ui').nav_file(i)
    end, desc)
end

utils.imap('>', function()
    local col = vim.fn.col('.')
    local line = vim.fn.getline('.')

    if line:sub(col - 1, col) == '><' then
        return '<CR><C-o>O'
    end

    return '>'
end, {
    remap = false,
    expr = true,
    desc = 'Maybe insert newline for tag',
})
