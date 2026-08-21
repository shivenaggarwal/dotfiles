----------------------------
-- shiven's neovim config --
----------------------------

vim.g.mapleader = " "
vim.g.maplocalleader = " "

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

-- Floating todo, built on https://github.com/vimichael/floatingtodo.nvim and
-- https://github.com/vimichael/floatingtodo.nvim/pull/3. Credit to the original authors.

local floatodo_win = nil

local floatodo_opts = {
	target_file = "~/notes/todo.md",
	border = "single",
	auto_save = true,
	width = 0.70,
	height = 0.8,
	position = "center",
}

local function floatodo_expand_path(path)
	if path:sub(1, 1) == "~" then
		return os.getenv("HOME") .. path:sub(2)
	end
	return path
end

local function floatodo_calculate_position(position)
	local posx, posy = 0.5, 0.5

	if type(position) == "table" then
		posx, posy = position[1], position[2]
	end

	if position == "center" then
		posx, posy = 0.5, 0.5
	elseif position == "topleft" then
		posx, posy = 0, 0
	elseif position == "topright" then
		posx, posy = 1, 0
	elseif position == "bottomleft" then
		posx, posy = 0, 1
	elseif position == "bottomright" then
		posx, posy = 1, 1
	end

	return posx, posy
end

local function floatodo_win_config(opts)
	local width = math.min(math.floor(vim.o.columns * opts.width), 82)
	local height = math.floor(vim.o.lines * opts.height)

	local posx, posy = floatodo_calculate_position(opts.position)

	local col = math.floor((vim.o.columns - width) * posx)
	local row = math.floor((vim.o.lines - height) * posy)

	return {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		border = opts.border,
	}
end

local function open_floating_todo(opts)
	local expanded_path = floatodo_expand_path(opts.target_file)

	if vim.fn.filereadable(expanded_path) == 0 then
		vim.notify("todo file does not exist at directory: " .. expanded_path, vim.log.levels.ERROR)
		return
	end

	local buf = vim.fn.bufnr(expanded_path, true)

	if buf == -1 then
		buf = vim.api.nvim_create_buf(false, false)
		vim.api.nvim_buf_set_name(buf, expanded_path)
	end

	vim.bo[buf].swapfile = false

	if floatodo_win ~= nil and vim.api.nvim_win_is_valid(floatodo_win) then
		vim.api.nvim_set_current_win(floatodo_win)
		return
	end

	floatodo_win = vim.api.nvim_open_win(buf, true, floatodo_win_config(opts))

	vim.api.nvim_buf_set_keymap(buf, "n", "q", "", {
		noremap = true,
		silent = true,
		callback = function()
			if vim.api.nvim_get_option_value("modified", { buf = buf }) then
				if opts.auto_save then
					vim.api.nvim_buf_call(buf, function()
						vim.cmd("write")
					end)
					vim.api.nvim_win_close(0, true)
				else
					vim.notify("Save your changes before closing.", vim.log.levels.WARN)
				end
			else
				vim.api.nvim_win_close(0, true)
				floatodo_win = nil
			end
		end,
	})
end

vim.api.nvim_create_user_command("Td", function()
	open_floating_todo(floatodo_opts)
end, {})

vim.keymap.set("n", "<leader>td", function()
	open_floating_todo(floatodo_opts)
end, { desc = "Open floating todo" })

require("lazy").setup({
	spec = {
		{ "LazyVim/LazyVim", import = "lazyvim.plugins" },

		-- show dotfiles in the file explorer
		{
			"snacks.nvim",
			opts = {
				picker = {
					sources = {
						explorer = {
							hidden = true,
						},
					},
				},
			},
		},

		-- lua_ls is already configured by LazyVim core
		{
			"neovim/nvim-lspconfig",
			opts = {
				servers = {
					pyright = {},
					ruff = {},
					clangd = {},
					omnisharp = {},
					ts_ls = {},
					html = {},
					cssls = {},
				},
			},
		},

		-- lua/fish/sh formatting is already covered by LazyVim core
		{
			"stevearc/conform.nvim",
			opts = {
				formatters_by_ft = {
					python = { "ruff_format" },
					c = { "clang-format" },
					cpp = { "clang-format" },
					cs = { "csharpier" },
					javascript = { "prettier" },
					javascriptreact = { "prettier" },
					typescript = { "prettier" },
					typescriptreact = { "prettier" },
					html = { "prettier" },
					css = { "prettier" },
				},
			},
		},
		{
			"mason-org/mason.nvim",
			opts = {
				ensure_installed = { "prettier", "clang-format", "csharpier" },
			},
		},

		{
			"MeanderingProgrammer/render-markdown.nvim",
			ft = { "markdown" },
			opts = {},
			config = function(_, opts)
				require("render-markdown").setup(opts)
				Snacks.toggle({
					name = "Render Markdown",
					get = require("render-markdown").get,
					set = require("render-markdown").set,
				}):map("<leader>um")
			end,
		},

		{
			"epwalsh/pomo.nvim",
			version = "*",
			cmd = { "TimerStart", "TimerRepeat", "TimerSession", "TimerStop", "TimerPause", "TimerResume" },
			dependencies = { "rcarriga/nvim-notify" },
			keys = {
				{ "<leader>pp", "<cmd>TimerSession pomodoro<cr>", desc = "Start Pomodoro Session" },
				{ "<leader>pd", "<cmd>TimerSession deep<cr>", desc = "Start Deep Work Session" },
				{ "<leader>ps", "<cmd>TimerStop<cr>", desc = "Stop Timer" },
			},
			opts = function()
				local uname = vim.loop.os_uname()
				local is_wsl = uname.release:lower():find("microsoft") ~= nil
				local is_macos = uname.sysname == "Darwin"
				local has_system_notifier = is_macos or (uname.sysname == "Linux" and not is_wsl)

				local notifiers = {
					{
						name = "Default",
						opts = {
							sticky = false,
							title_icon = "󱎫",
							text_icon = "󰄉",
						},
					},
				}
				if has_system_notifier then
					table.insert(notifiers, { name = "System" })
				end
				if is_macos then
					local sound = "/System/Library/Sounds/Hero.aiff"
					table.insert(notifiers, {
						init = function()
							return {
								tick = function() end,
								start = function() end,
								stop = function() end,
								done = function()
									vim.system({ "afplay", sound }, { detach = true })
								end,
							}
						end,
					})
				end

				return {
					update_interval = 1000,
					notifiers = notifiers,
					timers = {},
					sessions = {
						pomodoro = {
							{ name = "Work", duration = "25m" },
							{ name = "Short Break", duration = "5m" },
							{ name = "Work", duration = "25m" },
							{ name = "Short Break", duration = "5m" },
							{ name = "Work", duration = "25m" },
							{ name = "Long Break", duration = "15m" },
						},
						deep = {
							{ name = "Work", duration = "50m" },
							{ name = "Short Break", duration = "10m" },
							{ name = "Work", duration = "50m" },
							{ name = "Short Break", duration = "10m" },
							{ name = "Work", duration = "50m" },
							{ name = "Long Break", duration = "20m" },
						},
					},
				}
			end,
		},

		{
			"catppuccin/nvim",
			name = "catppuccin",
			lazy = true,
			opts = {
				transparent_background = true,
				float = {
					transparent = true,
				},
				styles = {
					numbers = { "italic" },
					types = { "italic" },
					booleans = { "italic" },
					variables = { "bold" },
				},
			},
		},
		{
			"LazyVim/LazyVim",
			opts = {
				colorscheme = "catppuccin",
			},
		},

		{
			"snacks.nvim",
			dependencies = { "amansingh-afk/milli.nvim" },
			opts = function(_, opts)
				local splash = require("milli").load({ splash = "chrome" })
				opts.dashboard = vim.tbl_deep_extend("force", opts.dashboard or {}, {
					preset = {
						header = table.concat(splash.frames[1], "\n"),
					},
				})
				return opts
			end,
			config = function(_, opts)
				require("snacks").setup(opts)
				require("milli").snacks({ splash = "chrome", loop = true })
			end,
		},
	},
	defaults = {
		lazy = false,
		version = false,
	},
	install = { colorscheme = { "tokyonight", "habamax" } },
	checker = {
		enabled = true,
		notify = false,
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})

vim.api.nvim_create_autocmd("VimLeave", {
	pattern = "*",
	command = "set guicursor=a:ver25",
})
