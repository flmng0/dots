(import-macros {: tkeys} :macros)

(macro defcommand [name opts binding & body]
  `(vim.api.nvim_create_user_command ,name
                                     (fn ,binding
                                       ,(unpack body))
                                     ,opts))

(defcommand :RecompileConfig
  {:nargs 0}
  []
  (let [config-path (vim.fn.stdpath :config)]
    ((. (require :hotpot.api.make) :auto :build) config-path)))

(defcommand :BufOnly {:nargs 0} []
  (vim.cmd "%bd|e#"))

(fn session-complete []
  (let [{: detected} (require :mini.sessions)
        names (tkeys detected)]
    names))

(defcommand :NewSession
  {:bang true :nargs 1}
  [opts]
  (let [{:args session_name :bang force} opts
        {: write} (require :mini.sessions)]
    (write session_name {: force})))

(defcommand :DeleteSession
  {:bang true :nargs 1 :complete session-complete}
  [opts]
  (let [{:args session-name :bang force} opts
        {: detected : delete} (require :mini.sessions)
        session-names (tkeys detected)]
    (if (vim.list_contains session-names session-name)
        (do
          (delete session-name {: force})
          (when (= vim.bo.filetype :ministarter)
            ((. (require :mini.starter) :refresh))))
        (vim.notify (.. "ERR: No session named " session-name)))))

(defcommand :OpenSession
  {:bang true :nargs 1 :complete session-complete}
  [opts]
  (let [{:args session-name :bang force} opts
        {: read} (require :mini.sessions)]
    (read session-name {: force})))
