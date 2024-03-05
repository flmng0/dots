return {
	"echasnovski/mini.nvim",
	version = false,

	config = function()
		require("mini.starter").setup()
		require("mini.statusline").setup()
		require("mini.surround").setup()
		require("mini.indentscope").setup()
		require("mini.comment").setup()
		require("mini.splitjoin").setup()
		require("mini.pairs").setup()
		require("mini.files").setup()
		require("mini.completion").setup()

		vim.keymap.set("n", "<leader>e", function()
			if not MiniFiles.close() then
				MiniFiles.open()
			end
		end)
	end,
}
