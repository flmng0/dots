; LSP completion.
{1 :hrsh7th/nvim-cmp
 :dependencies [:hrsh7th/cmp-nvim-lsp
                :PaterJason/cmp-conjure
                :hrsh7th/cmp-buffer
                :hrsh7th/cmp-path
                :hrsh7th/cmp-vsnip
                :hrsh7th/vim-vsnip]
 :config (fn []
           (let [cmp (require :cmp)
                 expand (fn [args]
                          ((. vim.fn "vsnip#anonymous") args.body))
                 sources (cmp.config.sources [[{:name :nvim_lsp}
                                               {:name :conjure}]
                                              [{:name :path} {:name :buffer}]])]
             (cmp.setup {:snippet {: expand} : sources})))}

