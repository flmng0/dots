(local servers {:clangd {} :elixirls {}})

{1 :neovim/nvim-lspconfig
 :dependencies [:williamboman/mason.nvim :williamboman/mason-lspconfig.nvim]
 :config (fn []
           (let [lspconfig (require :lspconfig)
                 mason (require :mason)
                 mason-lspconfig (require :mason-lspconfig)
                 capabilities ((. (require :cmp_nvim_lsp) :default_capabilities))
                 default-opts {: capabilities}
                 make-options (fn [opts]
                                (vim.tbl_extend :force default-opts opts))]
             (do
               (mason.setup)
               (mason-lspconfig.setup {:ensure_installed (vim.tbl_keys servers)})
               (each [server opts (pairs servers)]
                 ((. (. lspconfig server) :setup) (make-options opts))))))}

