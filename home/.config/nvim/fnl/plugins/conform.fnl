; Conform for file formatting
{1 :stevearc/conform.nvim
 :opts (let [js-like (doto [:biome :prettierd :prettier]
                       (tset :stop_after_first true))
             prettier-opts {:append_args ["--print-width" "100"]}
             non-auto-format [:fennel :html]]
         {:formatters_by_ft {:lua [:stylua]
                             :fennel [:fnlfmt]
                             :html js-like
                             :javascript js-like
                             :typescript js-like
                             :javascriptreact js-like
                             :typescriptreact js-like
                             :svelte js-like
                             :css js-like
                             :vue js-like}
          :formatters {:prettierd prettier-opts :prettier prettier-opts}
          :format_on_save (fn [bufnr]
                            (let [buf-disabled (. vim.b bufnr :disable_autoformatting)
                                  ft-disabled (vim.list_contains non-auto-format (. vim.bo bufnr :filetype))
                                  disabled (or ft-disabled buf-disabled)]
                              (when (not disabled)
                                {:timeout 500 :lsp_format :fallback})))})}
