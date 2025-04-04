local function _1_(mapping)
  return ("" ~= (mapping.preset or mapping.plugin or mapping.desc))
end
local function _2_(node)
  return not node.desc
end
return {"folke/which-key.nvim", opts = {preset = "helix", plugins = {marks = true, registers = true, spelling = {enabled = true, suggestions = 20}, presets = {text_objects = true, windows = true, nav = true, z = true, g = true, motions = false, operators = false}}, triggers = {{"<auto>", mode = "nxso"}, {"<leader>", mode = "nv"}, {"<localleader>", mode = "n"}}, filter = _1_, expand = _2_, icons = {mappings = false}, win = {border = "none", padding = {1, 3}}, show_help = false}}