vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- Mac used at work
_G.iswork = vim.loop.os_uname().sysname == "Darwin"


-- Generic bootstrap for GitHub repos, from hotpot.nvim documentation.
local function bootstrap(plugin, branch)
	---@diagnostic disable-next-line: unused-local
	local _user, repo = string.match(plugin, '(.+)/(.+)')
	local repo_path = vim.fn.stdpath('data') .. '/lazy/' .. repo

	local did_bootstrap = false

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

		did_bootstrap = true
	end

	return repo_path, did_bootstrap
end

local lazy_path = bootstrap('folke/lazy.nvim', 'stable')
local hotpot_path, did_bootstrap = bootstrap('rktjmp/hotpot.nvim', 'v2.1.1')

-- As per Lazy's install instructions, but also include hotpot
vim.opt.runtimepath:prepend({ hotpot_path, lazy_path })

-- You must call vim.loader.enable() before requiring hotpot unless you are
-- passing {performance = {cache = false}} to Lazy.
vim.loader.enable()

local config_path = vim.fn.stdpath("config")

if did_bootstrap then
	require('hotpot.api.make').auto.build(config_path)
end

require('hotpot')

local api = require('hotpot.api')
local context = api.context(config_path)

local hotpot_destination = context.locate("destination")

require('lazy').setup({
	performance = {
		rtp = {
			paths = { hotpot_destination, hotpot_destination.."/after" }
		}
	},
	spec = {
		{'rktjmp/hotpot.nvim', lazy = false },
		{ import = 'plugins' },
	},
	change_detection = {
		enabled = false,
	},
})

require('tmthy')
