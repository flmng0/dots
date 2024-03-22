(require :options)

(let [lazy (require :lazy)
      plugin-spec (require :plugins)]
  (lazy.setup plugin-spec {:change_detection {:enabled false}}))

