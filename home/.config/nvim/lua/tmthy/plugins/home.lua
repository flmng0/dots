---@module "lazy"
---@type { [number]: LazySpec }
return {
	-- "conversational editing"
	{
		'Olical/conjure',
		lazy = true,
		ft = { 'clojure' },
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
