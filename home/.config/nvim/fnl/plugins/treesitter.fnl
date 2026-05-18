{1 :nvim-treesitter/nvim-treesitter
 :lazy false
 :build ":TSUpdate"
 :opts {:auto_install true
        :highlight {:enable true}}
 :config (fn [_ opts]
           (let [configs (require "nvim-treesitter.configs")]
             (configs.setup opts)))}

