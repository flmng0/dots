{1 :williamboman/mason.nvim
 :lazy false
 :dependencies [{1 :j-hui/fidget.nvim :config true}]
 :config (fn []
           ;; TODO: What the heck was I thinking?
           (fn digest-lsp-files [files]
             (icollect [_ c (ipairs files)]
               (let [leaf-name (vim.fn.fnamemodify c ":t:r")
                     matcher (string.gmatch leaf-name "(%w*)#*(%w*)")
                     (name profile) (matcher)]
                 {: name : profile})))

           (let [mason (require :mason)
                 mason-registry (require :mason-registry)
                 lsp-configs (digest-lsp-files (vim.api.nvim_get_runtime_file "lsp/*.lua" true))]

             (fn ensure-installed [name]
               (when (mason-registry.has_package name)
                 (let [pkg (mason-registry.get_package name)]
                   (when (not (pkg:is_installed))
                     (pkg:install)))))

             (mason.setup)
             (mason-registry.refresh (fn []
                                       (let [names (icollect [_ {: name : profile} (ipairs lsp-configs)]
                                                     (do
                                                       (print name " " profile)
                                                      (when (or (= "" profile)
                                                                (= (require :tmthy.profile) profile))
                                                           (ensure-installed name)
                                                           name)))]
                                        (vim.lsp.enable names))))))}


