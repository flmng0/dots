vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- Generic bootstrap for GitHub repos, from hotpot.nvim documentation.
local function bootstrap(plugin, branch)
	---@diagnostic disable-next-line: unused-local
	local _user, repo = string.match(plugin, '(.+)/(.+)')
	local repo_path = vim.fn.stdpath('data') .. '/lazy/' .. repo

	if vim.fn.isdirectory(repo_path) == 0 then
		vim.notify('Installing ' .. plugin .. ' ' .. branch)

		local repo_url = 'https://github.com/' .. plugin .. '.git'
		local out = vim.fn.system({
			'git',
			'clone',
			'--filter=blob:none',
			'--branch=' .. branch,
			repo_url,
			repo_path,
		})

		if vim.v.shell_error ~= 0 then
			vim.api.nvim_echo({
				{ 'Failed to clone ' .. plugin .. ':\n', 'ErrorMsg' },
				{ out, 'WarningMsg' },
				{ '\nPress any key to exit...' },
			}, true, {})
			vim.fn.getchar()
			os.exit(1)
		end
	end

	return repo_path
end

local lazy_path = bootstrap('folke/lazy.nvim', 'stable')
local hotpot_path = bootstrap('rktjmp/hotpot.nvim', 'v0.14.8')

-- As per Lazy's install instructions, but also include hotpot
vim.opt.runtimepath:prepend({ hotpot_path, lazy_path })

-- You must call vim.loader.enable() before requiring hotpot unless you are
-- passing {performance = {cache = false}} to Lazy.
vim.loader.enable()

require('hotpot')

require('lazy').setup({
	performance = {
		rtp = {
			paths = { vim.fn.stdpath('config').."/.compiled" }
		}
	},
	spec = {
		'rktjmp/hotpot.nvim',
		{ import = 'plugins' },
	},
	change_detection = {
		enabled = false,
	},
})

require('tmthy')
