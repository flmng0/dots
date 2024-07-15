(local emmet_language_server
       {:filetypes [:astro :html :javascript :javascriptreact :typescriptreact]})

(local servers {:astro {}
                :tsserver {}
                :clangd {}
                :clojure_lsp {}
                :elixirls {:cmd [:elixir-ls]}
                : emmet_language_server
                :templ {}
                :ocamllsp {}
                :svelte {}
                :gopls {}
                :lua_ls {}})

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
                {1 :folke/neodev.nvim :opts {}}]
 :config (fn []
           (let [capabilities (vim.lsp.protocol.make_client_capabilities)
                 default-handler (make-default-handler capabilities)
                 handlers {1 default-handler}
                 ensure-installed (vim.tbl_keys servers)]
             ((. (require :mason) :setup))
             ((. (require :mason-lspconfig) :setup) {: handlers
                                                     :ensure_installed ensure-installed})))}
