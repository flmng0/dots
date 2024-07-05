(local map vim.keymap.set)
(local nmap (partial map :n))
(local imap (partial map :i))
(local vmap (partial map :v))

(vmap :C-j ":m '>+1<CR>gv=gv" {:desc "Move Selection Down"})
(vmap :C-k ":m '<-2<CR>gv=gv" {:desc "Move Selection Up"})

(vmap ">" :>gv)
(vmap "<" :<gv)

(nmap :<Esc> :<cmd>nohlsearch<CR>)

(nmap :U :<C-r>)

(nmap :gs "^")
(nmap :gl "$")

(imap :jk :<Esc>)

(fn lsp-attach-cb [ev]
  (let [opts {:buffer ev.buf}]
    (nmap :K vim.lsp.buf.signature_help opts)))

(let [group (vim.api.nvim_create_augroup :UserLspConfig {})]
  (vim.api.nvim_create_autocmd :LspAttach {: group :callback lsp-attach-cb}))
