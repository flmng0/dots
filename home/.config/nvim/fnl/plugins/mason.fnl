{1 :williamboman/mason.nvim
 :lazy false
 :dependencies [:neovim/nvim-lspconfig
                :williamboman/mason-lspconfig.nvim
                {1 :j-hui/fidget.nvim :config true}]
 :config (fn []
           (let [mason (require :mason)
                 mason-lspconfig (require :mason-lspconfig)
                 servers ["ts_ls" 
                          "ols" 
                          "gopls" 
                          "erlangls" 
                          "expert" 
                          "svelte" 
                          "gdscript" 
                          "elmls" 
                          "clojure_lsp" 
                          "astro"]]
             (mason.setup)
             (mason-lspconfig.setup {})
             (vim.lsp.enable servers)))}
