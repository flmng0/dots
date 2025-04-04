;; color scheme
{1 "rebelot/kanagawa.nvim"
 :lazy false
 :priority 1000
 :config (fn []
           (let [kanagawa (require :kanagawa)
                 overrides (fn [colors]
                             (let [p colors.palette
                                   winbar {:WinBarMain {:bg p.sakuraPink :fg p.sumiInk0}
                                           :WinBarEnd {:fg p.sakuraPink}
                                           :WinBarMainNC {:bg p.sumiInk4 :fg p.springViolet1}
                                           :WinBarEndNC {:fg p.sumiInk4}}
                                   info-bg p.sumiInk4
                                   status-line {:StatusLineGitBranch {:bg info-bg :fg p.oldWhite}
                                                :StatusLineGitAdd {:bg info-bg :fg p.autumnGreen}
                                                :StatusLineGitChange {:bg info-bg :fg p.autumnYellow}
                                                :StatusLineGitDelete {:bg info-bg :fg p.autumnRed}
                                                :StatusLineGitUnstaged {:bg info-bg :fg p.crystalBlue}
                                                :StatusLineLspIcon {:bg info-bg :fg p.crystalBlue}
                                                :StatusLineLspNames {:bg info-bg :fg p.oldWhite :italic true}}
                                   status-line (collect [_ mode (ipairs [:Normal 
                                                                         :Visual 
                                                                         :Select 
                                                                         :Insert 
                                                                         :Replace 
                                                                         :Command 
                                                                         :Other])
                                                           &into status-line]
                                                 (values (.. :StatusLineMode mode) {:link (.. :MiniStatusLineMode mode)}))]
                               (vim.tbl_extend :error {} winbar status-line)))]
             (kanagawa.setup {: overrides})
             (vim.cmd "colorscheme kanagawa")))}
