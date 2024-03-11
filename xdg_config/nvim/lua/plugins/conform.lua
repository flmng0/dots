return {
	"stevearc/conform.nvim",

	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettierd" },
				ocaml = { "ocamlformat" },
			},

			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		})

		vim.api.nvim_create_user_command("Format", function()
			require("conform").format()
		end, {})
	end,
}
