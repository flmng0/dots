(fn plugin [name opts]
  (vim.tbl_extend :keep [name] opts))

(local unpack (or table.unpack _G.unpack))

[:rktjmp/hotpot.nvim
 :tpope/vim-sleuth
 (plugin :rebelot/kanagawa.nvim
         {:lazy false
          :priority 1000
          :config (fn [] (vim.cmd.colorscheme :kanagawa))})
 (plugin :nvim-treesitter/nvim-treesitter
         {:build ":TSUpdate"
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
                                      :indent {:enable true}})))})
 (plugin :nvim-telescope/telescope.nvim
         {:tag :0.1.5
          :dependencies [:nvim-lua/plenary.nvim
                         {1 :nvim-telescope/telescope-fzf-native.nvim
                          :build :make}]
          :config (fn []
                    (let [telescope (require :telescope)
                          builtin (require :telescope.builtin)
                          mappings [[:<leader><leader> builtin.find_files]
                                    ["<leader>:" builtin.commands]
                                    [:<leader>/ builtin.live_grep]
                                    [:<leader>h builtin.help_tags]
                                    [:<leader>s builtin.lsp_document_symbols]
                                    [:<leader>S builtin.lsp_workspace_symbols]]]
                      (telescope.setup)
                      (each [_ mapping (ipairs mappings)]
                        (vim.keymap.set :n (unpack mapping)))))})
 (plugin :hrsh7th/nvim-cmp
         {:dependencies [:hrsh7th/cmp-nvim-lsp
                         :hrsh7th/cmp-buffer
                         :hrsh7th/cmp-path
                         :hrsh7th/cmp-vsnip
                         :hrsh7th/vim-vsnip]
          :config (fn []
                    (let [cmp (require :cmp)
                          expand (fn [args]
                                   ((. vim.fn "vsnip#anonymous") args.body))
                          sources (cmp.config.sources [[{:name :nvim_lsp}]
                                                       [{:name :path}
                                                        {:name :buffer}]])]
                      (cmp.setup {:snippet {: expand} : sources})))})
 (plugin :echasnovski/mini.nvim
         {:version false
          :config (fn []
                    (let [plugins [:starter
                                   :statusline
                                   :surround
                                   :indentscope
                                   :comment
                                   :splitjoin
                                   :pairs
                                   :files]]
                      (each [_ plugin (ipairs plugins)]
                        ((. (require (.. :mini. plugin)) :setup)))
                      (vim.keymap.set :n :<leader>e
                                      (fn []
                                        (if (not (_G.MiniFiles.close))
                                            (_G.MiniFiles.open))))))})
 (plugin :stevearc/conform.nvim
         {:config (fn []
                    (let [conform (require :conform)
                          formatters_by_ft {:lua [:stylua]
                                            :javascript [:prettierd]
                                            :ocaml [:ocamlformat]
                                            :fennel [:fnlfmt]}]
                      (conform.setup {: formatters_by_ft
                                      :format_on_save {:timeout_ms 500
                                                       :lsp_fallback true}})
                      (vim.api.nvim_create_user_command :Format
                                                        (fn [] (conform.format))
                                                        {})))})]

