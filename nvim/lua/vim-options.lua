local opt = vim.opt
local g = vim.g

-- Tab and indentation
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.autoindent = true

-- Line numbers
opt.number = true
vim.wo.relativenumber = true

-- UI & UX
opt.mouse = "a"
opt.cursorline = true
opt.cursorcolumn = false
opt.signcolumn = "yes"
opt.termguicolors = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.gdefault = true
opt.hlsearch = false

-- Clipboard and files
opt.clipboard = "unnamedplus"
opt.undodir = vim.fn.stdpath("cache") .. "/undo"
opt.undofile = true
opt.backup = false
opt.writebackup = false

-- Folding
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99

-- Wrapping
opt.wrap = false
opt.breakindent = true

-- Codeium settings
g.codeium_no_map_tab = true

-- Leader key
g.mapleader = " "

-- Split navigation
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')

-- Set up diagnostics floating window on CursorHold for all buffers
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false })
  end,
})

-- Set up hover info on K key for all attached LSP clients
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP Hover Info" })
  end,
})

-- Faster CursorHold trigger time (default is 4000ms)
opt.updatetime = 300
