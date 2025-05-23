{1 :williamboman/mason.nvim
 :lazy false
 :dependencies [:neovim/nvim-lspconfig
                :williamboman/mason-lspconfig.nvim
                {1 :j-hui/fidget.nvim :config true}]
 :config (fn []
           (let [mason (require :mason)
                 mason-lspconfig (require :mason-lspconfig)
                 {: servers} (require :tmthy.profile)]
             (mason.setup)
             (mason-lspconfig.setup {:ensure_installed servers})
             (vim.lsp.enable servers)))}
