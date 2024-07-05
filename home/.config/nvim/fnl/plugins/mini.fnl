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

{1 :echasnovski/mini.nvim
 :lazy false
 :version false
 :keys [{1 :<leader>e 2 toggle-files}]
 :config (fn []
           (each [name opts (pairs plugins)]
             ((. (require (.. :mini. name)) :setup) opts)))}
