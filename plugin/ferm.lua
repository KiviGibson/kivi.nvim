vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>')

local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}
local function create_float(opts)
  opts = opts or {}
  -- Get the current editor dimensions
  local width = vim.o.columns
  local height = vim.o.lines

  -- Calculate 80% of the dimensions
  local win_width = math.floor(width * 0.8)
  local win_height = math.floor(height * 0.8)

  -- Calculate centered position
  local row = math.floor((height - win_height) / 2)
  local col = math.floor((width - win_width) / 2)

  -- Create the floating window
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end
  local win_config = {
    style = 'minimal',
    relative = 'editor',
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    border = 'rounded', -- you can change this to "single", "double", "none", etc.
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)

  -- Set some buffer options (optional)
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].filetype = 'float'

  -- Return the buffer and window handles
  return { buf = buf, win = win }
end

local toggle = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_float(state.floating)
    if vim.bo[state.floating.buf].buftype ~= 'terminal' then
      vim.cmd.term()
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

vim.api.nvim_create_user_command('Ferm', toggle, {})

vim.keymap.set({ 'n', 't' }, '<space>tt', toggle)
