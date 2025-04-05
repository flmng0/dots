(let [{: profile} (require :tmthy.profile)
      (success config) (pcall require (.. :plugins.profile. profile))]
  (if success
      config
      (do
        (vim.notify (.. "No profile plugin configuration for profile: " profile) vim.log.levels.WARN)
        {})))
  
  
