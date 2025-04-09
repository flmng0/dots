{1 :nvim-treesitter/nvim-treesitter
 :build ":TSUpdate"
 :dependencies [:nvim-treesitter/nvim-treesitter-textobjects]
 :config (fn []
           (let [configs (require :nvim-treesitter.configs)]
             (configs.setup {:auto_install true
                             :highlight {:enable true}
                             :indent {:enable true}

                             :incremental_selection {:enable true
                                                     :keymabs {:init_selection :<A-a>
                                                               :node_incremental :<A-a>
                                                               :scope_incremental :<A-s>
                                                               :node_decremental :<A-i>}}
                             :textobjects {:select {:enable true
                                                    :lookahead true
                                                    :keymaps {:aa "@parameter.outer"
                                                              :ia "@parameter.inner"

                                                              :am "@function.outer"
                                                              :im "@function.inner"}}
                                           :move {:enable true
                                                  :set_jumps true
                                                  
                                                  :goto_next_start 
                                                  {"]m" {:query "@function.outer" :desc "Goto next function start"}
                                                   "]a" {:query "@parameter.outer" :desc "Goto next parameter start"}
                                                   "]=" {:query "@assignment.outer" :desc "Goto next assignment start"}}
                                                  
                                                  :goto_next_end
                                                  {"]M" {:query "@function.outer" :desc "Goto next function end"}
                                                   "]A" {:query "@parameter.outer" :desc "Goto next parameter end"}}

                                                  :goto_previous_start 
                                                  {"[m" {:query "@function.outer" :desc "Goto previous function start"}
                                                   "[a" {:query "@parameter.outer" :desc "Goto previous parameter start"}
                                                   "[=" {:query "@assignment.outer" :desc "Goto previous assignment start"}}

                                                  :goto_previous_end
                                                  {"[M" {:query "@function.outer" :desc "Goto previous function end"}
                                                   "[A" {:query "@parameter.outer" :desc "Goto previous parameter end"}}}}})))}
                                                  
                                                  

