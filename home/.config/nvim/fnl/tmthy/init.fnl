(require :tmthy.options)

(vim.api.nvim_create_autocmd 
  :FileType
  {:pattern "*"
   :callback
   (let [parsers (require "nvim-treesitter.parsers")
         available (parsers.available_parsers)]
     (fn []
       (when (vim.list_contains available vim.bo.filetype)
         (vim.treesitter.start))))})
