require('tmthy.options')

local spec = {
	{ import = 'tmthy.plugins.default' },
}

-- Check whether the current directory is within ~/work
-- or check that the hostname is a defined work device.
local function get_profile()
	local work_dir = vim.fn.expand('~/work')

	if vim.fn.getcwd():match('^' .. work_dir) then
		return 'work'
	end

	local hostmap = {
		['DESKTOP-H1NUKS2'] = 'work',
	}

	return hostmap[vim.fn.hostname()] or 'home'
end

_G.Profile = get_profile()

table.insert(spec, { import = 'tmthy.plugins.' .. _G.Profile })

require('lazy').setup({ spec = spec, change_detection = { enabled = false } })

vim.api.nvim_create_autocmd('User', {
	pattern = 'VeryLazy',
	callback = function()
		require('tmthy.commands')
	end,
})
