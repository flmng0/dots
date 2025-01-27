vim.api.nvim_create_user_command('NewSession', function(opts)
	local session_name = opts.args
	local force = opts.bang

	require('mini.sessions').write(session_name, { force = force })
end, { bang = true, nargs = 1 })
