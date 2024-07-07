; mini.nvim is incredible and I would use it for everything if
; I didn't want Telescope.
(local plugins {:starter {}
                :statusline {}
                :surround {}
                :indentscope {}
                :comment {}
                :splitjoin {}
                :pairs {}
                :files {}
                :completion {}})

(fn toggle-files []
  (if (not (_G.MiniFiles.close))
      (_G.MiniFiles.open)))

(fn cr []
  (vim.notify :Test)
  (if (= 0 (vim.fn.pumvisible))
      ((. (require :mini.pairs) :cr))
      (let [item-selected (= -1 (. (vim.fn.complete_info) :selected))]
        (if item-selected
            (vim.keycode :<C-y><CR>)
            (vim.keycode :<C-y>)))))

{1 :echasnovski/mini.nvim
 :lazy false
 :version false
 :keys [[:<leader>e toggle-files]]
 :config (fn []
           (each [name opts (pairs plugins)]
             ((. (require (.. :mini. name)) :setup) opts))
           (vim.keymap.set :i :<CR> cr {:expr true}))}
