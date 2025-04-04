local profile = require("tmthy.profile")
local success, config = pcall(require, ("plugins.profile." .. profile))
if success then
  return config
else
  vim.notify(("No profile plugin configuration for profile: " .. profile), vim.log.levels.WARN)
  return {}
end