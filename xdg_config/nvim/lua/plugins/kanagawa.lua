local M = {
    'rebelot/kanagawa.nvim',
    lazy = false,
    pin = true,
}

function M.config()
    local defaults = require('kanagawa.colors').setup()
    local prompt = defaults.bg_light1

    require('kanagawa').setup {
        overrides = {
            TelescopeNormal = {
                bg = defaults.bg_light0,
                fg = defaults.fg_light0,
            },
            TelescopeBorder = {
                bg = defaults.bg_light0,
                fg = defaults.bg_light0,
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
                bg = defaults.bg_light0,
                fg = defaults.bg_light0,
            },
            TelescopeResultsTitle = {
                bg = defaults.bg_light0,
                fg = defaults.bg_light0,
            },
        }
    }

    vim.cmd [[colorscheme kanagawa]]
end

return M
