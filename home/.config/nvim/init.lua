local function bootstrap(plugin, branch)
	local _, repo = string.match(plugin, '(.+)/(.+)')
	local clone_path = vim.fn.stdpath('data') .. '/lazy/' .. repo

	if not (vim.uv or vim.loop).fs_stat(clone_path) then
		vim.notify('Bootstrapping ' .. plugin .. ' ' .. branch)

		local repo_url = 'https://github.com/' .. plugin .. '.git'
		local output = vim.fn.system({
			'git',
			'clone',
			'--filter=blob:none',
			'--branch=' .. branch,
			repo_url,
			clone_path,
		})

		if vim.v.shell_error ~= 0 then
			vim.api.nvim_echo({
				{ 'Failed to bootstrap' .. plugin .. ':\n', 'ErrorMsg' },
				{ output, 'WarningMsg' },
				{ '\nPress any key to exit...' },
			}, true, {})
			vim.fn.getchar()

			os.exit(vim.v.shell_error)
		end
	end

	return clone_path
end

local lazy_path = bootstrap('folke/lazy.nvim', 'stable')

vim.opt.runtimepath:prepend(lazy_path)

vim.loader.enable()

require('tmthy')
