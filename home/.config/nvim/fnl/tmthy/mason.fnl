(local mason-registry (require :mason-registry))

(fn path [lsp-name]
  "Returns the installation path for an LSP"
  (-> (mason-registry.get_package lsp-name)
      (: :get_install_path)))

(fn cmd [lsp-name bin-name]
  "Returns the absolute path for an LSP, including the binary, using Mason"
  (let [bin-name (or bin-name lsp-name)]
    (-?> (path lsp-name)
         (vim.fs.joinpath bin-name))))

(fn ensure-installed [name]
  (when (mason-registry.has_package name)
    (let [pkg (mason-registry.get_package name)]
      (when (not (pkg:is_installed))
        (pkg:install)))))

{: path : cmd : ensure-installed}
