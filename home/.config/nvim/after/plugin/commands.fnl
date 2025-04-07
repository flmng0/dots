(import-macros {: tkeys} :macros)

(macro command [name opts binding & body]
  '(vim.api.nvim_create_user_command ,name
                                     (fn ,binding
                                       ,(unpack body))
                                     ,opts))

(command :BufOnly {:nargs 0} []
  (vim.cmd "%bd|e#"))


(fn session-complete []
  (let [{: detected} (require :mini.sessions)
        names (tkeys detected)]
    names))

(command :NewSession {:bang true :nargs 1} [opts]
  (let [{:args session_name :bang force} opts
        {: write} (require :mini.sessions)]
    (write session_name {: force})))

(command :DeleteSession {:bang true :nargs 1 :complete session-complete} [opts]
  (let [{:args session-name :bang force} opts
        {: detected : delete} (require :mini.sessions)
        session-names (tkeys detected)]
    (if (vim.list_contains session-names session-name)
        (do 
          (delete session-name {: force})
          (when (= vim.bo.filetype :ministarter)
            ((. (require :mini.starter) :refresh))))
        (vim.notify (.. "ERR: No session named " session-name)))))

(command :OpenSession {:bang true :nargs 1 :complete session-complete} [opts]
  (let [{:args session-name :bang force} opts
        {: read} (require :mini.sessions)]
    (read session-name {: force})))

