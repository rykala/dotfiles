return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "VeryLazy", -- Or `LspAttach`
	priority = 1000, -- needs to be loaded in first
	opts = {
		preset = "minimal",
	},
	config = function(_, opts)
		require("tiny-inline-diagnostic").setup(opts)

		Snacks.toggle({
			name = "Inline Diagnostics",
			get = function()
				return require("tiny-inline-diagnostic.state").user_toggle_state
			end,
			set = function(state)
				local tiny = require("tiny-inline-diagnostic")
				if state then
					tiny.enable()
				else
					tiny.disable()
				end
			end,
		}):map("<leader>uv")
	end,
}
