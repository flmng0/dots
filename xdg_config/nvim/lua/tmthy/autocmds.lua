local api = vim.api

local group = api.nvim_create_augroup('tmthy-augroup', { clear = true })
api.nvim_create_autocmd('TextYankPost', {
    group = group,
    callback = function()
        vim.highlight.on_yank()
    end
})
