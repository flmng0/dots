local M = {
    'akinsho/toggleterm.nvim',
    version = '*',
}

function M.config()
    require('toggleterm').setup {
        open_mapping = '<Leader>t',
        direction = 'float',
        float_opts = {
            winblend = 0,
        },
    }
end

return M
