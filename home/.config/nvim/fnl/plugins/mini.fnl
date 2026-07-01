(import-macros {: plugin-setup} :macros)

(local config-session-name :_nvim-config)

(fn capitalize [word]
  (.. 
    (string.upper (string.sub word 1 1))
    (string.sub word 2)))
  

(fn tear-and-capitalize [text]
  (accumulate [result ""
               part (string.gmatch text "[%a%.]+")]
    (.. result (capitalize part))))
        
(set _G.tearAndCap tear-and-capitalize)

(local snippet-defs
       {:DTO_MODEL_FROM_FILENAME 
        (fn [] 
          (-> (vim.api.nvim_buf_get_name 0)
              (string.gsub ".+backend/src/module" "")
              (string.gsub "/dto" "")
              (vim.fs.dirname)
              (tear-and-capitalize)))
        :DTO_TYPE_FROM_FILENAME 
        (fn []
          (-> (vim.api.nvim_buf_get_name 0)
              (string.gsub (vim.fn.getcwd) "")
              (string.gsub "/dto" "")
              (vim.fs.basename)
              (string.match "[%a%-]+")
              (tear-and-capitalize)))})

(fn set-title [session]
  (let [{: name} session
        name (if (= name config-session-name) "Configuring nvim" name)
        suffix (if vim.g.neovide "Neovide" "NeoVim")]
   (tset vim.opt :title true)
   (tset vim.opt :titlestring (.. name " - " suffix))))

(fn make-snippets []
  (let [gen-loader (. (require :mini.snippets) :gen_loader)]
    [(gen-loader.from_lang)]))

(fn inserter [snippet]
  (let [lookup (collect [k v (pairs snippet-defs)]
                 (values k (v)))]
    (_G.MiniSnippets.default_insert snippet {: lookup})))
  

{1 :echasnovski/mini.nvim
 :version false
 :config (fn []
           (plugin-setup :mini.surround {:respect_selection_type true})
           (plugin-setup :mini.move {:mappings
                                     {:left "<S-left>"
                                      :right "<S-right>"
                                      :down "<S-down>"
                                      :up "<S-up>"

                                      :line_left "<S-left>"
                                      :line_right "<S-right>"
                                      :line_down "<S-down>"
                                      :line_up "<S-up>"}})
           (plugin-setup :mini.git {})
           (plugin-setup :mini.diff {})
           (plugin-setup :mini.sessions {:hooks {:pre {:read set-title}}})


           (plugin-setup :mini.snippets {:snippets (make-snippets)
                                         :expand {:insert inserter}
                                         :mappings {:expand ""
                                                    :jump_next ""
                                                    :jump_prev ""
                                                    :stop ""}})

           (fn config-action []
             (if (= nil (?. _G.MiniSessions.detected config-session-name))
                 (do
                   (doto (vim.fn.stdpath :config)
                     (vim.api.nvim_set_current_dir)
                     ((. (require :oil) :open)))
                   (_G.MiniSessions.write config-session-name))
                 (_G.MiniSessions.read config-session-name)))

           (let [starter (require :mini.starter)
                 footer nil
                 sessions (fn []
                            (icollect [_ s (ipairs ((starter.sections.sessions 10)))]
                              (when (not= s.name config-session-name) s)))
                 config-item {:name "Configure Neovim"
                              :action config-action
                              :section "Builtin actions"}]
             (starter.setup {:items [sessions
                                     config-item
                                     (starter.sections.builtin_actions)]
                             : footer})))}
