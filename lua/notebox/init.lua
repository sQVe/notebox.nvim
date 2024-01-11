local config = require('notebox.config')

--- @class Init
local M = {}

--- Sets up the plugin.
--- @param overrides? UserConfig Configration which will override the defaults.
M.setup = function(overrides)
  -- Expose a subset of the API globally for 'operatorfunc' to use.
  _G.notebox = M

  local map = function(mode, lhs, rhs, opts)
    if lhs == '' then
      return
    end
    opts = vim.tbl_deep_extend('force', { silent = true }, opts or {})
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  map('n', 'gö', M.create_normal_mode_mapping(), { expr = true, desc = 'Tmp' })
  map('x', 'gö', M.create_visual_mode_mapping(), { desc = 'Tmp' })

  local user_config = config.setup(overrides)
end

M.create_normal_mode_mapping = function()
  return function()
    -- Set 'operatorfunc' which will be later called with appropriate marks set
    vim.o.operatorfunc = 'v:lua.notebox.tmp'
    return 'g@'
  end
end

M.create_visual_mode_mapping = function()
  return function()
    local modes = {
      ['V'] = 'line',
      ['v'] = 'char',
      ['\22'] = 'block',
    }
    local mode = modes[vim.fn.mode(1)]

    M.tmp(mode)
    vim.cmd('normal! \27')
  end
end

M.tmp = function(mode)
  if mode == 'char' then
    print(vim.inspect(M.get_current_region()))
    vim.cmd('normal! c')
  end
end

M.is_visual_mode = function()
  return vim.tbl_contains({ 'V', 'v', '\22' }, vim.fn.mode(1))
end

M.get_current_region = function()
  -- The expression for marks differs depending on whether we're in visual mode or not.
  local from_mark, to_mark =
    M.is_visual_mode() and '.' or "'[", M.is_visual_mode() and 'v' or "']"

  local function make_position(mark)
    local position = vim.fn.getpos(mark) or {}
    return { line = position[2], column = position[3] + position[4] }
  end

  local from = make_position(from_mark)
  local to = make_position(to_mark)

  -- Swap if 'to' is before 'from'
  if
    to.line < from.line or (to.line == from.line and to.column < from.column)
  then
    return { from = to, to = from }
  end

  return { from = from, to = to }
end

return M
