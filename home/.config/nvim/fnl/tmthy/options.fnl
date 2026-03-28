(set vim.g.code_dir (vim.fn.expand "~/code"))

(set vim.opt.breakindent true)

(set vim.opt.ignorecase true)
(set vim.opt.smartcase true)

(set vim.opt.updatetime 250)
(set vim.opt.timeoutlen 300)

(set vim.opt.number true)
(set vim.opt.showmode false)

(set vim.opt.scrolloff 10)
(set vim.opt.cursorline true)

(set vim.opt.wrap false)

(set vim.opt.tabstop 2)
(set vim.opt.shiftwidth 4)

(set vim.opt.signcolumn "number")
(set vim.opt.laststatus 3)

(set vim.opt.sessionoptions ["curdir" "folds" "help" "tabpages" "winsize"])

(set vim.opt.foldmethod "manual")

(let [augroup (vim.api.nvim_create_augroup :tmthy_options {:clear true})]
  (vim.api.nvim_create_autocmd :ModeChanged
                 {:pattern ["i:*" "*:i"]
                  :callback (fn [ev] (set vim.opt.cursorline (vim.startswith ev.match "i")))
                  :group augroup}))

