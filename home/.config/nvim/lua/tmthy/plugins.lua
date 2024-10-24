---@module "lazy"
---@type { [number]: LazySpec }
return {
	-- color scheme
	{
		'rebelot/kanagawa.nvim',
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[ colorscheme kanagawa ]])
		end,
	},

	-- auto detect indentation
	'tpope/vim-sleuth',

	-- completion
	{
		'saghen/blink.cmp',
		lazy = false,
		version = 'v0.*',
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			highlight = {
				use_nvim_cmp_as_default = true,
			},
			nerd_font_variant = 'normal',
			keymap = {
				accept = '<C-y>',
			},
		},
	},

	-- telescope for fuzzy finding
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.8',
		command = 'Telescope',
		dependencies = { 'nvim-lua/plenary.nvim' },
		lazy = true,
	},

	-- oil.nvim for directory editing
	{
		'stevearc/oil.nvim',
		dependencies = { 'echasnovski/mini.icons' },
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
	},

	-- mini.icons setup; used by multiple plugins
	{ 'echasnovski/mini.icons', config = true },

	-- "thank you folke" everybody says in unison
	{
		'folke/lazydev.nvim',
		ft = 'lua',
		config = true,
	},

	-- lsp setup
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			{ -- for automatic installation of LSPs
				'williamboman/mason.nvim',
				config = true,
			},
			-- bridge between lspconfig and mason
			'williamboman/mason-lspconfig.nvim',

			{ -- for pretty lsp status
				'j-hui/fidget.nvim',
				config = true,
			},
		},
		config = function()
			local default_capabilities = vim.lsp.protocol.make_client_capabilities()

			-- server-name => configuration
			local servers = {
				gopls = {},
				lua_ls = {},
				ts_ls = {},
				emmet_language_server = {},
			}

			local tools = {
				'prettierd',
				'stylua',
			}

			require('mason').setup()

			-- keeping this function seperate for when I need to use a language-specific
			-- plugin as well, like flutter-tools
			local function setup_server(name)
				local config = servers[name] or {}
				config.capabilities = vim.tbl_deep_extend('force', {}, default_capabilities, config.capabilities or {})
				require('lspconfig')[name].setup(config)
			end

			require('mason-lspconfig').setup({
				ensure_installed = vim.tbl_keys(servers),
				handlers = {
					setup_server,
				},
			})

			-- Simple ensure_installed for tools based on:
			-- https://github.com/williamboman/mason.nvim/issues/1309#issuecomment-1555018732
			local registry = require('mason-registry')

			registry.refresh(function()
				for _, tool in ipairs(tools) do
					if not registry.is_installed(tool) then
						vim.notify('[mason.nvim] installing ' .. tool .. '...')
						local pkg = registry.get_package(tool)
						pkg:install()
					end
				end
			end)
		end,
	},

	{
		'folke/which-key.nvim',
		---@module 'which-key'
		---@type wk.Opts
		opts = {
			preset = 'helix',

			plugins = {
				marks = true,
				registers = true,

				spelling = {
					enabled = true,
					suggestions = 20,
				},

				presets = {
					operators = false,
					motions = false,
					text_objects = true,
					windows = true,
					nav = true,
					z = true,
					g = true,
				},
			},

			triggers = {
				{ '<auto>', mode = 'nxso' },
				{ '<leader>', mode = 'nv' },
				{ '<localleader>', mode = 'n' },
			},

			---@param mapping wk.Mapping
			filter = function(mapping)
				return mapping.preset
					or (mapping.plugin and mapping.plugin ~= '')
					or (mapping.desc and mapping.desc ~= '')
			end,

			---@param node wk.Node
			expand = function(node)
				return not node.desc
			end,

			icons = {
				mappings = false,
			},

			win = {
				border = 'none',
				padding = { 1, 3 },
			},

			show_help = false,
		},
	},

	-- conform for file formatting
	{
		'stevearc/conform.nvim',
		config = function()
			local js_like = { 'prettierd', 'prettier', stop_after_first = true }

			require('conform').setup({
				formatters_by_ft = {
					lua = { 'stylua' },

					javascript = js_like,
					typescript = js_like,
					javascriptreact = js_like,
					typescriptreact = js_like,
				},
				format_on_save = {
					timeout = 500,
					lsp_format = 'fallback',
				},
			})
		end,
	},

	{ -- for flutter
		'nvim-flutter/flutter-tools.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		ft = 'dart',
		config = true,
	},

	-- just some prettification of UI elements
	{
		'stevearc/dressing.nvim',
		opts = {
			input = {
				border = 'single',
			},
			select = {
				builtin = {
					border = 'none',
				},
			},
		},
	},

	-- treesitter for highlighting and text-objects
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		config = function()
			local configs = require('nvim-treesitter.configs')

			---@diagnostic disable-next-line: missing-fields
			configs.setup({
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },

				incremental_selection = {
					enable = true,
					keymaps = {
						-- Mnemonic: "arround", "scope" and "inside"
						init_selection = '<A-a>',
						node_incremental = '<A-a>',
						scope_incremental = '<A-s>',
						node_decremental = '<A-i>',
					},
				},

				textobjects = {
					select = {
						enable = true,
						lookahead = true,

						keymaps = {
							['aa'] = '@parameter.outer',
							['ia'] = '@parameter.inner',

							['af'] = '@function.outer',
							['if'] = '@function.inner',
						},
					},

					move = {
						enable = true,
						set_jumps = true,

						goto_next_start = {
							[']m'] = { query = '@function.outer', desc = 'Goto next function start' },
							[']a'] = { query = '@parameter.outer', desc = 'Goto next parameter start' },
							[']='] = { query = '@assignment.outer', desc = 'Goto next assignment start' },
						},

						goto_next_end = {
							[']M'] = { query = '@function.outer', desc = 'Goto next function end' },
							[']A'] = { query = '@parameter.outer', desc = 'Goto next parameter end' },
						},

						goto_previous_start = {
							['[m'] = { query = '@function.outer', desc = 'Goto previous function start' },
							['[a'] = { query = '@parameter.outer', desc = 'Goto previous parameter start' },
							['[='] = { query = '@assignment.outer', desc = 'Goto previous assignment start' },
						},

						goto_previous_end = {
							['[M'] = { query = '@function.outer', desc = 'Goto previous function end' },
							['[A'] = { query = '@parameter.outer', desc = 'Goto previous parameter end' },
						},
					},
				},
			})
		end,
	},

	{
		'windwp/nvim-ts-autotag',
		dependencies = {
			'nvim-treesitter/nvim-treesitter',
		},
		opts = {
			opts = {
				enable_close = true,
				enable_rename = true,
				enable_close_on_slash = true,
			},
		},
	},

	-- using windwp's autopairs instead of mini.pairs for HTML tag indentation on <CR>
	{
		'windwp/nvim-autopairs',
		opts = { map_cr = true },
	},

	-- mini.nvim plugins... various utilities really
	{
		'echasnovski/mini.nvim',
		version = false,
		config = function()
			require('mini.surround').setup({
				respect_selection_type = true,
			})

			require('mini.move').setup({})
		end,
	},
}
