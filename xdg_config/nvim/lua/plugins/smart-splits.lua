return {
    'mrjones2014/smart-splits.nvim',

    opts = {
        tmux_integration = false,
    },

    init = function()
        local splits = require('smart-splits')

        local nmap = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { desc = desc })
        end

        nmap('<A-h>', splits.resize_left, 'Resize Window Left')
        nmap('<A-j>', splits.resize_down, 'Resize Window Below')
        nmap('<A-k>', splits.resize_up, 'Resize Window Above')
        nmap('<A-l>', splits.resize_right, 'Resize Window Right')

        nmap('<C-h>', splits.move_cursor_left, 'Move To Window Left')
        nmap('<C-j>', splits.move_cursor_down, 'Move To Window Below')
        nmap('<C-k>', splits.move_cursor_up, 'Move To Window Above')
        nmap('<C-l>', splits.move_cursor_right, 'Move To Window Right')
    end,
}
