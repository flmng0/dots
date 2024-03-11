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
		vim.keymap.set("n", "<leader>:", builtin.commands)
		vim.keymap.set("n", "<leader>/", builtin.live_grep)
		vim.keymap.set("n", "<leader>h", builtin.help_tags)
		vim.keymap.set("n", "<leader>s", builtin.lsp_document_symbols)
		vim.keymap.set("n", "<leader>S", builtin.lsp_workspace_symbols)
	end,
}
