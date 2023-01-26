return {
    'rebelot/kanagawa.nvim',
    lazy = false,
    priority = 1000,

    config = function()
        local colors = require('kanagawa.colors').setup()
        local prompt = colors.bg_light1

        require('kanagawa').setup {
            terminalColors = false,

            overrides = {
                TelescopeNormal = {
                    bg = colors.bg_light0,
                    fg = colors.fg_light0,
                },
                TelescopeBorder = {
                    bg = colors.bg_light0,
                    fg = colors.bg_light0,
                },
                TelescopePromptNormal = {
                    bg = prompt,
                },
                TelescopePromptBorder = {
                    bg = prompt,
                    fg = prompt,
                },
                TelescopePromptTitle = {
                    bg = prompt,
                    fg = prompt,
                },
                TelescopePreviewTitle = {
                    bg = colors.bg_light0,
                    fg = colors.bg_light0,
                },
                TelescopeResultsTitle = {
                    bg = colors.bg_light0,
                    fg = colors.bg_light0,
                },
            }
        }

        require('kanagawa').load()
    end,
}
