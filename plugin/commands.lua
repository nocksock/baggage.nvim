local function create_baggage_window()
  vim.cmd.tabedit("term://" .. vim.g.baggage_path .. "//$SHELL")
  vim.cmd.help("baggage-baggage.cheat-sheet")
  vim.cmd.wincmd("L")
  vim.cmd.wincmd("h")
end

vim.api.nvim_create_user_command("Baggage", create_baggage_window, {
  desc = "Manage baggage plugins"
})
