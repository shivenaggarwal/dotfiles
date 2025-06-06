local M = {}

function M.start_live_reload()
  vim.bo.autoread = true

  -- Timer to periodically check for external changes
  local timer = vim.loop.new_timer()
  timer:start(1000, 1000, vim.schedule_wrap(function()
    if not vim.bo.modified and not vim.bo.readonly then
      vim.cmd('checktime')
    end
  end))

  -- Notify when reload happens
  vim.api.nvim_create_autocmd("FileChangedShellPost", {
    buffer = 0,
    callback = function()
      vim.notify("File reloaded: " .. vim.fn.expand("%"), vim.log.levels.INFO)
    end,
  })
end

return M
