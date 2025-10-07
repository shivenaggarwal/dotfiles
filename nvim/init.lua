----------------------------
-- shiven's neovim config --
----------------------------
vim.cmd([[set mouse=]])
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
	{ src = "https://github.com/hrsh7th/nvim-cmp" },
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
	{ src = "https://github.com/hrsh7th/cmp-buffer" },
	{ src = "https://github.com/hrsh7th/cmp-path" },
	{ src = "https://github.com/saadparwaiz1/cmp_luasnip" },
})

require "mason".setup()
require "mini.pick".setup()
require "mini.bufremove".setup()
require "mini.pairs".setup()
require "oil".setup({
	view_options = {
		show_hidden = true,
	},
	lsp_file_methods = {
		enabled = true,
		timeout_ms = 1000,
		autosave_changes = true,
	},
	float = {
		max_width = 0.7,
		max_height = 0.6,
		border = "rounded",
	},
})
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

-- nvim-cmp setup for better completion and autoimports
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { 'i', 's' }),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	}, {
		{ name = 'buffer' },
		{ name = 'path' },
	})
})

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
map('n', '<C-f>', '<Cmd>Oil<CR>')

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

map('n', '<leader>lf', vim.lsp.buf.format)
map('n', '<leader>g', "<Cmd>Pick grep_live<CR>")
map('n', '<leader>f', "<Cmd>Pick files<CR>")
map('n', '<leader>r', "<Cmd>Pick buffers<CR>")
map('n', '<leader>h', "<Cmd>Pick help<CR>")
map('n', '<leader>e', "<Cmd>Oil<CR>")
map('n', '<leader>E', require("oil").open_float)


map("n", "<M-n>", "<cmd>resize +2<CR>")          -- Increase height
map("n", "<M-e>", "<cmd>resize -2<CR>")          -- Decrease height
map("n", "<M-i>", "<cmd>vertical resize +5<CR>") -- Increase width
map("n", "<M-m>", "<cmd>vertical resize -5<CR>") -- Decrease width
map("i", "<C-s>", "<c-g>u<Esc>[s1z=`]a<c-g>u")

-- LSP shortcuts
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to References" })

-- diagnostic navigation
map('n', '[d', vim.diagnostic.goto_prev)
map('n', ']d', vim.diagnostic.goto_next)
map('n', '<leader>de', vim.diagnostic.open_float)
map('n', '<leader>dl', vim.diagnostic.setloclist)

-- Python virtual environment detection
local function find_python_executable()
	local cwd = vim.fn.getcwd()

	-- Check for uv .venv
	local uv_python = cwd .. "/.venv/bin/python"
	if vim.fn.executable(uv_python) == 1 then
		return uv_python
	end

	-- Check for conda environment
	local conda_env = vim.fn.getenv("CONDA_DEFAULT_ENV")
	if conda_env and conda_env ~= vim.NIL then
		local conda_python = vim.fn.exepath("python")
		if conda_python ~= "" then
			return conda_python
		end
	end

	-- Check for standard .venv
	local venv_python = cwd .. "/.venv/bin/python"
	if vim.fn.executable(venv_python) == 1 then
		return venv_python
	end

	-- Check for venv directory
	local venv_alt_python = cwd .. "/venv/bin/python"
	if vim.fn.executable(venv_alt_python) == 1 then
		return venv_alt_python
	end

	-- Fall back to system python
	return vim.fn.exepath("python")
end

-- Set up Python path for current project
local function setup_python_path()
	local python_path = find_python_executable()
	vim.g.python3_host_prog = python_path

	-- Update PATH to include the virtual environment
	local python_dir = vim.fn.fnamemodify(python_path, ":h")
	local current_path = vim.fn.getenv("PATH")
	if not string.match(current_path, python_dir) then
		local new_path = python_dir .. ":" .. current_path
		vim.fn.setenv("PATH", new_path)
		-- Also update shell PATH for :! commands
		vim.env.PATH = new_path
	end
end

-- Auto-detect Python environment when entering a directory
vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
	callback = setup_python_path,
})

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

