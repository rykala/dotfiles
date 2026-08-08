return {
	"vuki656/package-info.nvim",
	dependencies = { "MunifTanjim/nui.nvim" },
	event = "BufRead package.json",
	opts = {},
	-- stylua: ignore
	keys = {
		{ "<leader>Pt", function() require("package-info").toggle() end, desc = "Toggle package versions" },
		{ "<leader>Pu", function() require("package-info").update() end, desc = "Update package on line" },
		{ "<leader>Pd", function() require("package-info").delete() end, desc = "Delete package on line" },
		{ "<leader>Pi", function() require("package-info").install() end, desc = "Install new package" },
		{ "<leader>Pv", function() require("package-info").change_version() end, desc = "Change package version" },
	},
}
