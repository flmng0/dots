local config = function()
    require('lualine').setup {
        options = {
            icons_enabled = true,
            theme = 'tokyonight',
            component_separators = '|',
            sections_separators = '',
        },
    }
end

return config
