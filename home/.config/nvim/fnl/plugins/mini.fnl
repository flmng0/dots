(import-macros {: plugin-setup} :macros)

(local config-session-name :_nvim-config)

(fn set-title [session]
  (let [{: name} session
        name (if (= name config-session-name) "Configuring nvim" name)]
   (tset vim.opt :title true)
   (tset vim.opt :titlestring (.. name " - Neovide"))))

{1 :echasnovski/mini.nvim
 :version false
 :config (fn []
           (plugin-setup :mini.surround {:respect_selection_type true})
           (plugin-setup :mini.move {})
           (plugin-setup :mini.git {})
           (plugin-setup :mini.diff {})
           (plugin-setup :mini.sessions {:hooks {:pre {:read set-title}}})
                                                 
                         

           (let [starter (require :mini.starter)
                 footer (.. "Using '" (. (require :tmthy.profile) :profile) "' profile.")
                 sessions (fn []
                            (icollect [_ s (ipairs ((starter.sections.sessions 5)))]
                              (when (not= s.name config-session-name) s)))
                 config-item {:name "Configure Neovim"
                              :action (fn []
                                        (if (= nil
                                               (?. _G.MiniSessions.detected
                                                   config-session-name))
                                            (do
                                              (doto (vim.fn.stdpath :config)
                                                (vim.api.nvim_set_current_dir)
                                                ((. (require :oil) :open)))
                                              (_G.MiniSessions.write config-session-name))
                                            (_G.MiniSessions.read config-session-name)))
                              :section "Builtin actions"}]
             (starter.setup {:items [sessions
                                     config-item
                                     (starter.sections.builtin_actions)]
                             : footer})))}
