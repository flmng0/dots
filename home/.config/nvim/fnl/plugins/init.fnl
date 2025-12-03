[;; auto-detect indentation
 :tpope/vim-sleuth
 ;; Icon support for multiple plugins
 {1 :echasnovski/mini.icons :config true}
 ;; File browser / editor
 {1 :stevearc/oil.nvim :dependencies [:echasnovski/mini.icons] :config true}
 ;; Fuzzy finder plugin. Similar to Telescope
 {1 :ibhagwan/fzf-lua :dependencies [:echasnovski/mini.icons] :config true}
 ;; Tree-sitter based auto-tags
 {1 :windwp/nvim-ts-autotag
  :dependencies [:nvim-treesitter/nvim-treesitter]
  :opts {:opts {:enable_close true
                :enable_rename true
                :enable_close_on_slash true}}}
 ;; using windwp's autopairs instead of mini.pairs for HTML tag indentation on <CR>
 {1 :windwp/nvim-autopairs :opts {:map_cr true}}
 ;; Changes some default UI elements such as select and rename
 {1 :stevearc/dressing.nvim
  :opts {:input {:border "single"} :select {:builtin {:border "none"}}}}
 ;; Add's structural editing commands
 {1 :dundalek/parpar.nvim
  :dependencies [:gpanders/nvim-parinfer :julienvincent/nvim-paredit]
  :config true}

 {1 :ggandor/leap.nvim
  :dependencies [:tpope/vim-repeat]}]

;; TODO: Nvim-dap 
