;; Completion menu
{1 :saghen/blink.cmp
 :dependencies [:echasnovski/mini.icons]
 :lazy false
 :version :*
 :opts {:appearance {:use_nvim_cmp_as_default true :nerd_font_variant :normal}
        :completion {:menu {:auto_show false}
                     :ghost_text {:enabled true :show_with_menu false}}}}
