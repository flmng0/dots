(local servers {:astro {}
                :tsserver {}
                :clangd {}
                :elixirls {}
                :emmet_language_server {}
                :gopls {}
                :lua_ls {}})

{1 :neovim/nvim-lspconfig
 :config (fn []
           (let [lspconfig (require :lspconfig)
                 capabilities ((. (require :cmp_nvim_lsp) :default_capabilities))
                 default-opts {: capabilities}]
             (each [server-name server-opts (pairs servers)]
               (let [opts (vim.tbl_extend :force default-opts server-opts)]
                 ((. (. lspconfig server-name) :setup) opts)))))}

