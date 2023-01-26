local options = require('tmthy.options')
local api = vim.api

local general_group = api.nvim_create_augroup('tmthy-augroup', { clear = true })
api.nvim_create_autocmd('TextYankPost', {
    group = general_group,
    callback = function()
        vim.highlight.on_yank()
    end
})

-- Set the formatoptions for every language.
api.nvim_create_autocmd('FileType', {
    group = general_group,
    pattern = '*',
    callback = function()
        options.set_format_options()
    end,
})
