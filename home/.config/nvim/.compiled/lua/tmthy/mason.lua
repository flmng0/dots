local function path(lsp_name)
  local mason_registry = require("mason-registry")
  return mason_registry.get_package(lsp_name):get_install_path()
end
local function cmd(lsp_name, bin_name)
  local bin_name0 = (bin_name or lsp_name)
  local tmp_3_ = path(lsp_name)
  if (nil ~= tmp_3_) then
    return vim.fs.joinpath(tmp_3_, bin_name0)
  else
    return nil
  end
end
return {path = path, cmd = cmd}