(tset vim.g :code_dir (vim.fn.expand "~/code"))

(tset vim.opt :breakindent true)

(tset vim.opt :ignorecase true)
(tset vim.opt :smartcase true)

(tset vim.opt :updatetime 250)
(tset vim.opt :timeoutlen 300)

(tset vim.opt :number true)
(tset vim.opt :showmode false)

(tset vim.opt :scrolloff 10)
(tset vim.opt :cursorline true)

(tset vim.opt :wrap false)

(tset vim.opt :tabstop 4)
(tset vim.opt :shiftwidth 4)

(tset vim.opt :signcolumn :number)
(tset vim.opt :laststatus 3)

(tset vim.opt :sessionoptions [:curdir :folds :help :tabpages :winsize])

(tset vim.opt :foldmethod :manual)

(let [augroup (vim.api.nvim_create_augroup :tmthy_options {:clear true})]
  (vim.api.nvim_create_autocmd :ModeChanged
                 {:pattern ["i:*" "*:i"]
                  :callback (fn [ev] (tset vim.opt :cursorline (vim.startswith ev.match :i)))
                  :group augroup}))

