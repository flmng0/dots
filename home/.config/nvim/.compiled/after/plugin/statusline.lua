local function term(code)
  return vim.api.nvim_replace_termcodes(code, true, true, true)
end
local ctrl_v = term("<C-V>")
local ctrl_s = term("<C-S>")
local function hl(name)
  return ("%#" .. name .. "#")
end
local function component(text, hl_name, padding)
  local padding_text = string.rep(" ", (padding or 0))
  return table.concat({hl(hl_name), padding_text, text, padding_text})
end
local function status_line()
  local function mode()
    local function mode_obj(text, hl0)
      local hl1 = (hl0 or text)
      return {text = text, hl = ("StatusLineMode" .. hl1)}
    end
    local node_map = {n = mode_obj("Normal"), v = mode_obj("Visual"), V = mode_obj("V-Line", "Visual"), [ctrl_v] = mode_obj("V-Block", "Visual"), s = mode_obj("Select"), S = mode_obj("S-Line", "Select"), [ctrl_s] = mode_obj("S-Block", "Select"), i = mode_obj("Insert"), R = mode_obj("Replace"), c = mode_obj("Command"), r = mode_obj("Prompt", "Other"), ["!"] = mode_obj("Shell", "Other"), t = mode_obj("Terminal", "Other")}
    local default = mode_obj("Unknown", "Other")
    local mode_info = (node_map[vim.fn.mode()] or default)
    return component(mode_info.text, mode_info.hl, 1)
  end
  local function branch()
    local _1_ = vim.b.minigit_summary
    if ((_G.type(_1_) == "table") and (nil ~= _1_.head_name)) then
      local head_name = _1_.head_name
      local head_name0 = head_name:gsub("^feature/(%a+%-%d+).*", "f/%1")
      return component(("\238\156\165 " .. head_name0), "StatusLineGitBranch", 2)
    else
      local _ = _1_
      return ""
    end
  end
  local function diff()
    local function display_diff(diff_tbl, n, icon, hl0)
      if (n > 0) then
        return table.insert(diff_tbl, component((icon .. " " .. tostring(n)), hl0))
      else
        return nil
      end
    end
    local _4_ = vim.b.minidiff_summary
    local and_5_ = ((_G.type(_4_) == "table") and (nil ~= _4_.status))
    if and_5_ then
      local status = _4_.status
      and_5_ = (status == "??")
    end
    if and_5_ then
      local status = _4_.status
      return component("\239\147\144", "StatusLineGitUnstaged", 1)
    elseif ((_G.type(_4_) == "table") and (nil ~= _4_.add) and (nil ~= _4_.change) and (nil ~= _4_.delete)) then
      local add = _4_.add
      local change = _4_.change
      local delete = _4_.delete
      local text
      local _7_
      do
        local tmp_9_ = {}
        display_diff(tmp_9_, add, "\239\145\151", "StatusLineGitAdd")
        display_diff(tmp_9_, change, "\239\145\153", "StatusLineGitChange")
        display_diff(tmp_9_, delete, "\239\145\152", "StatusLineGitDelete")
        _7_ = tmp_9_
      end
      text = table.concat(_7_, " ")
      if (#text > 0) then
        return component(text, "StatusLineGitBranch", 1)
      else
        return nil
      end
    else
      local _ = _4_
      return ""
    end
  end
  local function lsp_status()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({bufnr = bufnr})
    if (#(clients or {}) > 0) then
      local names
      do
        local tbl_21_ = {}
        local i_22_ = 0
        for _, client in ipairs(clients) do
          local val_23_ = client.name
          if (nil ~= val_23_) then
            i_22_ = (i_22_ + 1)
            tbl_21_[i_22_] = val_23_
          else
          end
        end
        names = tbl_21_
      end
      local names_text = table.concat(names, ", ")
      local icon_text = "\243\176\136\184"
      return component((component(icon_text, "StatusLineLspIcon") .. " " .. component(names_text, "StatusLineLspNames")), "StatusLineLspNames", 1)
    else
      return nil
    end
  end
  local function join(...)
    local components = {...}
    local total = #components
    local function _12_(...)
      local tbl_21_ = {}
      local i_22_ = 0
      for i, comp in ipairs(components) do
        local val_23_
        if ((nil ~= comp) and ("" ~= comp)) then
          local is_last = (i == total)
          local is_special = ((#comp == 2) and ("%" == string.sub(comp, 1, 1)))
          if (is_last or is_special) then
            val_23_ = comp
          else
            val_23_ = (comp .. "%#StatusLine# ")
          end
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
    return table.concat(_12_(...))
  end
  return join(mode(), "%<", branch(), component("%f", "StatusLine"), diff(), "%=", lsp_status(), component("%l:%c", "StatusLine"))
end
_G["TmthyStatusLine"] = status_line
vim.o["statusline"] = " %{%v:lua.TmthyStatusLine()%} "
return nil