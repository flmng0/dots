local function _1_()
  local kanagawa = require("kanagawa")
  local overrides
  local function _2_(colors)
    local p = colors.palette
    local winbar = {WinBarMain = {bg = p.sakuraPink, fg = p.sumiInk0}, WinBarEnd = {fg = p.sakuraPink}, WinBarMainNC = {bg = p.sumiInk4, fg = p.springViolet1}, WinBarEndNC = {fg = p.sumiInk4}}
    local info_bg = p.sumiInk4
    local status_line = {StatusLineGitBranch = {bg = info_bg, fg = p.oldWhite}, StatusLineGitAdd = {bg = info_bg, fg = p.autumnGreen}, StatusLineGitChange = {bg = info_bg, fg = p.autumnYellow}, StatusLineGitDelete = {bg = info_bg, fg = p.autumnRed}, StatusLineGitUnstaged = {bg = info_bg, fg = p.crystalBlue}, StatusLineLspIcon = {bg = info_bg, fg = p.crystalBlue}, StatusLineLspNames = {bg = info_bg, fg = p.oldWhite, italic = true}}
    local status_line0
    do
      local tbl_16_ = status_line
      for _, mode in ipairs({"Normal", "Visual", "Select", "Insert", "Replace", "Command", "Other"}) do
        local k_17_, v_18_ = ("StatusLineMode" .. mode), {link = ("MiniStatusLineMode" .. mode)}
        if ((k_17_ ~= nil) and (v_18_ ~= nil)) then
          tbl_16_[k_17_] = v_18_
        else
        end
      end
      status_line0 = tbl_16_
    end
    return vim.tbl_extend("error", {}, winbar, status_line0)
  end
  overrides = _2_
  kanagawa.setup({overrides = overrides})
  return vim.cmd("colorscheme kanagawa")
end
return {"rebelot/kanagawa.nvim", priority = 1000, config = _1_, lazy = false}