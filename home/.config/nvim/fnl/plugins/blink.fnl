;; Completion menu
{1 :saghen/blink.cmp
 :dependencies [:echasnovski/mini.icons 
                :echasnovski/mini.snippets
                :kristijanhusak/vim-dadbod-completion]
 :lazy false
 :version :*
 :opts {:appearance {:use_nvim_cmp_as_default true :nerd_font_variant :normal}
        :snippets {:preset "mini_snippets"}
        :sources {:default ["lsp" "path" "snippets" "buffer"]
                  :per_filetype
                  {:sql ["snippets" "dadbod" "buffer"]}
                  :providers
                  {:dadbod {:name "Dadbod" :module "vim_dadbod_completion.blink"}}}
        :completion {:menu {:auto_show true}
                     :ghost_text {:enabled true}}}}
