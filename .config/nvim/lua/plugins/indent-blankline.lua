return {
	"lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPre", "BufNewFile" },
	main = "ibl",
	enabled = false,
	opts = {
		scope = {
			show_start = false,
		},
		indent = { char = "┊" },
	},
}
