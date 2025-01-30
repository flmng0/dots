---@diagnostic disable: missing-fields
---@module "lazy"
---@type { [number]: LazySpec }
return {
	-- color scheme
	{
		'rebelot/kanagawa.nvim',
		lazy = false,
		priority = 1000,
		config = function()
			require('kanagawa').setup({
				overrides = function(colors)
					local winbar = {
						WinBarMain = { bg = colors.palette.sakuraPink, fg = colors.palette.sumiInk0 },
						WinBarEnd = { fg = colors.palette.sakuraPink },

						WinBarMainNC = { bg = colors.palette.sumiInk4, fg = colors.palette.springViolet1 },
						WinBarEndNC = { fg = colors.palette.sumiInk4 },
					}

					local info_bg = colors.palette.sumiInk4

					local statusline = {
						StatusLineGitBranch = { bg = info_bg, fg = colors.palette.oldWhite },
						StatusLineGitAdd = { bg = info_bg, fg = colors.palette.autumnGreen },
						StatusLineGitChange = { bg = info_bg, fg = colors.palette.autumnYellow },
						StatusLineGitDelete = { bg = info_bg, fg = colors.palette.autumnRed },
						StatusLineGitUnstaged = { bg = info_bg, fg = colors.palette.crystalBlue },

						StatusLineLspIcon = { bg = info_bg, fg = colors.palette.crystalBlue },
						StatusLineLspNames = { bg = info_bg, fg = colors.palette.oldWhite, italic = true },
					}

					-- Setup mode highlights (steal from MiniStatusLine highlights)
					for _, mode in ipairs({ 'Normal', 'Visual', 'Select', 'Insert', 'Replace', 'Command', 'Other' }) do
						statusline['StatusLineMode' .. mode] = { link = 'MiniStatusLineMode' .. mode }
					end

					return vim.tbl_extend('error', {}, winbar, statusline)
				end,
			})
			vim.cmd([[ colorscheme kanagawa ]])
		end,
	},

	-- auto detect indentation
	'tpope/vim-sleuth',

	-- completion
	{
		'saghen/blink.cmp',
		lazy = false,
		version = '*',
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = 'normal',
			},

			keymap = {
				preset = 'default',
			},
		},
	},

	-- telescope for fuzzy finding
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.8',
		command = 'Telescope',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope-fzy-native.nvim',
		},
		lazy = true,
		config = function()
			require('telescope').load_extension('fzy_native')
		end,
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
			local default_servers = {
				lua_ls = {},
			}

			local profile_servers = require('tmthy.servers.' .. _G.Profile)

			local servers = vim.tbl_deep_extend('error', default_servers, profile_servers)

			local tools = {
				'prettierd',
				'stylua',
			}

			require('mason').setup()

			-- keeping this function seperate for when I need to use a language-specific
			-- plugin as well, like flutter-tools
			local function setup_server(name)
				local config = servers[name] or {}
				config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities, true)
				require('lspconfig')[name].setup(config)
			end

			require('mason-lspconfig').setup({
				automatic_installation = false,
				ensure_installed = vim.tbl_keys(servers),
				handlers = {
					setup_server,
				},
			})

			require('tmthy.util').mason_ensure_installed(tools)
		end,
	},

	{
		'mfussenegger/nvim-dap',
		dependencies = {
			'williamboman/mason.nvim',
		},

		config = function()
			local default_config = require('tmthy.adapters.default')
			local profile_config = require('tmthy.adapters.' .. _G.Profile)

			local config = vim.tbl_deep_extend('force', default_config, profile_config)

			local dap = require('dap')

			if config.adapters then
				dap.adapters = config.adapters
			end
			if config.configurations then
				dap.configurations = config.configurations
			end
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
			local js_like = { 'deno_fmt', 'prettierd', 'prettier', stop_after_first = true }

			require('conform').setup({
				formatters_by_ft = {
					lua = { 'stylua' },

					javascript = js_like,
					typescript = js_like,
					javascriptreact = js_like,
					typescriptreact = js_like,
					svelte = js_like,
					css = js_like,
				},
				format_on_save = {
					timeout = 500,
					lsp_format = 'fallback',
				},
			})
		end,
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
		config = function()
			require('nvim-ts-autotag').setup({
				opts = {
					enable_close = true,
					enable_rename = true,
					enable_close_on_slash = true,
				},
			})

			local TagConfigs = require('nvim-ts-autotag.config.init')

			local heexConfig = TagConfigs:get('html'):extend('heex', {
				start_tag_pattern = { 'start_component' },
				start_name_tag_pattern = { 'component_name' },
				end_tag_pattern = { 'end_component' },
				end_name_tag_pattern = { 'component_name' },
				skip_tag_pattern = { 'end_component' },
			})
			TagConfigs:add(heexConfig)
			TagConfigs:add_alias('elixir', 'heex')
		end,
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

			require('mini.git').setup({})
			require('mini.diff').setup({})

			require('mini.sessions').setup({})

			local starter = require('mini.starter')

			-- Logic below is for saving a session for configuring Neovim
			-- which is manually inserted as an entry in the startup screen.
			local config_session_name = '_nvim-config'

			local sessions = function()
				local entries = starter.sections.sessions(5)()
				local filtered = vim.tbl_filter(function(s)
					return s.name ~= config_session_name
				end, entries)

				return filtered
			end

			starter.setup({
				items = {
					sessions,

					{
						name = 'Configure Neovim',
						action = function()
							local has_config_session = vim.tbl_contains(MiniSessions.detected, function(s)
								return s.name == config_session_name
							end, { predicate = true })

							if has_config_session then
								MiniSessions.read(config_session_name)
							else
								local config_dir = vim.fn.stdpath('config') --[[@as string]]
								vim.api.nvim_set_current_dir(config_dir)
								require('oil').open(config_dir)
								MiniSessions.write(config_session_name)
							end
						end,
						section = 'Builtin actions',
					},
					starter.sections.builtin_actions(),
				},
			})
		end,
	},
}
