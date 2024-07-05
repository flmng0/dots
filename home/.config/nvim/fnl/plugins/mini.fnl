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
  (if (not (_G.MiniFiles))
      (_G.MiniFiles.open)))

{1 :echasnovski/mini.nvim
 :version false
 :keys [{1 :<leader>e 2 toggle-files}]
 :config (fn []
           (each [_ plugin (ipairs plugins)]
             ((. (require (.. :mini. plugin)) :setup))))}
