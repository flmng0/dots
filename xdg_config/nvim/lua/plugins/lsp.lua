return {
	"neovim/nvim-lspconfig",

	config = function()
		local languages = {
			astro = {},
			tsserver = {},
			elixirls = {
				cmd = { "elixir-ls" },
			},
		}

		local lspconfig = require("lspconfig")

		for server, options in ipairs(languages) do
			lspconfig[server].setup(options)
		end
	end,
}
