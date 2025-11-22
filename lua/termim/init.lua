local termim = {}

termim.close_augroup = 'termim_auto_close'

termim.auto_close = function()
    vim.api.nvim_create_autocmd({ 'TermClose' }, {
        group = vim.api.nvim_create_augroup(termim.close_augroup, { clear = true }),
        callback = function(event)
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(event.buf) then
              vim.api.nvim_buf_delete(event.buf, { force = true })
            end
          end)
        end,
    })
end

termim.keep_open = function()
    vim.api.nvim_command('augroup ' .. termim.close_augroup)
    vim.api.nvim_command('autocmd!')
    vim.api.nvim_command('augroup END')
end

local open_float = function(command)
  local buf = vim.api.nvim_create_buf(false, true)

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  local win_opts = {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "single"
  }

  vim.api.nvim_open_win(buf, true, win_opts)
  vim.cmd("terminal " .. command)
end

termim.open = function(command, split_dir, keep_open)
    if command == '' or command == nil then
        command = vim.o.shell
    end

    if split_dir == '' or split_dir == nil then
        split_dir = 'tabnew'
    end

    if keep_open then
        termim.keep_open()
    else
        termim.auto_close()
    end

  if split_dir == "float" then
    open_float(command)
  else
    vim.cmd(split_dir .. ' term://' .. command)
  end
end

return termim
