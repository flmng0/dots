; Conform for file formatting
{1 :stevearc/conform.nvim
 :opts (let [js-like (doto [:biome :deno_fmt :prettierd :prettier]
                       (tset :stop_after_first true))
             non-auto-format [:fennel]]
         {:formatters_by_ft {:lua [:stylua]
                             :fennel [:fnlfmt]
                             :javascript js-like
                             :typescript js-like
                             :javascriptreact js-like
                             :typescriptreact js-like
                             :svelte js-like
                             :css js-like
                             :vue js-like}
          :format_on_save (fn [bufnr]
                            (when (not (vim.list_contains non-auto-format (. vim.bo bufnr :filetype)))
                              {:timeout 500 :lsp_format :fallback}))})}
