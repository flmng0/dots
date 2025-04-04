local _1_
do
  local js_like
  do
    local tmp_9_ = {"biome", "deno_fmt", "prettierd", "prettier"}
    tmp_9_["stop_after_first"] = true
    js_like = tmp_9_
  end
  local non_auto_format = {"fennel"}
  local function _2_(bufnr)
    if not vim.list_contains(non_auto_format, vim.bo[bufnr].filetype) then
      return {timeout = 500, lsp_format = "fallback"}
    else
      return nil
    end
  end
  _1_ = {formatters_by_ft = {lua = {"stylua"}, fennel = {"fnlfmt"}, javascript = js_like, typescript = js_like, javascriptreact = js_like, typescriptreact = js_like, svelte = js_like, css = js_like, vue = js_like}, format_on_save = _2_}
end
return {"stevearc/conform.nvim", opts = _1_}