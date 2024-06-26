(local servers {:astro {}
                :tsserver {}
                :clangd {}
                :elixirls {}
                :emmet_language_server {}
                :svelte {}
                :gopls {}
                :lua_ls {}})

(fn make-default-handler [capabilities]
  (let [default-opts {: capabilities}
        lspconfig (require :lspconfig)]
    (fn [server-name]
      (let [server-opts (or (. servers server-name) {})
            opts (vim.tbl_extend :force default-opts server-opts)]
        (. (. lspconfig server-name) :setup) opts))))



{1 :neovim/nvim-lspconfig
 :dependencies [:williamboman/mason.nvim :williamboman/mason-lspconfig.nvim]
 :config (fn []
           (let [capabilities ((. (require :cmp_nvim_lsp) :default_capabilities))
                 default-handler (make-default-handler capabilities)
                 handlers {1 default-handler}
                 ensure-installed (vim.tbl_keys servers)]
             ((. (require :mason) :setup))
             ((. (require :mason-lspconfig) :setup) { : handlers :ensure_installed ensure-installed})))}

