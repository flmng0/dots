(import-macros {: map} :macros)

(fn relative-fzf []
  (let [{: get_current_dir} (require :oil)
        {: live_grep} (require :fzf-lua)]
    (live_grep {:cwd (get_current_dir)})))

(map (:<localleader>/ relative-fzf :desc "Open FZF live_grep in the current oil directory" :buffer true))
