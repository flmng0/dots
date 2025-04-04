local function _1_()
  local capabilities = require("blink.cmp").get_lsp_capabilities()
  return vim.lsp.config("*", {capabilities = capabilities})
end
return {"saghen/blink.cmp", dependencies = {"echasnovski/mini.icons"}, version = "*", opts = {appearance = {use_nvim_cmp_as_default = true, nerd_font_variant = "normal"}, keymap = {preset = "default"}}, config = _1_, lazy = false}