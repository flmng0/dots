local bufferline = require('bufferline')

bufferline.setup {
    options = {
        separator_style = 'thin',
        diagnostics = 'nvim_lsp',
        always_show_bufferline = true,
        offsets = {
            {
                filetype = 'NvimTree',
                text = 'File Explorer',
                text_align = 'center',
                highlight = 'NvimTreeRootFolder',
                separator = true
            }
        },
    }
}

vim.keymap.set('n', '<leader>q', function()
    local old = vim.api.nvim_get_current_buf()
    bufferline.cycle(1)
    vim.api.nvim_buf_delete(old, {})
end)
