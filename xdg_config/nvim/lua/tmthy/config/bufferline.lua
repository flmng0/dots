local bufferline = require('bufferline')

bufferline.setup {
    options = {
        separator_style = 'slant',
        diagnostics = 'nvim_lsp',
        show_tab_indicators = false,
        show_close_icon = false,
        always_show_bufferline = true,
        offsets = {
            {
                filetype = 'NvimTree',
                text = function()
                    local cwd = vim.fn.getcwd()
                    local home = vim.fn.expand("$HOME")

                    return cwd:gsub(home, "~")
                end,
                text_align = 'left',
                highlight = 'NvimTreeRootFolder',
                separator = true
            }
        },
    }
}

