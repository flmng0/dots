(local profile-env-key :TMTHY_PROFILE)
(local hostname-map {"iDurian" :home})

(or (os.getenv profile-env-key) (?. hostname-map (vim.fn.hostname)) :home)
