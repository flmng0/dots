(fn path [lsp-name]
  (let [mason-registry (require :mason-registry)]
    (-> (mason-registry.get_package lsp-name)
        (: :get_install_path))))

(fn cmd [lsp-name bin-name]
  (let [bin-name (or bin-name lsp-name)]
    (-?> (path lsp-name)
         (vim.fs.joinpath bin-name))))

{: path : cmd}
