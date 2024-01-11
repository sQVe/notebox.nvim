local Path = require('plenary.path')
local config = require('notebox.config')
local utils = require('notebox.utils')

--- @class Template
local M = {}

--- Get the contents of a template.
--- @param template_name string Name of the template file to retrieve content from.
--- @param variables table<string, string> Key-value table with placeholder replacements.
M.get_template_content = function(template_name, variables)
  variables = variables or {}

  local user_config = config.get_user_config()
  local template_directory = Path:new({
    user_config.root_directory,
    user_config.subdirectories.templates,
  })
  local template_path = template_directory:joinpath(template_name .. '.md')

  if not template_path:is_file() then
    return ''
  end

  local absolute_template_path = template_path:absolute()
  local content = utils.read_file(absolute_template_path)

  return utils.replace_placeholders(content, variables)
end

return M
