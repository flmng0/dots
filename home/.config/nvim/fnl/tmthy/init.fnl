(require :tmthy.options)

(vim.api.nvim_create_autocmd 
  :FileType
  {:pattern "*"
   :callback (fn [] (vim.treesitter.start))})
