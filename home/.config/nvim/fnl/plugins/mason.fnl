{1 :williamboman/mason.nvim
 :lazy false
 :dependencies [{1 :j-hui/fidget.nvim :config true}]
 :config (fn []
           (let [mason (require :mason)
                 mason-registry (require :mason-registry)]
             (fn ensure-installed [name]
               (when (mason-registry.has_package name)
                 (let [pkg (mason-registry.get_package name)]
                   (when (not (pkg:is_installed))
                     (pkg:install)))))

             (fn enable-required []
               (let [{: servers} (require :tmthy.profile)]
                 (each [_ name (ipairs servers)]
                   (ensure-installed name))
                 (vim.lsp.enable servers)))

             (mason.setup)
             (mason-registry.refresh enable-required)))}
