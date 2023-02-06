return {
    'akinsho/toggleterm.nvim',
    version = '*',

    opts = function()
        require('toggleterm').setup {
            open_mapping = [[<A-Space>]],
            direction = 'float',
            shading_factor = '2',
            float_opts = {
                winblend = 3,
            },
        }
    end,
}
