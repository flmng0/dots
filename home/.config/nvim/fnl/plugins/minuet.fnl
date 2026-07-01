; {1 :milanglacier/minuet-ai.nvim
;  :enabled _G.iswork
;  :opts {:virtualtext
;         {:keymap
;          {:accept "<C-S-y>"
;           :accept_line "<C-y>"
;           :accept_n_line "<C-z>"
;           :next "<C-f>"
;           :prev "<C-S-f>"
;           :dismiss "<C-e>"}}
;         :provider "openai_fim_compatible"
;         :n_completions 1
;         :add_single_line_entry false
;         :context_window 512
;         :provider_options
;         {:openai_fim_compatible
;          {:api_key "TERM"
;           :name "LlamaBarn"
;           :end_point "http://localhost:2276/v1/completions"
;           :model (or vim.env.LLAMACPP_MODEL "Uh oh")
;           :optional {:max_tokens 56
;                      :top_p 0.9}
;           :template
;           {:prompt (fn [ctx-before ctx-after _]
;                      (.. "<|fim_prefix|>" ctx-before "<|fim_suffix|>" ctx-after "<|fim_middle|>"))
;            :suffix false}}}}}
;
{}
