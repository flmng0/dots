local mason_registry = require('mason-registry')
local vue_lsp_root = mason_registry.get_package('vue-language-server'):get_install_path()
local vue_lsp_path = vue_lsp_root .. '/node_modules/@vue/language-server'

return {
	omnisharp = {},
	ts_ls = {
		init_options = {
			plugins = {
				{
					name = '@vue/typescript-plugin',
					location = vue_lsp_path,
					languages = { 'vue' },
				},
			},
		},
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
