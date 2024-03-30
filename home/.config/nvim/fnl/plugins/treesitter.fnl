; TreeSitter for indentation and highlighting (mainly highlighting :P)
{1 :nvim-treesitter/nvim-treesitter
 :build ":TSUpdate"
 :config (fn []
           (let [configs (require :nvim-treesitter.configs)
                 ensured [:lua
                          :fennel
                          :elixir
                          :heex
                          :html
                          :ocaml
                          :javascript
                          :typescript
                          :astro]]
             (configs.setup {:ensure_installed ensured
                             :auto_install true
                             :highlight {:enable true}
                             :indent {:enable true}})))}

