(let [tsls ((. (require :tmthy.mason) :cmd) :typescript-language-server)]
  {:filetypes [:javascript 
               :javascriptreact 
               :typescript 
               :typescriptreact 
               :vue 
               :svelte]
   :cmd [tsls :--stdio]})
