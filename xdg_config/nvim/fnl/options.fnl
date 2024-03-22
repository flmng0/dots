(fn set-all [tbl vals]
  (each [k v (pairs vals)] (tset tbl k v)))

(tset vim.g :mapleader " ")
(tset vim.g :maplocalleader " ")

(set-all vim.opt {:number true
                  :relativenumber true
                  :clipboard :unnamedplus
                  :ignorecase true
                  :smartcase true
                  :signcolumn :auto
                  :updatetime 250
                  :timeoutlen 300
                  :inccommand :split
                  :cursorline true
                  :scrolloff 7
                  :tabstop 2
                  :shiftwidth 2
                  :splitright true
                  :splitbelow true
                  :hlsearch true})

(vim.keymap.set :n :<Esc> :<cmd>nohlsearch<CR>)

(vim.keymap.set :n :gs "^")
(vim.keymap.set :n :gl "$")

(vim.keymap.set :i :jk :<Esc>)
