(let [registry (require :mason-registry)
      vls_path (-> (registry.get_package :vue-language-server)
                   (: :get_install_path)
                   (.. "/node_modules/@vue/language-server"))]
   {:init_options {:plugins [{:name "@vue/typescript-plugin"
                              :location vls_path
                              :languages ["vue"]}]}
    :filetypes [:javascript
                :javascriptreact
                :javascript.jsx
                :typescript
                :typescriptreact
                :typescript.tsx
                :vue]})
