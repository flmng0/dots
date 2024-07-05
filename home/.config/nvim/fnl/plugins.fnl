[; Make sure to actually track hotpot!
 :rktjmp/hotpot.nvim
 ; Auto indent size and more
 :tpope/vim-sleuth
 ; Parenthesis handling for lisp-like languages
 :gpanders/nvim-parinfer
 ; Conjure!
 :Olical/conjure
 ; ColorScheme
 {1 :rebelot/kanagawa.nvim
  :lazy false
  :priority 1000
  :config (fn [] (vim.cmd.colorscheme :kanagawa))}
 ; UI improvements
 {1 :stevearc/dressing.nvim :opts {:select {:enabled false}}}
 ; Eventually this should be automatically enumerated
 (require :plugins.lspconfig)
 (require :plugins.treesitter)
 (require :plugins.telescope)
 (require :plugins.mini)
 (require :plugins.conform)]
