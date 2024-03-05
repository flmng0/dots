return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.5",

	dependencies = {
		"nvim-lua/plenary.nvim",

		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},

	config = function()
		require("telescope").setup({
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader><leader>", builtin.find_files)
	end,
}
