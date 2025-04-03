(fn term [code]
  (vim.api.nvim_replace_termcodes code true true true))

(local ctrl-v (term "<C-V>"))
(local ctrl-s (term "<C-S>"))

(fn hl [name]
  (.. "%#" name "#"))

(fn component [text hl-name padding]
  (let [padding-text (string.rep " " (or padding 0))]
    (table.concat [(hl hl-name) padding-text text padding-text])))

(fn status-line []
  (fn mode []
    (fn mode-obj [text hl]
      (let [hl (or hl text)]
        {: text :hl (.. "StatusLineMode" hl)}))

    (let [node-map {:n (mode-obj "Normal")
                    :v (mode-obj "Visual")
                    :V (mode-obj "V-Line" "Visual")
                    ctrl-v (mode-obj "V-Block" "Visual")
                    :s (mode-obj "Select")
                    :S (mode-obj "S-Line" "Select")
                    ctrl-s (mode-obj "S-Block" "Select")
                    :i (mode-obj "Insert")
                    :R (mode-obj "Replace")
                    :c (mode-obj "Command")
                    :r (mode-obj "Prompt" "Other")
                    :! (mode-obj "Shell" "Other")
                    :t (mode-obj "Terminal" "Other")}
          default (mode-obj "Unknown" "Other")
          mode-info (or (. node-map (vim.fn.mode)) default)]
      (component mode-info.text mode-info.hl 1)))

  (fn branch []
    (case vim.b.minigit_summary
      {:head_name head-name}
      (let [head-name (head-name:gsub "^feature/(%a+%-%d+).*" "f/%1")]
        (component (.. " " head-name) "StatusLineGitBranch" 2))
      _ ""))

  (fn diff []
    (fn display-diff [diff-tbl n icon hl]
      (when (> n 0)
        (->> (component (.. icon " " (tostring n)) hl)
             (table.insert diff-tbl))))

    (case vim.b.minidiff_summary
      (where {:status status} (= status "??"))
      (component "" "StatusLineGitUnstaged" 1)

      {:add add :change change :delete delete}
      (let [text
            (-> (doto []
                  (display-diff add "" "StatusLineGitAdd")
                  (display-diff change "" "StatusLineGitChange")
                  (display-diff delete "" "StatusLineGitDelete"))
                (table.concat " "))]
        (when (> (length text) 0) 
          (component text "StatusLineGitBranch" 1)))

      _ ""))

  (fn lsp-status []
    (let [bufnr (vim.api.nvim_get_current_buf)
          clients (vim.lsp.get_clients {: bufnr})]
      (when (> (length (or clients [])) 0)
        (let [names (icollect [_ client (ipairs clients)] client.name)
              names-text (table.concat names ", ")
              icon-text "󰈸"]
          (-> (.. (component icon-text "StatusLineLspIcon") " " (component names-text "StatusLineLspNames"))
              (component "StatusLineLspNames" 1))))))
            

  (fn join [& components]
    (let [total (length components)]
      (-> (icollect [i comp (ipairs components)]
            (when (and (not= nil comp) (not= "" comp))
              (let [is-last (= i total)
                    is-special (and (= (length comp) 2)
                                    (= "%" (string.sub comp 1 1)))]
                (if (or is-last is-special)
                    comp
                    (.. comp "%#StatusLine# ")))))
          (table.concat))))

  (join 
    (mode) 
    "%<" 
    (branch) 
    (component "%f" "StatusLine") 
    (diff)
    "%="
    (lsp-status)
    (component "%l:%c" "StatusLine")))

(tset _G :TmthyStatusLine status-line)

(tset vim.o :statusline " %{%v:lua.TmthyStatusLine()%} ")
