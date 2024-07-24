[; Make sure to actually track hotpot!
 :rktjmp/hotpot.nvim
 ; Auto indent size and more
 :tpope/vim-sleuth
 ; Parenthesis handling for lisp-like languages
 :gpanders/nvim-parinfer
 ; Conjure!
 {1 :Olical/conjure
  :dependencies [:clojure-vim/vim-jack-in :radenling/vim-dispatch-neovim]}
 ; ColorScheme
 {1 :rebelot/kanagawa.nvim
  :lazy false
  :priority 1000
  :config (fn [] (vim.cmd.colorscheme :kanagawa))}
 ; UI improvements
 {1 :stevearc/dressing.nvim :opts {:select {:enabled false}}}
 {1 :nvim-telescope/telescope.nvim
  :tag :0.1.5
  :dependencies [:nvim-lua/plenary.nvim
                 {1 :nvim-telescope/telescope-fzf-native.nvim :build :make}]
  :opts {}}
 ; Eventually this should be automatically enumerated
 (require :plugins.lspconfig)
 (require :plugins.treesitter)
 (require :plugins.mini)
 (require :plugins.conform)]
