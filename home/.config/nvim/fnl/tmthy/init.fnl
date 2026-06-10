(require :tmthy.options)

(vim.api.nvim_create_autocmd
  :FileType
  {:pattern "*"
   :callback
   (let [treesitter (require "nvim-treesitter")
         available (treesitter.get_installed)]
     (fn []
       (when (vim.list_contains available vim.bo.filetype)
         (vim.treesitter.start))))})
  
