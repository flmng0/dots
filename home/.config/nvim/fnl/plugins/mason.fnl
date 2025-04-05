{1 :williamboman/mason.nvim
 :lazy false
 :dependencies [{1 :j-hui/fidget.nvim :config true}]
 :config (fn []
           (let [mason (require :mason)
                 mason-registry (require :mason-registry)]
             (fn enable-required []
               (let [{: ensure-installed} (require :tmthy.mason)
                     {: servers} (require :tmthy.profile)]
                 (each [_ name (ipairs servers)]
                   (ensure-installed name))
                 (vim.lsp.enable servers)))

             (mason.setup)
             (mason-registry.refresh enable-required)))}
