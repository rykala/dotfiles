return {
	"Wansmer/treesj",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	keys = {
		{ "<leader>m", function() require("treesj").toggle() end, desc = "Split/Join block" },
	},
	opts = {
		use_default_keymaps = false,
	},
}
