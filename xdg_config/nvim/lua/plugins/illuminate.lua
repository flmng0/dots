return {
    'RRethy/vim-illuminate',
    -- Kind of annoying me more than anything.
    -- Will look into it more though.
    enabled = false,

    config = function()
        require('illuminate').configure {
            filetypes_denylist = { 'NvimTree', 'alpha' },
        }
    end,
}
