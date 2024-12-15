return {
	"catppuccin/nvim",
	priority = 1000,
	config = function()
		local theme = require("catppuccin")
		theme.setup({
			flavour = "macchiato", -- latte, frappe, macchiato, mocha
		})
		vim.cmd([[colorscheme catppuccin]])
	end,
}
