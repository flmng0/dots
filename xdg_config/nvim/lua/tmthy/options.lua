local M = {}

local opt = vim.opt

function M.set_format_options()
    opt.formatoptions = opt.formatoptions
        - 't'
        + 'c'
        + 'r'
        - 'o'
        - '/'
        + 'q'
        - 'w'
        - 'a'
        - 'n'
        - '2'
        - 'v'
        - 'b'
        - 'l'
        - 'm'
        - 'M'
        - 'B'
        - '1'
        - ']'
        + 'j'
        - 'p'
end

M.set_format_options()

opt.guicursor = 'i:ver100'

opt.background = 'dark'
opt.termguicolors = true

opt.number = true
opt.relativenumber = true
opt.signcolumn = 'yes'

opt.cursorline = true

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.smartindent = true

opt.wrap = false

opt.hlsearch = false
opt.incsearch = true

opt.scrolloff = 8

opt.completeopt = { 'menu', 'menuone', 'preview', 'noinsert' }

opt.mouse = 'a'

vim.g.switchbuf = 'vsplit'

vim.g.loaded_netrw = true
vim.g.loaded_netrwPlugin = true

return M
