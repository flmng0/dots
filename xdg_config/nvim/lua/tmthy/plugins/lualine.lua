local M = {
    'nvim-lualine/lualine.nvim'
}

function M.config()
    require('lualine').setup {
        options = {
            icons_enabled = true,
            theme = 'auto',
            component_separators = '|',
            sections_separators = '',
        },
    }
end

return M
