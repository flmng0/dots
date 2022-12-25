local M = {
    'nvim-lualine/lualine.nvim'
}

function M.config()
    require('lualine').setup {
        options = {
            icons_enabled = true,
            theme = 'onedark',
            component_separators = '|',
            sections_separators = '',
            disabled_filetypes = { 'NvimTree' },
        },
    }
end

return M
