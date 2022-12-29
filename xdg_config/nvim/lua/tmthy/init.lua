-- Need to be done very very early!
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '

-- Vim options (vim.opt, etc.)
--
-- Set all vim options before plugin initialization
require('tmthy.options')

-- Load the plugins!
require('tmthy.lazy')

-- After plugins have loaded, load the other modules
--
-- VeryLazy is an event defined by Lazy.nvim, which
-- fires after plugins have loaded.
vim.api.nvim_create_autocmd('User', {
    pattern = 'VeryLazy',
    callback = function()
        -- Key rebinds that don't fit into plugin setups
        require('tmthy.keys')

        -- AutoCmds...
        require('tmthy.autocmds')
    end
})

