{1 :folke/which-key.nvim
 :opts {:preset :helix
        :plugins {:marks true
                  :registers true
                  :spelling {:enabled true :suggestions 20}
                  :presets {:operators false
                            :motions false
                            :text_objects true
                            :windows true
                            :nav true
                            :z true
                            :g true}}
        :triggers [{1 :<auto> :mode :nxso}
                   {1 :<leader> :mode :nv}
                   {1 :<localleader> :mode :n}]
        :filter (fn [mapping]
                  (not= "" (or mapping.preset mapping.plugin mapping.desc)))
        :expand (fn [node] (not node.desc))
        :icons {:mappings false}
        :win {:border :none :padding [1 3]}
        :show_help false}}
