(local profile-env-key :TMTHY_PROFILE)
(local hostname-map {"iDurian" :home
                     "DESKTOP-H1NUKS2" :work})

;; fnlfmt: skip
(local servers 
       {:* ["ts_ls"] 
        :home ["ols" "gopls" "expert" "svelte"]
        :work ["omnisharp" "vue_ls" "intelephense"]})

(fn get-servers [profile]
  (vim.list_extend servers.* (or (. servers profile) [])))

(fn get-profile []
  (or (os.getenv profile-env-key) (?. hostname-map (vim.fn.hostname)) :home))

(let [profile (get-profile)
      servers (get-servers profile)]
  {: profile : servers})
