local config = require('notebox.config')

--- @class Telescope
local M = {}

--- Find notes by their filename.
--- @param root_directory? string The notebox root directory, defaults to `config.root_directory` config if unspecified.
M.find_note = function(root_directory)
  local user_config = config.get_user_config()
  -- TODO: Ensure that the path is safe.
  root_directory = root_directory or user_config.root_directory

  local opts = {
    cwd = root_directory,
    find_command = { 'rg', '--files', '--ignore', '--glob', '*.md' },
    path_display = { 'truncate' },
    prompt_title = 'Find note',
  }

  require('telescope.builtin').find_files(opts)
end

--- Find notes by their content.
--- @param root_directory? string The notebox root directory, defaults to `config.root_directory` config if unspecified.
M.live_grep_note = function(root_directory)
  local user_config = config.get_user_config()
  -- TODO: Ensure that the path is safe.
  root_directory = root_directory or user_config.root_directory

  local opts = {
    cwd = root_directory,
    prompt_title = 'Live grep note',
    type_filter = 'markdown',
  }

  require('telescope.builtin').live_grep(opts)
end

return M
