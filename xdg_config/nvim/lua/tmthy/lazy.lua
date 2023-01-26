
-- # Initialize Lazy.nvim
-- Bootstrap it
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        lazypath,
    })
    vim.fn.system({
        'git',
	'-C',
	lazypath,
	'checkout',
	'tags/stable'
    })
end
vim.opt.runtimepath:prepend(lazypath)

-- Make it do the do
require('lazy').setup('plugins', {
    change_detection = {
        enabled = false,
    },
    install = {
        colorscheme = { 'kanagawa', 'habamax' },
    },
})
