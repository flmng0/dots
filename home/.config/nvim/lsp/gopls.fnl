(let [gopls ((. (require :tmthy.mason) :cmd) :gopls)]
  {:filetypes [:go :gomod :gosum] :root_markers [:go.mod] :cmd [gopls]})
