{1 :hrsh7th/nvim-cmp
 :event :InsertEnter
 :dependencies [:hrsh7th/cmp-nvim-lsp :hrsh7th/cmp-buffer]
 :config (fn []
           (let [cmp (require :cmp)
                 jump-mapping (fn [dir]
                                (-> (fn [fallback]
                                      (if (vim.snippet.active {:direction dir})
                                          (vim.snippet.jump dir)
                                          (fallback)))
                                    (cmp.mapping [:i :s])))
                 expand (fn [args] (vim.snippet.expand args.body))
                 mapping {:<C-n> (cmp.mapping.select_next_item)
                          :<C-p> (cmp.mapping.select_prev_item)
                          :<C-b> (cmp.mapping.scroll_docs -4)
                          :<C-f> (cmp.mapping.scroll_docs 4)
                          :<C-y> (cmp.mapping.confirm {:select true})
                          :<C-Space> (cmp.mapping.complete {})
                          :<Tab> (jump-mapping 1)
                          :<S-Tab> (jump-mapping -1)}]
             (cmp.setup {:snippet {: expand}
                         :completion {:completeopt "menu,menuone,noinsert"}
                         : mapping
                         :sources [{:name :nvim_lsp} {:name :buffer}]})))}
