return function(dir, cb)
  local cwd      = vim.fn.getcwd()
  vim.cmd.cd(dir)

  cb()

  vim.cmd.cd(cwd)
end
