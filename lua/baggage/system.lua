local if_nil = vim.F.if_nil

return function (command, callback, opts)
  opts = if_nil(opts, {})
  opts.sync = if_nil(opts.sync, false)
  opts.ignore_errors = if_nil(opts.ignore_errors, false)
  opts.cmd = if_nil(opts.cmd, {})

  if type(command) == "string" then
    command = { command }
  end

  local cmd_opts = vim.tbl_deep_extend("keep", { text = true }, opts.cmd)

  local result = vim.system(command, cmd_opts, vim.schedule_wrap(function(result)
    if (not opts.ignore_errors) and result.code ~= 0 then
      local message = opts.error_msg or "Failed to run shell command"
      error(message .. ": %s", vim.inspect(result))
      return
    end

    if callback then
      callback(result)
    end
  end))

  if opts.sync then
    return result:wait()
  else
    return result
  end
end

