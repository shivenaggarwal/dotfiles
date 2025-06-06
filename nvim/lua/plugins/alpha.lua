return {
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
  
	  -- Set header highlight to Catppuccin Mocha's lavender
	  vim.api.nvim_set_hl(0, "DashboardHeader", { fg = "#b4befe" })
  
	  -- Footer can remain empty
	  local function footer()
		return ""
	  end
	  dashboard.section.footer.val = footer()
  
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
  }
  