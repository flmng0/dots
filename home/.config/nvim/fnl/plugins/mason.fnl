{1 :williamboman/mason.nvim
 :lazy false
 :dependencies [:neovim/nvim-lspconfig
                :williamboman/mason-lspconfig.nvim
                {1 :j-hui/fidget.nvim :config true}]
 :config (fn []
           (let [mason (require :mason)
                 mason-lspconfig (require :mason-lspconfig)
                 home-servers ["ts_ls" 
                               "ols" 
                               "gopls" 
                               "erlangls" 
                               "expert" 
                               "svelte" 
                               "gdscript" 
                               "elmls" 
                               "clojure_lsp" 
                               "astro"]
                 work-servers ["ts_ls" "prismals" "pylsp" "intelephense"]
                 servers (if _G.iswork work-servers home-servers)]
             (mason.setup)
             (mason-lspconfig.setup {})
             (vim.lsp.enable servers)))}
