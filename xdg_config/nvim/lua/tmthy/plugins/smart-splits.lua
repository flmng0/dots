local M = {
    'mrjones2014/smart-splits.nvim',
}

function M.config()
    require('smart-splits').setup {
        tmux_integration = false,
    }
end

function M.init()
    local splits = require('smart-splits')

    local nmap = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { desc = desc })
    end

    nmap('<leader>r', splits.start_resize_mode, "Start Resize Mode")

    nmap('<C-h>', splits.move_cursor_left)
    nmap('<C-j>', splits.move_cursor_down)
    nmap('<C-k>', splits.move_cursor_up)
    nmap('<C-l>', splits.move_cursor_right)
end

return M

