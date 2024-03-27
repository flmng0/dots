; mini.nvim is incredible and I would use it for everything if
; I didn't want Telescope.
{1 :echasnovski/mini.nvim
 :version false
 :config (fn []
           (let [plugins [:starter
                          :statusline
                          :surround
                          :indentscope
                          :comment
                          :splitjoin
                          :pairs
                          :files]]
             (each [_ plugin (ipairs plugins)]
               ((. (require (.. :mini. plugin)) :setup)))
             (vim.keymap.set :n :<leader>e
                             (fn []
                               (if (not (_G.MiniFiles.close))
                                   (_G.MiniFiles.open))))))}

