local M = {
    'akinsho/bufferline.nvim',
    version = 'v3.*',
    dependencies = {
        'nvim-tree/nvim-web-devicons'
    }
}

function M.config()
    require('bufferline').setup {
        options = {
            separator_style = 'slant',
            diagnostics = 'nvim_lsp',
            show_tab_indicators = false,
            show_close_icon = false,
            always_show_bufferline = false,
        }
    }
end

return M

