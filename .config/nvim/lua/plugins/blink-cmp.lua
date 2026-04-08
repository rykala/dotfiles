return {
	"saghen/blink.cmp",
	---@module "blink.cmp"
	---@type blink.cmp.Config
	opts = {
		completion = {
			menu = {
				auto_show = false,
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
		},
	},
}
