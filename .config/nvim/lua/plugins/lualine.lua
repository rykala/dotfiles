return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			theme = "auto",
			globalstatus = true,
			component_separators = "",
			section_separators = { left = "", right = "" },
			icons_enabled = true,
		},
		sections = {
			lualine_a = {},
			lualine_b = { "branch", "diff", "filename" },
			lualine_c = {
				"%=", --[[ add your center components here in place of this comment ]]
				{
					"diagnostics",
					sources = { "nvim_diagnostic" },
					sections = { "error", "warn", "info", "hint" },
					symbols = { error = " ", warn = " ", info = " ", hint = "H" },
					{
						error = "DiagnosticError",
						warn = "DiagnosticWarn",
						info = "DiagnosticInfo",
						hint = "DiagnosticHint",
					},
				},
			},
			lualine_x = {},
			lualine_y = { "lsp_status", "filetype", "location", "mode" },
			lualine_z = {},
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = {},
			lualine_x = {},
			lualine_y = {},
			lualine_z = {},
		},
		tabline = {},
		extensions = {},
	},
}
