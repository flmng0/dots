return {
    'folke/todo-comments.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },

    config = true,

    init = function()
        local nmap = require('tmthy.utils').nmap
        local todo = require('todo-comments')

        nmap(']t', function() todo.jump_next() end, 'Jump to Next TODO Comment')
        nmap('[t', function() todo.jump_prev() end, 'Jump to Previous TODO Comment')
    end
}
