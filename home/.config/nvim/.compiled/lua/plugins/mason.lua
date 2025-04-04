local function _1_()
  local mason = require("mason")
  local mason_registry = require("mason-registry")
  local lsp_names
  do
    local tbl_21_ = {}
    local i_22_ = 0
    for _, c in ipairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
      local val_23_ = vim.fn.fnamemodify(c, ":t:r")
      if (nil ~= val_23_) then
        i_22_ = (i_22_ + 1)
        tbl_21_[i_22_] = val_23_
      else
      end
    end
    lsp_names = tbl_21_
  end
  print("LSP names:", unpack(lsp_names))
  local function ensure_installed(name)
    if mason_registry.has_package(name) then
      local pkg = mason_registry.get_package(name)
      if not pkg:is_installed() then
        return pkg:install()
      else
        return nil
      end
    else
      return nil
    end
  end
  mason.setup()
  local function _5_()
    for _, name in ipairs(lsp_names) do
      ensure_installed(name)
    end
    return vim.lsp.enable(lsp_names)
  end
  return mason_registry.refresh(_5_)
end
return {"williamboman/mason.nvim", dependencies = {{"j-hui/fidget.nvim", config = true}}, config = _1_, lazy = false}