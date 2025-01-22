vim.notify('Creating user commands!')
vim.api.nvim_create_user_command('NewSession', function()
	vim.ui.input({ prompt = 'Session name' }, function(name)
		if name == nil then
			return
		end
		require('mini.sessions').write(name)
	end)
end, { bang = true })
