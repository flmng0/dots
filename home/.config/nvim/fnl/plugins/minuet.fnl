(local minuet
  {1 :milanglacier/minuet-ai.nvim
   :opts {:virtualtext
           {:auto_trigger_ft []
            :keymap {:accept "<D-S-y>"
                     :accept_line "<D-y>"
                     :dismiss "<C-c>"
                     :next "<C-f>"
                     :prev "<C-S-f>"}}
           :provider "openai_fim_compatible"
           :n_completions 1
           :context_window 512
           :provider_options
           {:openai_fim_compatible
            {:api_key "TERM"
             :name "LlamaBarn"
             :end_point "http://localhost:2276/v1/completions"
             :model (or vim.env.LLAMACPP_MODEL "Uh oh")
             :optional {:max_tokens 56
                        :top_p 0.9}
             :template
             {:prompt (fn [ctx-before ctx-after _]
                        (.. "<|fim_prefix|>" ctx-before "<|fim_suffix|>" ctx-after "<|fim_middle|>"))
              :suffix false}}}}})

(if _G.work minuet {})
