[; Make sure to actually track hotpot!
 :rktjmp/hotpot.nvim
 ; Auto indent size and more
 :tpope/vim-sleuth
 ; Parenthesis handling for lisp-like languages
 {1 :gpanders/nvim-parinfer}
 ; Conjure!
 {1 :Olical/conjure}
 ; ColorScheme
 {1 :rebelot/kanagawa.nvim
  :lazy false
  :priority 1000
  :config (fn [] (vim.cmd.colorscheme :kanagawa))}
 (require :plugins.lspconfig)
 (require :plugins.treesitter)
 (require :plugins.telescope)
 (require :plugins.nvim-cmp)
 (require :plugins.mini)
 (require :plugins.conform)]

