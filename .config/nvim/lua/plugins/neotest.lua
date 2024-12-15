return {

	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"marilari88/neotest-vitest",
	},
	opts = {
		adapters = {
			["neotest-vitest"] = {},
		},
		status = { virtual_text = true },
		output = { open_on_run = true },
		quickfix = {
			open = function()
				if LazyVim.has("trouble.nvim") then
					require("trouble").open({ mode = "quickfix", focus = false })
				else
					vim.cmd("copen")
				end
			end,
		},
	},
	keys = {
		-- Run nearest tests
		vim.keymap.set("n", "<leader>R", function()
			require("neotest").run.run()
		end, { desc = "Run nearest tests" }),
		-- Run tests in file
		vim.keymap.set("n", "<leader>F", function()
			require("neotest").run.run(vim.fn.expand("%"))
		end, { desc = "Run tests in file" }),
	},
}
