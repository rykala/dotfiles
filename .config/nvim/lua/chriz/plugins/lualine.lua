-- stylua: ignore
local colors = {
  blue   = '#80a0ff',
  cyan   = '#79dac8',
  black  = '#080808',
  white  = '#c6c6c6',
  red    = '#ff5189',
  violet = '#d183e8',
  grey   = '#303030',
}

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			theme = "base16",
			globalstatus = true,
			component_separators = "",
			section_separators = { left = "", right = "" },
		},
		sections = {
			lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
			lualine_b = { "filename" },
			lualine_c = {
				"%=", --[[ add your center components here in place of this comment ]]
				{
					"diagnostics",
					sources = { "nvim_diagnostic" },
					symbols = { error = " ", warn = " ", info = " " },
					diagnostics_color = {
						error = { fg = colors.red },
						warn = { fg = colors.yellow },
						info = { fg = colors.cyan },
					},
				},
			},
			lualine_x = {},
			lualine_y = { "filetype", { "location", right_padding = 2 } },
			lualine_z = {
				{ "branch", separator = { right = "" } },
			},
		},
		inactive_sections = {
			lualine_a = { "filename" },
			lualine_b = {},
			lualine_c = {},
			lualine_x = {},
			lualine_y = {},
			lualine_z = { "branch" },
		},
		tabline = {},
		extensions = {},
	},
}
