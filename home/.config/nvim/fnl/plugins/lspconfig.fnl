(local emmet_language_server {:filetypes [:astro
                                          :html
                                          :javascript
                                          :javascriptreact
                                          :typescriptreact
                                          :heex]})

(local servers {:astro {}
                :tsserver {}
                :clangd {}
                :clojure_lsp {}
                :elixirls {}
                :elmls {}
                : emmet_language_server
                :templ {}
                :ocamllsp {}
                :svelte {}
                :gopls {}
                :lua_ls {}})

(local system-servers [:ocamllsp])

(fn make-default-handler [capabilities]
  (let [default-opts {: capabilities}
        lspconfig (require :lspconfig)]
    (fn [server-name]
      (let [server-opts (or (. servers server-name) {})
            opts (vim.tbl_extend :force default-opts server-opts)]
        ((. lspconfig server-name :setup) opts)))))

{1 :neovim/nvim-lspconfig
 :dependencies [:williamboman/mason.nvim
                :williamboman/mason-lspconfig.nvim
                :hrsh7th/cmp-nvim-lsp
                {1 :folke/neodev.nvim :opts {}}]
 :config (fn []
           (let [cmp-capabilities ((. (require :cmp_nvim_lsp)
                                      :default_capabilities))
                 capabilities (vim.tbl_deep_extend :force
                                                   (vim.lsp.protocol.make_client_capabilities)
                                                   cmp-capabilities)
                 default-handler (make-default-handler capabilities)
                 handlers {1 default-handler}
                 ensure-installed (->> servers
                                       (vim.tbl_keys)
                                       (vim.tbl_filter (fn [name]
                                                         (not (vim.list_contains system-servers
                                                                                 name)))))]
             ((. (require :mason) :setup))
             ((. (require :mason-lspconfig) :setup) {: handlers
                                                     :ensure_installed ensure-installed})))}
