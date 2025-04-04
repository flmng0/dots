(import-macros {: lazy : map} :macros)

(local wk (require :which-key))

; Register groups for Which Key display
(wk.add [{1 :<leader>f :group "Finders"}
         {1 :<leader>c :group "Code Actions"}
         {1 :<leader>d :group "Debugging"}])

(map (:<Esc> :<Cmd>nohl<CR> :desc "Clear highlight") (:U :<C-r> :desc "Redo"))

; Finders

;; fnlfmt: skip
(map {:prefix :<leader>} 
    (:<space> (lazy :fzf-lua :files) :desc "Fuzzy find files")
    (:fh (lazy :fzf-lua :helptags) :desc "Search help pages")
    (:fk (lazy :fzf-lua :keymaps) :desc "Search key mappings")
    (:fr (lazy :fzf-lua :oldfiles) :desc "Search recently opened files")
    (:/ (lazy :fzf-lua :live_grep) :desc "Live grep"))

; Various plugin method calls
(map (:- (lazy :oil :open) :desc "Open Oil.nvim in current directory")
     (:<leader>cf (lazy :conform :format) :desc "Format current file"))

;; fnlfmt: skip
(fn lsp-attach [{: buf}]
  (map {:buffer buf}
       (:<leader>ca vim.lsp.buf.code_action :desc "[LSP] List code actions" :mode :nv)
       (:<leader>cr vim.lsp.buf.rename :desc "[LSP] Rename symbol")
       (:gr (lazy :fzf-lua :lsp_references) :desc "[LSP] Goto or find symbol's references")
       (:gt (lazy :fzf-lua :lsp_type_definitions) :desc "[LSP] Goto or find symbol's type definition")
       (:gd (lazy :fzf-lua :lsp_definitions) :desc "[LSP] Goto or find symbol's definition")
       (:gD vim.lsp.buf.declaration :desc "[LSP] Goto symbol declaration")
       (:<leader>fs (lazy :fzf-lua :lsp_document_symbols) :desc "[LSP] Find symbols in current document")
       (:<leader>fw (lazy :fzf-lua :lsp_workspace_symbols) :desc "[LSP] Find symbols in workspace")))

(let [group (vim.api.nvim_create_augroup :tmthy.keys.lsp {:clear true})]
  (vim.api.nvim_create_autocmd :LspAttach {: group :callback lsp-attach}))
