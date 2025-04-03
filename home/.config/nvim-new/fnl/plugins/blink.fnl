;; Completion menu
{1 :saghen/blink.cmp
 :dependencies [:echasnovski/mini.icons]
 :lazy false
 :version :*
 :opts {:appearance {:use_nvim_cmp_as_default true :nerd_font_variant :normal}
        :keymap {:preset :default}}
 :config (fn []
           (let [capabilities ((. (require :blink.cmp) :get_lsp_capabilities))]
             (vim.lsp.config :* {: capabilities})))}
