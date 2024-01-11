local Path = require('plenary.path')
local Job = require('plenary.job')
local config = require('notebox.config')
local template = require('notebox.template')
local utils = require('notebox.utils')

--- @class Note
local M = {}

--- Generate a note id.
--- @private
--- @param note_type ('daily' | 'note')? The type of the note. Defaults to 'note'.
--- @param note_title string? The title of the note.
M._generate_note_id = function(note_type, note_title)
  note_title = note_title or ''
  note_type = note_type or 'note'

  local user_config = config.get_user_config()
  local generate_note_id = user_config.generate_note_id

  if generate_note_id then
    return generate_note_id(note_type, note_title)
  end

  local current_date = tostring(os.date('%Y%m%d'))
  local current_day = tostring(os.date('%A'))

  if note_title == '' or note_type == 'daily' then
    return current_date .. '-' .. current_day:lower()
  end

  return current_date .. '-' .. utils.to_kebab_case(note_title)
end

--- Get the absolute path of the current buffer.
--- @private
M._get_absolute_buffer_path = function()
  local current_buffer_path = Path:new((vim.fn.expand('%:p') or ''))
  local absolute_buffer_path = current_buffer_path:absolute()

  return absolute_buffer_path
end

--- Create a new note.
--- @param note_type ('daily' | 'note')? The type of the note to create. Defaults to 'note'.
--- @param note_title string? The title of the note to create. User will be prompted for the title if not provided.
--- @param use_buffer_directory? boolean Whether to create the new note in the same directory as the current buffer. Defaults to `false`.
M.new_note = function(note_type, note_title, use_buffer_directory)
  note_type = note_type or 'note'
  note_title = note_title or ''
  use_buffer_directory = use_buffer_directory or false

  if note_type == 'daily' then
    note_title = tostring(os.date('%Y-%m-%d %A'))
  end

  if #note_title == 0 then
    note_title = vim.fn.input('Note title: ')
  end

  local user_config = config.get_user_config()
  local subdirectory = note_type == 'daily'
      and (user_config.subdirectories.dailies or '')
    or (user_config.subdirectories.new_notes or '')
  local note_directory = use_buffer_directory
      and Path:new((vim.fn.expand('%:p:h') or ''))
    or Path:new({
      user_config.root_directory,
      subdirectory or '',
    })

  -- Ensure that the note directory exists.
  note_directory:mkdir({ parents = true })

  local note_id = type(user_config.generate_note_id) == 'function'
      and user_config.generate_note_id(note_type, note_title)
    or M._generate_note_id(note_type, note_title)
  local note_path = Path:new({ note_directory, note_id .. '.md' })
  local absolute_note_path = note_path:absolute()

  if not note_path:is_file() then
    utils.write_file(
      absolute_note_path,
      template.get_template_content(note_type, {
        date = tostring(os.date('%Y-%m-%d')),
        id = note_id,
        title = note_title,
      })
    )
  end

  vim.cmd('edit ' .. absolute_note_path)
end

--- Open the current note in the system default application.
M.open_note = function()
  local current_os = utils.get_os()
  local user_config = config.get_user_config()
  local open_options = {
    command = 'open',
    args = { M._get_absolute_buffer_path() },
  }

  if current_os == 'Linux' then
    open_options.command = 'xdg-open'
  end

  if type(user_config.get_open_options) == 'function' then
    open_options = vim.tbl_extend(
      'force',
      open_options,
      user_config.get_open_options() or {}
    )
  end

  Job:new(open_options):start()
end

return M
