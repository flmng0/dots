(fn plugin-setup [name options]
  `((. (require ,name) :setup) ,options))

(fn lazy [module method]
  `(fn [& args#]
     ((. (require ,module) ,method) (unpack args#))))

(fn tkeys [tbl]
  `(icollect [k# _# (pairs ,tbl)] k#))

(fn tvals [tbl]
  `(icollect [_# v# (pairs ,tbl)] v#))

;; Macro that simplifies binding
;; Could be used as the following:
;;   (bind {:prefix :<leader> :modes :ni}
;;         (<LHS> <RHS> :desc "Description" :arg 1)
;;         (<LHS> <RHS> :desc "Description 2" :arg 1))
;;
;; and would produce:
;;   (wk.add [{1 :<leader><LHS> 2 :<RHS> :desc "Description" :arg 1}
;;            {1 :<leader><LHS> 2 :<RHS> :desc "Description 2" :arg 2}])
;;
(fn map [opts & bindings]
  (let [bindings (if (list? opts) (list opts (unpack bindings)) bindings)
        {: prefix : hidden : mode : buffer} (if (table? opts) opts {})
        mode (or mode :n)
        hidden (= hidden true)]
    (fn ->mapping [b]
      (assert-compile (list? b) "Expected list for binding" b)
      (assert-compile (>= (length b) 2) "Binding should have at least 2 items!"
                      b)
      (let [[lhs rhs & opts] b
            lhs (if prefix (.. prefix lhs) lhs)]
        (assert-compile (= 0 (% (length opts) 2))
                        "Invalid count for binding options" opts)

        (fn collect-opts [acc key val & rest]
          (if (= nil key)
              acc
              (do
                (tset acc key val)
                (tail! (collect-opts acc (unpack rest))))))

        (doto {: mode : buffer}
          (collect-opts (unpack opts))
          (table.insert lhs)
          (table.insert rhs))))

    (let [mappings (icollect [_ binding (ipairs bindings)]
                     (->mapping binding))]
      (when hidden (tset mappings :hidden true))
      `(let [wk# (require :which-key)]
         (wk#.add ,mappings)))))

{: plugin-setup : lazy : map : tkeys : tvals}
