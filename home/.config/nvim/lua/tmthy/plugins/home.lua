---@module "lazy"
---@type { [number]: LazySpec }
return {
	-- "conversational editing"
	{
		'Olical/conjure',
		lazy = true,
		ft = { 'clojure' },
		init = function()
			vim.g['conjure#mapping#doc_word'] = false
		end,
	},

	-- Handling of Lisp-like languages
	{
		'dundalek/parpar.nvim',
		dependencies = { 'gpanders/nvim-parinfer', 'julienvincent/nvim-paredit' },
		opts = {},
	},

	{ -- for flutter
		'nvim-flutter/flutter-tools.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		ft = 'dart',
		config = true,
	},
}
