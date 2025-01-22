require('tmthy.options')

local spec = {
	{ import = 'tmthy.plugins.default' },
}

local hostmap = {
	['DESKTOP-H1NUKS2'] = 'work',
	['iDurian'] = 'home',
}

_G.Profile = hostmap[vim.fn.hostname()] or 'home'

table.insert(spec, { import = 'tmthy.plugins.' .. _G.Profile })

require('lazy').setup({ spec = spec, change_detection = { enabled = false } })

vim.api.nvim_create_autocmd('User', {
	pattern = 'VeryLazy',
	callback = function()
		require('tmthy.commands')
	end,
})
