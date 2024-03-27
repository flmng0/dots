(local unpack (or table.unpack _G.unpack))

; Telescope for (mostly) fuzzy find files.
; Lots of good utility as well like document symbols.
{1 :nvim-telescope/telescope.nvim
 :tag :0.1.5
 :dependencies [:nvim-lua/plenary.nvim
                {1 :nvim-telescope/telescope-fzf-native.nvim :build :make}]
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
               (vim.keymap.set :n (unpack mapping)))))}

