(import-macros {: map : lazy} :macros)

(fn relative-fzf [picker-name]
  (let [{: get_current_dir} (require :oil)
        picker (lazy :fzf-lua picker-name)]
    (fn [] (picker {:cwd (get_current_dir)}))))

;; fnlfmt: skip
(map {:prefix :<localleader>}
  (:/  (relative-fzf :live_grep) :desc "Open FZF live_grep in the current oil directory" :buffer true)
  (:<space> (relative-fzf :files) :desc "Open FZF :files in the current oil directory" :buffer true))
