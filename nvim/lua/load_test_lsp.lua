vim.o.updatetime = 250  -- Make CursorHold and CursorHoldI faster

local on_attach = function(client, bufnr)
  local show_diagnostics = function()
    vim.diagnostic.open_float(nil, { focus = false, border = "rounded" })
  end

  -- Show diagnostics on idle and immediately after changes
  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "TextChanged", "TextChangedI" }, {
    buffer = bufnr,
    callback = show_diagnostics,
  })

  -- Optional keymaps for LSP features
  vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr })
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",  -- your target filetype(s)
  callback = function()
    vim.lsp.start({
      name = "lsp",
      cmd = { "/Users/shiven/Developer/lsp/main" },
      root_dir = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
      on_attach = on_attach,
    })
  end,
})
