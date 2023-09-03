vim.api.nvim_create_user_command("Baggage", function()
  vim.inspect(LOADED_PLUGINS)
end, {})
