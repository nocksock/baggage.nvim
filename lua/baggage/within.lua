return function(dir, cb)
  local cwd      = vim.fn.getcwd()

  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end

  vim.cmd.cd(dir)

  cb()

  vim.cmd.cd(cwd)
end
