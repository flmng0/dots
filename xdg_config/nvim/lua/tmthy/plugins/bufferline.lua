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
            offsets = {
                filetype = 'NvimTree',
                text = function()
                    local cwd = vim.fn.getcwd()
                    local home = vim.fn.expand("$HOME")

                    return cwd:gsub(home, "~")
                end,
                text_align = 'left',
            },
        }
    }
end

return M

