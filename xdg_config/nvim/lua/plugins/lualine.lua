return {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',

    config = function()
        require('lualine').setup {
            options = {
                icons_enabled = true,
                theme = 'auto',
                globalstatus = true,
                disabled_filetypes = {
                    'NvimTree',
                    'alpha',
                },

                component_separators = '',
                section_separators = { left = '', right = '' },
            },
            sections = {
                -- Left
                lualine_a = { 'mode' },
                lualine_b = {
                    'branch',
                    'diff',
                },
                lualine_c = {
                    { 'filename', path = 1 },
                },

                -- Right
                lualine_x = {
                    { 'searchcount', icon = '' },
                    'filetype',
                },
                lualine_y = { 'progress' },
                lualine_z = {
                    'location',
                },
            }
        }
    end,
}
