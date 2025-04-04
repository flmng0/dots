{1 :williamboman/mason.nvim
 :lazy false
 :dependencies [{1 :j-hui/fidget.nvim :config true}]
 :config (fn []
           (let [mason (require :mason)
                 mason-registry (require :mason-registry)
                 lsp-names (icollect [_ c (ipairs (vim.api.nvim_get_runtime_file "lsp/*.lua"
                                                                                 true))]
                             (vim.fn.fnamemodify c ":t:r"))]
             (print "LSP names:" (.. (unpack lsp-names)))

             (fn ensure-installed [name]
               (when (mason-registry.has_package name)
                 (let [pkg (mason-registry.get_package name)]
                   (when (not (pkg:is_installed))
                     (pkg:install)))))

             (mason.setup)
             (mason-registry.refresh (fn []
                                       (each [_ name (ipairs lsp-names)]
                                         (ensure-installed name))
                                       (vim.lsp.enable lsp-names)))))}
