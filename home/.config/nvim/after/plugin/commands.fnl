(import-macros {: tkeys} :macros)

(macro defcommand [name opts binding & body]
  `(vim.api.nvim_create_user_command ,name
                                     (fn ,binding
                                       ,(unpack body))
                                     ,opts))
(defcommand :GetExtmarks 
  {:nargs 0}
  []
  (let [pos (vim.api.nvim_win_get_cursor 0)]
    (case (. (vim.api.nvim_get_namespaces) "vt_inst")
      ns (let [marks (vim.api.nvim_buf_get_extmarks 0 ns pos pos {:overlap true})]
           (vim.notify (vim.inspect marks))))))
     
(defcommand :BrdnImpl
  {:nargs 0 :range true}
  [{: line1 : line2}]
  (let [brandon (require :brandon) 
        prompt "Implement this"]
      (if (and line1 line2)
          (brandon.instruct_range prompt)
          (brandon.instruct_insert prompt))))
            

(defcommand :RecompileConfig
  {:nargs 0}
  []
  (let [config-path (vim.fn.stdpath :config)]
    ((. (require :hotpot.api.make) :auto :build) config-path)))

(defcommand :BufOnly {:bang true :nargs 0} [{:bang force}]
  (if force
      (vim.cmd "%bd!|e#")
      (vim.cmd "%bd|e#")))

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


(defcommand :BufDisableFormatting {} []
  (tset vim.b :disable_autoformatting true))
