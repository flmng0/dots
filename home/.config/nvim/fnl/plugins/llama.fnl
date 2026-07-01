{1 :ggml-org/llama.vim
 :init (fn []
         (set vim.g.llama_config 
              {:auto_fim false
               :endpoint_fim (.. vim.env.LLAMA_SERVER_URL "/infill")
               :endpoint_inst (.. vim.env.LLAMA_SERVER_URL "/v1/chat/completions")
               :model_fim vim.env.LLAMA_FIM_MODEL
               :model_inst vim.env.LLAMA_INST_MODEL
               ; Configured in keys.fnl
               :keymap_fim_trigger ""
               :keymap_fim_accept_full ""
               :keymap_fim_accept_line ""
               :keymap_fim_next ""
               :keymap_fim_prev ""
               :keymap_inst_trigger ""
               :keymap_inst_rerun ""
               :keymap_inst_continue ""
               :keymap_inst_accept ""
               :keymap_inst_cancel ""
               :keymap_debug_toggle ""}))}
