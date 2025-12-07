[{1 :julienvincent/nvim-paredit}
 ; "Conversational" editing for lisp-likes.
 {1 :Olical/conjure
  :lazy true
  :ft [:clojure]
  :init (fn []
          (tset vim.g :conjure#mapping#doc_word false)
          (tset vim.g
                :conjure#client#clojure#nrepl#connection#auto_repl#enabled false))}
 {1 :clojure-vim/vim-jack-in
  :dependencies [:tpope/vim-dispatch :radenling/vim-dispatch-neovim]}]
