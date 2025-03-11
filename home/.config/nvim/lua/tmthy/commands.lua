vim.api.nvim_create_user_command('BufOnly', [[%bd|e#]], { nargs = 0 })

local function session_complete()
	local sessions = require('mini.sessions').detected
	local names = vim.tbl_keys(sessions)

	return names
end

vim.api.nvim_create_user_command('NewSession', function(opts)
	local session_name = opts.args
	local force = opts.bang

	require('mini.sessions').write(session_name, { force = force })
end, { bang = true, nargs = 1 })

vim.api.nvim_create_user_command('DeleteSession', function(opts)
	local session_name = opts.args
	local force = opts.bang

	local sessions = require('mini.sessions')

	local session_names = vim.tbl_keys(sessions.detected)

	if vim.tbl_contains(session_names, session_name) then
		sessions.delete(session_name, { force = force })

		if vim.bo.filetype == 'ministarter' then
			require('mini.starter').refresh()
		end
	else
		vim.notify('ERR: No session named ' .. session_name)
	end
end, { bang = true, nargs = 1, complete = session_complete })

vim.api.nvim_create_user_command('OpenSession', function(opts)
	local session_name = opts.args
	local force = opts.bang

	require('mini.sessions').read(session_name, { force = force })
end, { bang = true, nargs = 1, complete = session_complete })
