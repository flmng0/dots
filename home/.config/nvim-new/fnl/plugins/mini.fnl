(import-macros {: plugin-setup} :macros)

{1 :echasnovski/mini.nvim
 :version false
 :config (fn []
           (plugin-setup :mini.surround {:respect_selection_type true})
           (plugin-setup :mini.move {})
           (plugin-setup :mini.git {})
           (plugin-setup :mini.diff {}))}

;; TODO: Setup starter and sessions
           
