return {
	{
		"rachartier/tiny-code-action.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "LspAttach",
		opts = {
			picker = "snacks",
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				["*"] = {
					keys = {
						{
							"<leader>ca",
							function()
								require("tiny-code-action").code_action()
							end,
							desc = "Code Action",
							mode = { "n", "x" },
							has = "codeAction",
						},
					},
				},
			},
		},
	},
}
