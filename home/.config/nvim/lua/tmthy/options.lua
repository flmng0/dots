vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.g.code_dir = vim.fn.expand('~/code')

vim.opt.breakindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.number = true
vim.opt.showmode = false

vim.opt.scrolloff = 10
vim.opt.cursorline = true

vim.opt_global.tabstop = 4
vim.opt_global.shiftwidth = 4

vim.opt.signcolumn = 'number'
vim.opt.laststatus = 3

local augroup = vim.api.nvim_create_augroup('tmthy_options', { clear = true })

vim.api.nvim_create_autocmd('ModeChanged', {
	pattern = { 'i:*', '*:i' },
	callback = function(ev)
		vim.opt.cursorline = vim.startswith(ev.match, 'i')
	end,
	group = augroup,
})
