local function _1_()
  local kanagawa = require("kanagawa")
  local overrides
  local function _2_(colors)
    local p = colors.palette
    local winbar = {WinBarMain = {bg = p.sakuraPink, fg = p.sumiInk0}, WinBarEnd = {fg = p.sakuraPink}, WinBarMainNC = {bg = p.sumiInk4, fg = p.springViolet1}, WinBarEndNC = {fg = p.sumiInk4}}
    local info_bg = p.sumiInk4
    local status_line = {StatusLineGitBranch = {bg = info_bg, fg = p.oldWhite}, StatusLineGitAdd = {bg = info_bg, fg = p.autumnGreen}, StatusLineGitChange = {bg = info_bg, fg = p.autumnYellow}, StatusLineGitDelete = {bg = info_bg, fg = p.autumnRed}, StatusLineGitUnstaged = {bg = info_bg, fg = p.crystalBlue}, StatusLineLspIcon = {bg = info_bg, fg = p.crystalBlue}, StatusLineLspNames = {bg = info_bg, fg = p.oldWhite, italic = true}}
    for _, mode in ipairs({"Normal", "Visual", "Select", "Insert", "Replace", "Command", "Other"}) do
      status_line[("StatusLineMode" .. mode)] = {link = ("MiniStatusLineMode" .. mode)}
    end
    return vim.tbl_extend("error", {}, winbar, status_line)
  end
  overrides = _2_
  kanagawa.setup({overrides = overrides})
  return vim.cmd("colorscheme kanagawa")
end
return {{"rebelot/kanagawa.nvim", priority = 1000, config = _1_, lazy = false}, "tpope/vim-sleuth", {"echasnovski/mini.icons", config = true}, {"stevearc/oil.nvim", dependencies = {"echasnovski/mini.icons"}, config = true}, {"ibhagwan/fzf-lua", dependencies = {"echasnovski/mini.icons"}, config = true}, {"windwp/nvim-ts-autotag", dependencies = {"nvim-treesitter/nvim-treesitter"}, opts = {opts = {enable_close = true, enable_rename = true, enable_close_on_slash = true}}}, {"windwp/nvim-autopairs", opts = {map_cr = true}}, {"stevearc/dressing.nvim", opts = {input = {border = "single"}, select = {builtin = {border = "none"}}}}}