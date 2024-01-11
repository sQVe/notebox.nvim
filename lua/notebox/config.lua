local defaults = require('notebox.defaults')

--- @class Config
--- @field private _user_config UserConfig? The user's configuration.
local M = {
  _user_config = nil,
}

--- Retrieves the user's configuration.
--- @return UserConfig config
M.get_user_config = function()
  return M._user_config
end

--- Configures the module by merging default settings with user overrides.
--- @param overrides? UserConfig Overrides to be merged with the defaults.
--- @return UserConfig config
M.setup = function(overrides)
  M._user_config = vim.tbl_deep_extend('force', defaults, overrides or {})

  return M._user_config
end

return M
