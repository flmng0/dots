vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '

require('tmthy.options')

-- Initialize Lazy.nvim
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

require('lazy').setup('tmthy.plugins', {
    change_detection = {
        enabled = false,
    },
    install = {
        colorscheme = { 'tokyonight', 'habamax' },
    },
})


require('tmthy.keys')
require('tmthy.autocmds')

