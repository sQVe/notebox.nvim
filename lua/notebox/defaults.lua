--- @alias GenerateNoteId fun(type: ('daily' | 'note')?, title: string?): string
--- @alias GetOpenOptions fun(): { command: string, args: string[] }

--- @class UserConfig
--- @field generate_note_id GenerateNoteId? A callback function that returns the id of a note.
--- @field get_open_options GetOpenOptions? A callback function that returns the options to feed into the open process.
--- @field root_directory string The default root directory where notebox will store notes. Defaults to `$HOME/notebox`.
--- @field subdirectories table Subdirectory names within the root_directory.
--- @field subdirectories.dailies string Subdirectory for daily notes. Defaults to `dailies`.
--- @field subdirectories.new_notes string Subdirectory for newly created notes. Defaults to `inbox`.
--- @field subdirectories.templates string Subdirectory for note templates. Defaults to `templates`.
local M = {
  generate_note_id = nil,
  get_open_options = nil,
  root_directory = vim.fn.expand('$HOME') .. '/notebox',
  subdirectories = {
    dailies = 'dailies',
    new_notes = 'inbox',
    templates = 'templates',
  },
}

return M
