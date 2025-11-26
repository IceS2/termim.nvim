local termim = {}

termim.PersistentTerm = {
    buf = nil,
    win = nil,
}


termim.is_persistent = function(buf)
    return termim.PersistentTerm.buf == buf
end

termim.close_augroup = 'termim_auto_close'

termim.auto_close = function()
    vim.api.nvim_create_autocmd({ 'TermClose' }, {
        group = vim.api.nvim_create_augroup(termim.close_augroup, { clear = true }),
        callback = function(event)
<<<<<<< HEAD
            if termim.is_persistent(event.buf) then
                return
            end
=======
>>>>>>> @{-1}
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

<<<<<<< HEAD
local get_float_win = function()
=======
termim.open_float = function(command)
    local buf = vim.api.nvim_create_buf(false, true)

>>>>>>> @{-1}
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)
<<<<<<< HEAD
    return {
      relative = "editor",
      width = width,
      height = height,
      row = row,
      col = col,
      style = "minimal",
      border = "single"
    }
end

termim.open = function(command, split_dir, keep_open, persist)
    persist = persist or false
    local buf = nil
    local win = nil

=======
    local win_opts = {
        relative = 'editor',
        width = width,
        height = height,
        row = row,
        col = col,
        style = 'minimal',
        border = 'single',
    }

    vim.api.nvim_open_win(buf, true, win_opts)
    vim.cmd('terminal ' .. command)
end

termim.open = function(command, split_dir, keep_open)
>>>>>>> @{-1}
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

<<<<<<< HEAD
    if split_dir == "float" then
        buf = vim.api.nvim_create_buf(persist, not persist)
        win = vim.api.nvim_open_win(buf, true, get_float_win())
        vim.api.nvim_set_current_win(win)
        if persist then
            termim.PersistentTerm.buf = buf
            termim.PersistentTerm.win = win
        end
        vim.cmd("terminal " .. command)
    else
        buf = vim.api.nvim_create_buf(persist, not persist)
        vim.cmd(split_dir)
        win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(win, buf)
        vim.api.nvim_set_current_win(win)
        if persist then
            termim.PersistentTerm.buf = buf
            termim.PersistentTerm.win = win
        end
        vim.cmd("terminal " .. command)
    end
end

termim.toggle = function(split_dir)
    if termim.PersistentTerm.buf == nil then
        termim.open(nil, split_dir, true, true)
    elseif termim.PersistentTerm.win ~= nil and vim.api.nvim_win_is_valid(termim.PersistentTerm.win) then
        vim.api.nvim_win_close(termim.PersistentTerm.win, true)
        termim.PersistentTerm.win = nil
    else
        local win = nil
        if split_dir == "float" then
          win = vim.api.nvim_open_win(termim.PersistentTerm.buf, true, get_float_win())
        else
            vim.cmd(split_dir)
            win = vim.api.nvim_get_current_win()
            vim.api.nvim_win_set_buf(win, termim.PersistentTerm.buf)
        end
        vim.cmd("startinsert!")
        termim.PersistentTerm.win = win
=======
    if split_dir == 'float' then
        termim.open_float(command)
    else
        vim.cmd(split_dir .. ' term://' .. command)
>>>>>>> @{-1}
    end
end

return termim
