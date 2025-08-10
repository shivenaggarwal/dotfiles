-- ========================================================================== --
-- ==           {{{   EDITOR SETTINGS                                      == --
-- ========================================================================== --

local opt = vim.opt -- alias for vim.opt
local key = vim.keymap.set -- alias for keymap.set
local api = vim.api -- alias for vim.api
local g = vim.g -- alias for vim.g

opt.number = true -- numbers in the left column
opt.relativenumber = true -- relative numbers on by default
opt.mouse = "a" -- enable mouse support in all modes
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- ignore case if search pattern is all lowercase
opt.gdefault = true -- replace all matches in a line by default
opt.hlsearch = false -- do not highlight search results by default
opt.wrap = false -- do not wrap lines by default
opt.breakindent = true -- indent wrapped lines
opt.tabstop = 2 -- number of spaces a tab counts for
opt.shiftwidth = 2 -- number of spaces used for each step of (auto)indent
opt.expandtab = true -- convert tabs to spaces
opt.autoindent = true -- copy indent from current line when starting a new line
opt.signcolumn = "yes" -- always show the sign column
opt.clipboard = "unnamedplus" -- use system clipboard
opt.cursorline = true -- highlight the current line
opt.cursorcolumn = false -- highlight the current column
g.codeium_no_map_tab = true -- disable tab mapping in codeium
opt.undodir = vim.fn.stdpath("cache") .. "/undo" -- persistent undo in directory
opt.undofile = true -- persistent undo in file
opt.backup = false -- do not create backup files
opt.writebackup = false -- do not create backup files
opt.foldmethod = "expr" -- folding method expression
opt.foldexpr = "nvim_treesitter#foldexpr()" -- folding method for treesitter
opt.foldlevel = 99 -- folding level to open all folds by default
--opt.showtabline = 2 -- set the top bar in your UI
-- }}}
-- ========================================================================== --
-- ==           {{{   KEY BINDINGS                                         == --
-- ========================================================================== --

g.mapleader = " " -- space as leader
key("n", "<leader><space>", ":", { desc = "Command Mode" }) -- command mode
key("n", "<leader>ec", ":e $MYVIMRC<CR>", { desc = "Edit Config" }) -- edit neovim config file
key("i", "jk", "<esc>", { desc = "Go to Normal Mode" }) -- go to normal mode
key("n", "q", "<C-r>", { desc = "Redo" }) -- redo
key("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle File Explorer" }) --nvim tree

key({ "n", "x", "o" }, "<leader>h", "^", { desc = "Move to beginning of line" }) -- move to beginning of line
key({ "n", "x", "o" }, "<leader>l", "g_", { desc = "Move to end of line" }) -- move to end of line
key("n", "<leader>a", ":keepjumps normal! ggVG<cr>", { desc = "Select all" }) -- select all

key("n", "<leader>nn", ":set nonumber!<CR>", { desc = "Toggle line numbers" }) -- toggle line numbers
key("n", "<leader>nr", ":set relativenumber!<CR>", { desc = "Toggle relative line numbers" }) -- toggle relative line numbers
key("n", "<leader>w", ":set wrap! wrap?<CR>", { desc = "Toggle line wrap" }) -- toggle line wrap

key({ "n", "x" }, "x", '"_x') -- delete without yanking

key("n", "<leader>w", "<cmd>write<cr>", { desc = "Save" }) -- save
key("n", "<leader>bq", "<cmd>bdelete<cr>", { desc = "Close buffer" }) -- close buffer
key("n", "<leader>bl", "<cmd>buffer #<cr>", { desc = "Next buffer" }) -- go to last buffer

key("n", "<leader>ca", ":lua vim.lsp.buf.code_action()<CR>", { desc = "Code Action" }) -- code action on current line
-- }}}
-- ========================================================================== --
-- ==           {{{  COMMANDS                                              == --
-- ========================================================================== --

api.nvim_create_user_command("ReloadConfig", "source $MYVIMRC", {}) -- reload config

local group = api.nvim_create_augroup("user_cmds", { clear = true }) -- augroup for user commands

api.nvim_create_autocmd("TextYankPost", { -- highlight on yank
	desc = "Highlight on yank",
	group = group,
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
	end,
})

api.nvim_create_autocmd("FileType", { -- quit help buffers
	pattern = { "help", "man" },
	group = group,
	command = "nnoremap <buffer> q <cmd>quit<cr>",
})

api.nvim_set_keymap("c", "<Down>", 'v:lua.get_wildmenu_key("<right>", "<down>")', { expr = true }) -- cusror down in wildmenu
api.nvim_set_keymap("c", "<Up>", 'v:lua.get_wildmenu_key("<left>", "<up>")', { expr = true }) -- cusror up in wildmenu

function _G.get_wildmenu_key(key_wildmenu, key_regular)
	return vim.fn.wildmenumode() ~= 0 and key_wildmenu or key_regular
end

-- }}}
-- ========================================================================== --
-- ==           {{{          PLUGINS                                == --
-- ========================================================================== --

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {

		{
			"ThePrimeagen/vim-be-good",
		},

		{
			"nvim-tree/nvim-tree.lua",
			dependencies = {
				"nvim-tree/nvim-web-devicons",
			},
			config = function()
				require("nvim-tree").setup({
					view = {
						width = 35,
						side = "left",
					},
					renderer = {
						group_empty = true,
						highlight_git = true,
						icons = {
							show = {
								git = true,
								folder = true,
								file = true,
								folder_arrow = true,
							},
						},
					},
					git = {
						enable = true,
					},
				})
			end,
		},

		{
			"goolord/alpha-nvim",
			dependencies = {
				"nvim-tree/nvim-web-devicons",
			},

			config = function()
				local alpha = require("alpha")
				local dashboard = require("alpha.themes.dashboard")

				dashboard.section.header.val = {
					[[                                                                       ]],
					[[                                                                       ]],
					[[                                                                       ]],
					[[                                                                       ]],
					[[                                                                       ]],
					[[                                                                       ]],
					[[                                                                       ]],
					[[                                                                     ]],
					[[       ████ ██████           █████      ██                     ]],
					[[      ███████████             █████                             ]],
					[[      █████████ ███████████████████ ███   ███████████   ]],
					[[     █████████  ███    █████████████ █████ ██████████████   ]],
					[[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
					[[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
					[[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
					[[                                                                       ]],
					[[                                                                       ]],
					[[                                                                       ]],
				}

				-- Apply highlight to the header
				dashboard.section.header.opts = {
					position = "center",
					hl = "DashboardHeader",
				}

				-- Choose highlight color here:
				-- Solarized Light *recommendation*: use the "blue" or "base0" tone
				-- (Solarized Light has #268bd2 for blue)
				vim.api.nvim_set_hl(0, "DashboardHeader", { link = "Title" })

				dashboard.section.buttons.val = {
					dashboard.button("f", "  Find File", "<cmd>Telescope find_files<CR>"),
					dashboard.button("n", "  New File", "<cmd>enew<CR>"),
					dashboard.button("g", "  Find Text", "<cmd>Telescope live_grep<CR>"),
					dashboard.button("r", "  Recent Files", "<cmd>Telescope oldfiles<CR>"),
					dashboard.button("c", "  Config", "<cmd>edit $MYVIMRC<CR>"),
					dashboard.button("L", "  Lazy", "<cmd>Lazy<CR>"),
					dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
				}

				-- Footer can remain empty
				dashboard.section.footer.val = ""

				-- Allow autocommands so theme highlights apply properly
				dashboard.opts.opts.noautocmd = false

				alpha.setup(dashboard.opts)

				-- Ensure colorscheme autocommands run after Alpha is ready
				vim.api.nvim_create_autocmd("User", {
					pattern = "AlphaReady",
					callback = function()
						vim.cmd("doautocmd ColorScheme")
					end,
				})
			end,
		},

		-- Theming
		{ "folke/tokyonight.nvim" }, -- colorscheme
		{ "nyoom-engineering/oxocarbon.nvim" },
		{ "ishan9299/nvim-solarized-lua" },
		{ "sainnhe/gruvbox-material" },
		{ "ellisonleao/gruvbox.nvim" },
		{ "zaki/zazen" },

		-- { "bluz71/nvim-linefly" }, -- statusline plugin
		{ "nvim-lualine/lualine.nvim" },
		{
			"echasnovski/mini.indentscope", -- indent guides
			version = false, -- wait till new 0.7.0 release to put it back on semver
			event = { "BufReadPre", "BufNewFile" },
			opts = {
				-- symbol = "▏",
				symbol = "│",
				options = { try_as_border = true },
			},
			init = function()
				api.nvim_create_autocmd("FileType", {
					pattern = {
						"help",
						"dashboard",
						"lazy",
						"mason",
						"notify",
					},
					callback = function()
						vim.b.miniindentscope_disable = true
					end,
				})
			end,
		},

		-- Fuzzy finder
		{ "nvim-telescope/telescope.nvim", branch = "0.1.x" }, -- fuzzy finder/file navigator plus more
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- dependency for better sorting performance

		-- Git
		{ "lewis6991/gitsigns.nvim" }, -- show git changes in the gutter
		{ "tpope/vim-fugitive" }, -- git commands in nvim

		-- Code manipulation
		{ "nvim-treesitter/nvim-treesitter" }, -- syntax highlighting and indentation
		{ "nvim-treesitter/nvim-treesitter-textobjects" }, -- text objects for treesitter
		{ "numToStr/Comment.nvim" }, -- comment out lines
		{
			"windwp/nvim-autopairs", -- autopairs for treesitter and others
			event = "InsertEnter",
			opts = {}, -- this is equalent to setup({}) function
		},

		{ "nvim-lua/plenary.nvim" }, -- dependency for better sorting performance

		{ "neovim/nvim-lspconfig" }, -- lsp configuration
		{ "williamboman/mason.nvim" }, -- lsp installer
		{ "williamboman/mason-lspconfig.nvim" }, -- lsp installer config

		{
			"nvimtools/none-ls.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
		}, -- auto formatter

		-- Autocomplete
		{ "hrsh7th/nvim-cmp" }, -- Autocompletion plugin
		{ "hrsh7th/cmp-buffer" }, -- buffer completions
		{ "hrsh7th/cmp-path" }, -- path completions
		{ "saadparwaiz1/cmp_luasnip" }, -- snippet completions
		{ "hrsh7th/cmp-nvim-lsp" }, -- lsp completions

		-- Snippets
		{
			"L3MON4D3/LuaSnip", -- snippet engine
			dependencies = {
				"rafamadriz/friendly-snippets", -- a bunch of snippets to use
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},
			opts = {
				history = true,
				delete_check_events = "TextChanged",
			},
  -- stylua: ignore
  keys = {
    {
      "<tab>",
      function()
        return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
      end,
      expr = true, silent = true, mode = "i",
    },
    { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
    { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
  },
		},
		-- which key

		{
			"folke/which-key.nvim", -- show keybindings in popup
			event = "VeryLazy",
			init = function()
				vim.o.timeout = true
				vim.o.timeoutlen = 300
			end,
			opts = {
				-- your configuration comes here
				-- or leave it empty to use the default settings
			},
		},
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = false },
})
-- ========================================================================== --
-- ==           {{{       PLUGIN CONFIGURATION                         == --
-- ==========

---
-- Lualine (Statusline)
---
require("lualine").setup({
	options = {
		theme = "gruvbox-material",
		icons_enabled = true,
		section_separators = "",
		component_separators = "",
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = { { "filename", path = 4 } }, -- shows relative path
		lualine_x = { "encoding", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})

---
-- Colorscheme
---
opt.termguicolors = true
vim.cmd.colorscheme("gruvbox-material") -- set colorscheme
--vim.cmd.colorscheme("zazen") -- set colorscheme

--vim.o.background = "dark"

-- vim.o.winbar = "%=%F"
-- vim.o.winbar = "%F"

-- vim.api.nvim_set_hl(0, "WinBar", { link = "Normal" })
-- vim.api.nvim_set_hl(0, "WinBarNC", { link = "NormalNC" })
-- vim.api.nvim_create_autocmd("ColorScheme", {
--   callback = function()
--     vim.api.nvim_set_hl(0, "WinBar", { link = "Normal" })
--     vim.api.nvim_set_hl(0, "WinBarNC", { link = "NormalNC" })
--   end,
-- })

-- Dynamically set NvimTree background to match current theme
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
		local bg = normal_hl.bg and string.format("#%06x", normal_hl.bg) or "NONE"

		vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = bg })
		vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = bg })
		vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = bg })
		vim.api.nvim_set_hl(0, "NvimTreeVertSplit", { fg = bg, bg = bg })
	end,
})

---
-- Treesitter
---
-- See :help nvim-treesitter-modules
require("nvim-treesitter.configs").setup({ -- treesitter configuration
	highlight = {
		enable = true,
	},
	-- :help nvim-treesitter-textobjects-modules
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
	},
	ensure_installed = {
		"javascript",
		"astro",
		"c",
		"go",
		"markdown_inline",
		"typescript",
		"tsx",
		"lua",
		"luadoc",
		"vim",
		"vimdoc",
		"css",
		"json",
		"zig",
		"python",
	},
})

---
-- Comment.nvim
---
require("Comment").setup({})

---
-- Gitsigns
---
-- See :help gitsigns-usage
require("gitsigns").setup({ -- setup gitsigns
	signs = {
		add = { text = "▎" },
		change = { text = "▎" },
		delete = { text = "➤" },
		topdelete = { text = "➤" },
		changedelete = { text = "▎" },
	},
})

---
-- Telescope
---
-- See :help telescope.builtin
key("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>") -- find recent files
key("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers
--key("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files
key("n", "<leader>ff", "<cmd>Telescope find_files hidden=true no_ignore=true<cr>", { desc = "Find Files (all)" })
key("n", "<leader>fh", "<cmd>Telescope find_files hidden=true<cr>") -- find hidden files
key("n", "<leader>fg", "<cmd>Telescope live_grep<cr>") -- find text in files
key("n", "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>") -- show diagnostics for current buffer
key("n", "<leader>sD", "<cmd>Telescope diagnostics<cr>") -- show diagnostics for all buffers
key("n", "<leader>fs", "<cmd>Telescope current_buffer_fuzzy_find<cr>") -- fuzzy find in current buffer
key("n", "<leader>sk", "<cmd>Telescope keymaps<cr>") -- show keymaps -- this can be used instead of whichkey for a slimmer config

require("telescope").load_extension("fzf") -- load fzf

require("telescope").setup({
  defaults = {
    file_ignore_patterns = {
      "node_modules",
    },
    find_command = { "rg", "--files", "--hidden", "--no-ignore" }, 
  },
})

require("luasnip.loaders.from_vscode").lazy_load() -- load snippets

---
-- nvim-cmp (autocomplete)
---
opt.completeopt = { "menu", "menuone", "noselect" } -- autocomplete

local cmp = require("cmp")
local luasnip = require("luasnip")
local select_opts = { behavior = cmp.SelectBehavior.Select }

-- See :help cmp-config
cmp.setup({ -- setup cmp
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	sources = {
		{ name = "path" },
		{ name = "nvim_lsp" },
		{ name = "buffer", keyword_length = 3 },
		{ name = "luasnip", keyword_length = 2 },
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	completion = {
		completeopt = "menu,menuone,noinsert",
	},
	formatting = {
		fields = { "menu", "abbr", "kind" },
		format = function(entry, item)
			local menu_icon = {
				nvim_lsp = "λ",
				luasnip = "⋗",
				buffer = "Ω",
				path = "🖫",
			}

			item.menu = menu_icon[entry.source.name]
			return item
		end,
	},
	-- See :help cmp-mapping
	mapping = {
		["<Up>"] = cmp.mapping.select_prev_item(select_opts),
		["<Down>"] = cmp.mapping.select_next_item(select_opts),

		["<C-p>"] = cmp.mapping.select_prev_item(select_opts),
		["<C-n>"] = cmp.mapping.select_next_item(select_opts),

		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),

		["<C-e>"] = cmp.mapping.abort(),
		["<C-y>"] = cmp.mapping.confirm({ select = true }),
		["<CR>"] = cmp.mapping.confirm({ select = false }),

		["<C-f>"] = cmp.mapping(function(fallback)
			if luasnip.jumpable(1) then
				luasnip.jump(1)
			else
				fallback()
			end
		end, { "i", "s" }),

		["<C-b>"] = cmp.mapping(function(fallback)
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	},
})

---
-- LSP config
---
-- See :help lspconfig-global-defaults
local lspconfig = require("lspconfig")
local lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilities =
	vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

---
-- Diagnostic customization
---
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "✘",
			[vim.diagnostic.severity.WARN] = "▲",
			[vim.diagnostic.severity.HINT] = "⚑",
			[vim.diagnostic.severity.INFO] = "»",
		},
	},
})

-- See :help vim.diagnostic.config()
vim.diagnostic.config({
	virtual_text = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "always",
	},
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

---
-- LSP Keybindings
---
api.nvim_create_autocmd("LspAttach", {
	group = group,
	desc = "LSP actions",
	callback = function()
		local bufmap = function(mode, lhs, rhs)
			local opts = { buffer = true }
			key(mode, lhs, rhs, opts)
		end

		-- You can search each function in the help page.
		-- For example :help vim.lsp.buf.hover()

		bufmap("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>") -- show documentation
		bufmap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>") -- go to definition
		bufmap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>") -- go to declaration
		bufmap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>") -- go to implementation
		bufmap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>") -- go to references
		bufmap("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>") -- show diagnostics
		bufmap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>") -- go to previous diagnostic
		bufmap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>") -- go to next diagnostic
	end,
})


local function get_python_path(workspace)
  -- 1. Active virtual environment (venv)
  if vim.env.VIRTUAL_ENV then
    return vim.env.VIRTUAL_ENV .. "/bin/python"
  end

  -- 2. Active Conda environment
  if vim.env.CONDA_PREFIX then
    return vim.env.CONDA_PREFIX .. "/bin/python"
  end

  -- 3. Local project `.venv`
  local venv_path = workspace .. "/.venv/bin/python"
  if vim.fn.executable(venv_path) == 1 then
    return venv_path
  end

  -- 4. System Python fallback
  return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

-- Dynamically set python3_host_prog for Neovim Python plugins
local function set_python_host_prog()
  local venv_python = nil

  -- Check if using a virtualenv (venv)
  if vim.env.VIRTUAL_ENV then
    venv_python = vim.env.VIRTUAL_ENV .. "/bin/python"
  -- Check if using conda
  elseif vim.env.CONDA_PREFIX then
    venv_python = vim.env.CONDA_PREFIX .. "/bin/python"
  end

  if venv_python and vim.fn.executable(venv_python) == 1 then
    vim.g.python3_host_prog = venv_python
  end
end

set_python_host_prog()


---
-- LSP servers
---
-- See :help mason-settings
require("mason").setup({ -- setup mason
	ui = { border = "rounded" },
})
-- See :help mason-lspconfig-settings
require("mason-lspconfig").setup({ -- setup mason-lspconfig
	ensure_installed = {
		"astro",
		"clangd",
		"emmet_ls",
		"gopls",
		"lua_ls",
		"ts_ls",
		"tailwindcss",
		"eslint",
		"html",
		"cssls",
		"zls",
		"pylsp",
		"pyright",
		"ruff",
	},
	-- See :help mason-lspconfig.setup_handlers()
	handlers = {
		function(server)
			-- See :help lspconfig-setup
			lspconfig[server].setup({})
		end,
		["tsserver"] = function()
			lspconfig.tsserver.setup({
				settings = {
					completions = {
						completeFunctionCalls = true,
					},
				},
			})
		end,


["pyright"] = function()
  local venv, venv_path

  if vim.env.VIRTUAL_ENV then
    venv = vim.env.VIRTUAL_ENV:match(".+/([^/]+)$")
    venv_path = vim.env.VIRTUAL_ENV:match("(.+)/[^/]+$")
  elseif vim.env.CONDA_PREFIX then
    venv = vim.env.CONDA_PREFIX:match(".*/envs/([^/]+)$")
    venv_path = vim.env.CONDA_PREFIX:match("(.+)/envs")
  end

  require("lspconfig").pyright.setup({
    settings = {
      python = {
        venvPath = venv_path,
        venv = venv,
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "openFilesOnly",
          useLibraryCodeForTypes = true,
        },
      },
    },
  })
end







--    ["pyright"] = function()
--  require("lspconfig").pyright.setup({
--    before_init = function(_, config)
--      config.settings = config.settings or {}
--      config.settings.python = config.settings.python or {}
--      config.settings.python.pythonPath = get_python_path(config.root_dir)
--    end,
--  })
--end,

--      ["pylsp"] = function()
--      require("lspconfig").pylsp.setup({
--        settings = {
--          pylsp = {
--            plugins = {
--              pycodestyle = { enabled = true },
--              pyflakes = { enabled = true },
--              pylint = { enabled = false },
--            },
--          },
--        },
--        cmd_env = {
--          VIRTUAL_ENV = vim.env.VIRTUAL_ENV,
--          CONDA_PREFIX = vim.env.CONDA_PREFIX,
--          PATH = vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV .. "/bin:" .. vim.env.PATH
--              or vim.env.CONDA_PREFIX and vim.env.CONDA_PREFIX .. "/bin:" .. vim.env.PATH
--              or vim.env.PATH,
--        },
--      })
--    end,

	},
})

local nvim_lsp = require("lspconfig") -- setup lspconfig

local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettier,   -- JS/TS/HTML/CSS
    null_ls.builtins.formatting.black,      -- Python
    null_ls.builtins.formatting.stylua,     -- Lua
    null_ls.builtins.formatting.clang_format, -- C/C++/Zig
  },
  on_attach = function(client, bufnr)

  end,

  cmd_env = {
    PATH = (vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV .. "/bin:" .. vim.env.PATH)
      or (vim.env.CONDA_PREFIX and vim.env.CONDA_PREFIX .. "/bin:" .. vim.env.PATH)
      or vim.env.PATH,
  },
})

vim.keymap.set("n", "<leader>fm", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format Code" })



--nvim_lsp.ts_ls.setup({ -- setup tsserver lsp
--	on_attach = on_attach,
--	root_dir = nvim_lsp.util.root_pattern("package.json"), -- use tsserver if package.json is found
--	single_file_support = false,
--})
-- }}}
-- # vim:foldmethod=marker:foldlevel=0
