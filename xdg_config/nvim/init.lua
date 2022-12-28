-- Need to be done very very early!
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '

-- # Initialize Lazy.nvim
-- Bootstrap it
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        '--single-branch',
        'https://github.com/folke/lazy.nvim.git',
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

-- Make it do the do
require('lazy').setup('plugins', {
    change_detection = {
        enabled = false,
    },
    install = {
        colorscheme = { 'tokyonight', 'habamax' },
    },
})

require("tmthy")
