return {
	"smjonas/inc-rename.nvim",
	cmd = "IncRename",
	opts = {
		input_buffer_type = "dressing",
	},
	keys = {
		{ "<leader>rn", mode = { "n" }, ":IncRename ", desc = "Rename" },
	},
}
