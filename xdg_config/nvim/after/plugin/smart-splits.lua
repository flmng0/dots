local splits = require('smart-splits')

splits.setup {
    tmux_integration = false,
}

local nmap = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { desc = desc })
end
nmap('<leader>r', splits.start_resize_mode, "Start Resize Mode")

nmap('<C-h>', splits.move_cursor_left)
nmap('<C-j>', splits.move_cursor_down)
nmap('<C-k>', splits.move_cursor_up)
nmap('<C-l>', splits.move_cursor_right)
