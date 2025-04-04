local function _1_()
  require("mini.surround").setup({respect_selection_type = true})
  require("mini.move").setup({})
  require("mini.git").setup({})
  require("mini.diff").setup({})
  require("mini.sessions").setup({})
  local config_session_name = "_nvim-config"
  local starter = require("mini.starter")
  local sessions
  local function _2_()
    local tbl_21_ = {}
    local i_22_ = 0
    for _, s in ipairs(starter.sections.sessions(5)()) do
      local val_23_
      if (s.name ~= config_session_name) then
        val_23_ = s
      else
        val_23_ = nil
      end
      if (nil ~= val_23_) then
        i_22_ = (i_22_ + 1)
        tbl_21_[i_22_] = val_23_
      else
      end
    end
    return tbl_21_
  end
  sessions = _2_
  local config_item
  local function _5_()
    local _7_
    do
      local t_6_ = _G.MiniSessions.detected
      if (nil ~= t_6_) then
        t_6_ = t_6_[config_session_name]
      else
      end
      _7_ = t_6_
    end
    if (nil == _7_) then
      do
        local tmp_9_ = vim.fn.stdpath("config")
        vim.api.nvim_set_current_dir(tmp_9_)
        require("oil").open(tmp_9_)
      end
      return _G.MiniSessions.write(config_session_name)
    else
      return _G.MiniSessions.read(config_session_name)
    end
  end
  config_item = {name = "Configure Neovim", action = _5_, section = "Builtin actions"}
  return starter.setup({items = {sessions, config_item, starter.sections.builtin_actions()}})
end
return {"echasnovski/mini.nvim", config = _1_, version = false}