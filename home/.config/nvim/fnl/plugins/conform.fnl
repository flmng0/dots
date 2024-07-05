; Easy-to-configure formatters.
{1 :stevearc/conform.nvim
 :config (fn []
           (let [conform (require :conform)
                 formatters_by_ft {:lua [:stylua]
                                   :elm [:elm_format]
                                   :javascript [:prettierd :prettier]
                                   :typescript [:prettierd :prettier]
                                   :svelte [:prettierd :prettier]
                                   :clojure [:cljfmt]
                                   :ocaml [:ocamlformat]
                                   :fennel [:fnlfmt]}
                 formatters {:cljfmt {:command :cljfmt
                                      :args [:fix]
                                      :stdin false}}]
             (conform.setup {: formatters_by_ft
                             : formatters
                             :format_on_save {:timeout_ms 500
                                              :lsp_fallback true}})))}
