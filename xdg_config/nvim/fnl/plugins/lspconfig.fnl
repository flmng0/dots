(local servers {:fennel_ls {} :elixirls {}})

; {1 :neovim/nvim-lspconfig
;  :config (fn []
;            (let [lspconfig (require :lspconfig)
;                  capabilities (. (require :cmp_nvim_lsp) :default_capabilities)
;                  default-config {: capabilities}]
;              (each [server config (pairs servers)]
;                (let [opts (vim.tbl_extend :force default-config config)]
;                  ((. (. lspconfig server) :setup) opts)))))}

{1 :neovim/nvim-lspconfig
	; :config TODO
}

