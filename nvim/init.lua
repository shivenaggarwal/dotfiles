--vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])
vim.opt.winborder = "rounded"
vim.opt.tabstop = 2
vim.opt.wrap = false
vim.opt.cursorcolumn = false
vim.opt.ignorecase = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.signcolumn = "yes"

vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
})

require "mason".setup()
require "mini.pick".setup()
require "mini.bufremove".setup()
require "oil".setup()
require 'nvim-treesitter.configs'.setup {
	ensure_installed = {
		"python", "javascript", "typescript", "tsx", "go",
		"rust", "c", "cpp", "lua", "html", "css", "json"
	},
	auto_install = true,
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
	},
}

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method('textDocument/completion') then
			local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
			client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})

-- LSP
vim.lsp.enable(
	{
		"lua_ls",
		"svelte",
		"tinymist",
		"emmetls",
		"rust_analyzer",
		"clangd",
		"ruff",
		"pyright",
		"ts_ls",
		"gopls",
		"tailwindcss",
		"glsl_analyzer",
		"haskell-language-server",
		"hlint",

	}
)
vim.cmd [[set completeopt+=menuone,noselect,popup]]

-- colors
require "vague".setup({ transparent = true })
vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=NONE")

-- mappings
local map = vim.keymap.set
vim.g.mapleader = " "
map('n', '<leader>w', '<Cmd>write<CR>')
map('n', '<leader>q', require("mini.bufremove").delete)
map('n', '<leader>Q', '<Cmd>:wqa<CR>')
map('n', '<C-f>', '<Cmd>Open .<CR>')

-- open RC files.
map('n', '<leader>v', '<Cmd>e $MYVIMRC<CR>')
map('n', '<leader>z', '<Cmd>e ~/.config/zsh/.zshrc<CR>')

-- quickly switch files with alternate / switch it
map('n', '<leader>s', '<Cmd>e #<CR>')
map('n', '<leader>S', '<Cmd>bot sf #<CR>')
map({ 'n', 'v', 'x' }, '<leader>m', ':move ')
map({ 'n', 'v' }, '<leader>n', ':norm ')

-- system clipboard
map({ 'n', 'v' }, '<leader>y', '"+y')
map({ 'n', 'v' }, '<leader>d', '"+d')
map({ 'n', 'v' }, '<leader>c', ':')

-- soft reload config file
map({ 'n', 'v' }, '<leader>o', ':update<CR> :source<CR>')

map('t', '', "")
map('t', '', "")

map('n', '<leader>lf', vim.lsp.buf.format)
map('n', '<leader>f', "<Cmd>Pick files<CR>")
map('n', '<leader>r', "<Cmd>Pick buffers<CR>")
map('n', '<leader>h', "<Cmd>Pick help<CR>")
map('n', '<leader>e', "<Cmd>Oil<CR>")
map('i', '<c-e>', function() vim.lsp.completion.get() end)

map("n", "<M-n>", "<cmd>resize +2<CR>")          -- Increase height
map("n", "<M-e>", "<cmd>resize -2<CR>")          -- Decrease height
map("n", "<M-i>", "<cmd>vertical resize +5<CR>") -- Increase width
map("n", "<M-m>", "<cmd>vertical resize -5<CR>") -- Decrease width
map("i", "<C-s>", "<c-g>u<Esc>[s1z=`]a<c-g>u")

-- diagnostic navigation
map('n', '[d', vim.diagnostic.goto_prev)
map('n', ']d', vim.diagnostic.goto_next)
map('n', '<leader>de', vim.diagnostic.open_float)
map('n', '<leader>dl', vim.diagnostic.setloclist)

-- file type specific build commands
local filetype_group = vim.api.nvim_create_augroup("filetypes", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = filetype_group,
	pattern = "typst",
	callback = function()
		vim.keymap.set("n", "<leader>p", ":TypstPreview<CR>", { buffer = 0 })
		vim.cmd([[setlocal spell]])
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = filetype_group,
	pattern = "cpp",
	callback = function()
		vim.opt_local.makeprg = "cd build && make"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = filetype_group,
	pattern = "rust",
	callback = function()
		vim.opt_local.makeprg = "cargo build"
	end,
})
