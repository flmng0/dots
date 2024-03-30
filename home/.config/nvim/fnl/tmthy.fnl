(require :options)
(require :keys)

(let [lazy (require :lazy)
      plugin-spec (require :plugins)
      options {:change_detection {:enabled false}}]
  (lazy.setup plugin-spec options))

