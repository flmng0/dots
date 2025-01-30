local servers = {
	omnisharp = {},
	ts_ls = {
		init_options = {},
		filetypes = {
			'javascript',
			'typescript',
			'javascriptreact',
			'typescriptreact',
			'vue',
		},
	},
	volar = {},
}

local mason_registry = require('mason-registry')
local has_vue = mason_registry.is_installed('vue-language-server')
if has_vue then
	local vue_lsp_root = mason_registry.get_package('vue-language-server'):get_install_path()
	local vue_lsp_path = vue_lsp_root .. '/node_modules/@vue/language-server'

	servers.ts_ls['init_options'] = {
		plugins = {
			{
				name = '@vue/typescript-plugin',
				location = vue_lsp_path,
				languages = { 'vue' },
			},
		},
	}
end

return servers
