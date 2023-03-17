-- Taken straight from: https://github.com/b0o/incline.nvim/discussions/31
local function get_diagnostics(props)
    local icons = require('tmthy.icons').diagnostics

    local result = {}
    for severity, icon in pairs(icons) do
        local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
        if n > 0 then
            table.insert(result, { icon .. ' ' .. n .. ' ', group = 'DiagnosticSign' .. severity })
        end
    end
    return result
end

return {
    'b0o/incline.nvim',
    event = 'BufReadPre',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        'rebelot/kanagawa.nvim',
    },

    config = function()
        local colors = require('kanagawa.colors').setup()

        local focused = {
            guifg = colors.fg,
            guibg = colors.bg_dark,
        }

        local unfocused = {
            guifg = colors.fg_comment,
            guibg = colors.bg_dim,
        }

        local end_characters = {
            left = '',
            right = '',
        }
        local end_padding_count = 1
        local padding_char = ' '

        require('incline').setup {
            render = function(props)
                local bufname = vim.api.nvim_buf_get_name(props.buf)
                local filename = vim.fn.fnamemodify(bufname, ':t')
                local modified = vim.api.nvim_buf_get_option(props.buf, 'modified')
                local has_focus = props.focused

                -- Get file-type icon, and respective color.
                local filetype_icon, color = require('nvim-web-devicons').get_icon_color(filename)

                -- Get diagnostics icons.
                local diagnostics = get_diagnostics(props)

                -- Start constructing the resulting widgets.
                local result = {
                    { filetype_icon, guifg = has_focus and color or nil },
                    padding_char,
                    { filename, gui = 'italic,bold' },
                    modified and { padding_char .. '●' } or nil
                }

                -- If there were diagnostics, then add them to the result.
                if #diagnostics > 0 then
                    table.insert(result, 1, { '| ', guifg = colors.fujiGray })
                    table.insert(result, 1, diagnostics)
                end

                -- Surround the result with ending characters configured above.
                local ending_fg = has_focus and focused.guibg or unfocused.guibg
                local end_padding = string.rep(padding_char, end_padding_count)

                return {
                    { end_characters.left, guifg = ending_fg, guibg = 'bg' },
                    { end_padding },
                    result,
                    { end_padding },
                    { end_characters.right, guifg = ending_fg, guibg = 'bg' },
                }
            end,
            window = {
                margin = { vertical = 0, horizontal = 1 },
                padding = { left = 0, right = 0 },
            },
            highlight = {
                groups = {
                    InclineNormal = focused,
                    InclineNormalNC = unfocused,
                }
            },
            ignore = {
                filetypes = { 'NvimTree' },
            },
            hide = {
                cursorline = 'focused_win',
            },
        }
    end,
}
