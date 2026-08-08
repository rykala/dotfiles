return {
	"saghen/blink.cmp",
	---@module "blink.cmp"
	---@type blink.cmp.Config
	dependencies = { "alexandre-abrioux/blink-cmp-npm.nvim" },
	opts = {
		completion = {
			menu = {
				auto_show = true,
			},
			ghost_text = {
				enabled = false,
			},
			list = {
				selection = { preselect = true, auto_insert = true },
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 800,
			},
		},
		keymap = {
			preset = "enter",
			["<C-j>"] = { "select_next", "fallback" },
			["<C-k>"] = { "select_prev", "fallback" },
			["<C-n>"] = { "show", "select_next", "fallback" },
		},

		sources = {
			default = {
				"npm",
			},
			providers = {
				npm = {
					name = "npm",
					module = "blink-cmp-npm",
					async = true,
					score_offset = 100,
					---@module "blink-cmp-npm"
					---@type blink-cmp-npm.Options
					opts = {
						ignore = {},
						only_semantic_versions = true,
						only_latest_version = false,
					},
				},
			},
		},
	},
}
