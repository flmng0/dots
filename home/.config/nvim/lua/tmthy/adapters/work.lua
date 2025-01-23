require('tmthy.util').mason_ensure_installed({ 'php-debug-adapter' })

local registry = require('mason-registry')
local php_dap_root = registry.get_package('php-debug-adapter'):get_install_path()
local php_dap_path = php_dap_root .. '/extension/out/phpDebug.js'

return {
	adapters = {
		php = {
			type = 'executable',
			command = 'node',
			args = { php_dap_path },
		},
	},

	configurations = {
		php = {
			{
				type = 'php',
				request = 'launch',
				-- Marked as global so it is easy to tell when it's not from .vscode/launch.json
				name = '[Global] Listen for Xdebug',
				port = 9003,
			},
		},
	},
}
