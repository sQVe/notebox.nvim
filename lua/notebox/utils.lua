local Path = require('plenary.path')
local uv = vim.loop

--- @class Utils
--- @field private _current_os string? Holds the cached value of the current operating system.
local M = {
  _current_os = nil,
}

--- Retrieves the current operating system.
M.get_os = function()
  if M._current_os ~= nil then
    return M._current_os
  end

  local uname = uv.os_uname()
  local is_windows = uv.os_uname().version:match('Windows')

  M._current_os = is_windows and 'Windows' or uname.sysname

  return M._current_os
end

--- Escapes special characters in a string pattern.
--- @param str string The string containing pattern characters to escape.
M.escape_pattern = function(str)
  return str:gsub('[-%%]%[().*+?^$]', '%%%1')
end

--- Read the contents of a file.
--- @param file_path string The path to the file.
M.read_file = function(file_path)
  local stream, err = io.open(file_path, 'r')
  if not stream then
    error('Error when reading file: ' .. (err or 'unknown error'))
  end
  local content = stream:read('*a')
  stream:close()

  return content
end

--- Replaces placeholders within a string with provided variable values.
--- @param str string The string with placeholders to be replaced.
--- @param variables table<string, string> A table with placeholder-replacement pairs.
M.replace_placeholders = function(str, variables)
  for placeholder, replacement in pairs(variables) do
    local escaped_replacement = M.escape_pattern(replacement)
    str = str:gsub('{{' .. placeholder .. '}}', escaped_replacement)
  end

  return str
end

--- Convert a given string to kebab-case.
--- @param str string String to convert to kebab-case.
M.to_kebab_case = function(str)
  local lower_str = str:lower()
  local space_to_hyphen_str = lower_str:gsub('%s+', '-')

  -- Remove all non-alphanumeric characters except hyphens.
  return space_to_hyphen_str:gsub('[^%w%-]+', '')
end

--- URL-encodes a string by converting non-alphanumeric characters to percent-encoded equivalents.
--- @param str string The string to be URL-encoded.
M.urlencode = function(str)
  -- Convert LF to CR+LF, ensuring that newlines are recognized by systems like Windows.
  str = string.gsub(str, '\n', '\r\n')
  -- Replace all non-alphanumeric characters with their percent-encoded equivalents.
  str = string.gsub(str, '([^%w %-%_%.%~])', function(char)
    return string.format('%%%02X', string.byte(char))
  end)
  -- Replace all spaces with the percent-encoded equivalent.
  str = str:gsub(' ', '%%20')

  return str
end

--- Write the content to a file.
--- @param file_path string The path to the file.
--- @param content string The content to write to the file.
M.write_file = function(file_path, content)
  local stream, err = io.open(file_path, 'w')
  if not stream then
    error('Error when writing file: ' .. (err or 'unknown error'))
  end

  stream:write(content)
  stream:close()
end

return M
