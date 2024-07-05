(local map vim.keymap.set)
(local nmap (partial map :n))
(local imap (partial map :i))
(local vmap (partial map :v))

(vmap :<C-j> ":m '>+1<CR>gv=gv" {:desc "Move Selection Down"})
(vmap :<C-k> ":m '<-2<CR>gv=gv" {:desc "Move Selection Up"})

(vmap ">" :>gv)
(vmap "<" :<gv)

(nmap :<Esc> :<cmd>nohlsearch<CR>)

(nmap :U :<C-r>)

(nmap :gs "^")
(nmap :gl "$")

(imap :jk :<Esc>)

(local telescope-cbs {:lsp {:<leader>S :lsp_workspace_symbols
                            :gr :lsp_references
                            :gd :lsp_definitions
                            :gD :lsp_type_definitions
                            :g<C-d> :lsp_implementations}
                      :global {:<leader><leader> :find_files
                               :<leader>/ :live_grep
                               :<leader>h :help_tags}})

(fn map-builtins [mappings]
  (each [keys picker (pairs mappings)]
    (nmap keys (fn []
                 ((. (require :telescope.builtin) picker))))))

(fn lsp-attach-cb [ev]
  (let [opts {:buffer ev.buf}]
    (map-builtins telescope-cbs.lsp)
    (nmap :<leader>r (fn [] (vim.lsp.buf.rename)) opts)
    (nmap :<leader>a (fn [] (vim.lsp.buf.code_action)) opts) ; (nmap :<leader>x (fn [] (vim.lsp.)))
    (nmap :K vim.lsp.buf.signature_help opts)))

(let [group (vim.api.nvim_create_augroup :UserLspConfig {})]
  (vim.api.nvim_create_autocmd :LspAttach {: group :callback lsp-attach-cb}))

(fn symbols []
  (let [buffers (vim.lsp.get_clients {:bufnr 0})
        builtin (require :telescope.builtin)]
    (if (= 0 (length buffers))
        (builtin.treesitter)
        (builtin.lsp_document_symbols))))

(nmap :<leader>s symbols)

(map-builtins telescope-cbs.global)
