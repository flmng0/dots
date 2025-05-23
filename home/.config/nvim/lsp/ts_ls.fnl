(fn get-vls-path []
  (let [registry (require :mason-registry)
        is-installed (registry.is_installed :vue-language-server)]
    (when is-installed
      (vim.fn.expand "$MASON/packages/vue-language-server/node_modules/@vue/language-server"))))

(let [vls-path (get-vls-path)]
   {:init_options {:plugins [{:name "@vue/typescript-plugin"
                              :location vls-path
                              :languages ["vue"]}]}
    :filetypes [:javascript
                :javascriptreact
                :javascript.jsx
                :typescript
                :typescriptreact
                :typescript.tsx
                :vue]})
