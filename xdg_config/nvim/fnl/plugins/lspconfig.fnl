(local servers {:clangd {} :elixirls {}})

{1 :neovim/nvim-lspconfig
 :config (fn []
           (let [lspconfig (require :lspconfig)
                 capabilities ((. (require :cmp_nvim_lsp) :default_capabilities))
                 default-config {: capabilities}]
             (each [server opts (pairs servers)]
               (let [real-opts (vim.tbl_extend :force default-config opts)]
                 ((. (. lspconfig server) :setup) real-opts)))))}

