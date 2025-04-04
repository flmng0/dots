vim.g["code_dir"] = vim.fn.expand("~/code")
vim.opt["breakindent"] = true
vim.opt["ignorecase"] = true
vim.opt["smartcase"] = true
vim.opt["updatetime"] = 250
vim.opt["timeoutlen"] = 300
vim.opt["number"] = true
vim.opt["showmode"] = false
vim.opt["scrolloff"] = 10
vim.opt["cursorline"] = true
vim.opt["wrap"] = false
vim.opt_global["tabstop"] = 4
vim.opt_global["shiftwidth"] = 4
vim.opt["signcolumn"] = "number"
vim.opt["laststatus"] = 3
vim.opt["sessionoptions"] = {"curdir", "folds", "help", "tabpages", "winsize"}
if vim.g.neovide then
  vim.opt["guifont"] = "JetBrainsMono NF:h11"
  vim.g["neovide_position_animation_length"] = 0
else
end
local augroup = vim.api.nvim_create_augroup("tmthy_options", {clear = true})
local function _2_(ev)
  vim.opt["cursorline"] = vim.startswith(ev.match, "i")
  return nil
end
return vim.api.nvim_create_autocmd("ModeChanged", {pattern = {"i:*", "*:i"}, callback = _2_, group = augroup})