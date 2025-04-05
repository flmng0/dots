(local profile-env-key :TMTHY_PROFILE)
(local hostname-map {"iDurian" :home})

;; fnlfmt: skip
(local servers 
       {:* [] 
        :home [:ols :gopls]})

(fn get-servers [profile]
  (vim.tbl_extend :error servers.* (or (. servers profile) [])))

(fn get-profile []
  (or (os.getenv profile-env-key) (?. hostname-map (vim.fn.hostname)) :home))

(let [profile (get-profile)
      servers (get-servers profile)]
  {: profile : servers})
