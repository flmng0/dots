(import-macros {: lazy : map} :macros)


(fn select-mapping [capture-group]
  (lazy :nvim-treesitter-textobjects.select :select-textobject))

(fn config [opts]
  (let [{: setup} (require :nvim-treesitter-textobjects)
        select (lazy :nvim-treesitter-textobjects.select :select_textobject)
        selector #(select $ "textobjects")

        next (lazy :nvim-treesitter-textobjects.move :goto_next)
        next-mover #(next $ "textobjects")

        prev (lazy :nvim-treesitter-textobjects.move :goto_previous)
        prev-mover #(prev $ "textobjects")]

    (setup opts)

    (map {:mode [:x :o]}
      (:am #(selector "@function.outer") :desc "Around method")
      (:im #(selector "@function.inner") :desc "Inside method")

      (:ac #(selector "@class.outer") :desc "Around class")
      (:ic #(selector "@class.inner") :desc "Inside class")
      
      (:aa #(selector "@argument.outer" :desc "Around argument"))
      (:ia #(selector "@argument.inner" :desc "Inside argument")))

    (map {:mode [:n :x :o]}
      ("]a" #(next-mover "@argument.outer") :desc "Next argument")
      ("[a" #(prev-mover "@argument.outer") :desc "Previous argument"))

    (let [repeat (require :nvim-treesitter-textobjects.repeatable_move)]
      (map {:mode [:n :x :o]}
        (";" repeat.repeat_last_move_next)
        ("," repeat.repeat_last_move_previous)
        
        (:f repeat.builtin_f_expr :expr true)
        (:F repeat.builtin_F_expr :expr true)
        (:t repeat.builtin_t_expr :expr true)
        (:T repeat.builtin_T_expr :expr true)))))

           
           

{1 :nvim-treesitter/nvim-treesitter-textobjects
 :config config}
