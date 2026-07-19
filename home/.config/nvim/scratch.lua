local api = vim.api

api.nvim_create_autocmd("BufWritePost", {
	group = api.nvim_create_augroup("tmthy.scratch", {}),
	callback = function(ev)
		vim.keymap.set('v', '<C-s>', ":DoThing Test<CR>", { buf = ev.buf })

		local path = vim.fn.stdpath("config") .. "/scratch.lua"
		vim.cmd("luafile " .. path)
	end
})


api.nvim_create_user_command("DoThing", function(opts)
	local uv = vim.uv
	local cwd = uv.cwd()
	if cwd == nil then
		return
	end

	-- local i = 0
	-- vim.system({ 'fd', '-H' }, {
	-- 	cwd = cwd,
	-- 	stdout = function(_, data)
	-- 		vim.print(i .. ': ' .. data)
	-- 		i = i + 1
	-- 	end
	-- })

	for entry in vim.fs.dir(cwd, { depth = 10 }) do
		local stat = vim.uv.fs_stat(entry)
		vim.print(entry .. ": " .. stat.type)
	end


	-- local butil = require('brandon.util')
	-- local system = butil.message('system',
	-- 	[[You are a text-file searcher. Respond with the answer to the user's question about their files.]])
	-- local user = {
	-- 	role = 'user',
	-- 	content = {
	-- 		{ type = 'text', text = 'What are the names of my files?' },
	-- 		{
	-- 			type = 'text',
	-- 			text = '--- file: a.txt ---\nfoo bar baz',
	-- 		},
	-- 		{
	-- 			type = 'text',
	-- 			text = '--- file: b.txt ---\nfoo bar baz',
	-- 		},
	-- 		{
	-- 			type = 'text',
	-- 			text = '--- file: d.txt ---\nfoo bar baz',
	-- 		},
	-- 	}
	-- }
	--
	-- local req = butil.request({ system, user })
	-- req.stream = nil
	--
	-- local curl_cmd = {
	-- 	'curl',
	-- 	'--silent',
	-- 	'--no-buffer',
	-- 	'--request', 'POST',
	-- 	'--url', 'http://localhost:8080/v1/chat/completions',
	-- 	'--header', 'Content-Type: application/json',
	-- 	'--data', '@-'
	-- }
	--
	-- vim.system(curl_cmd, {
	-- 	stdin = vim.json.encode(req),
	-- 	text = true,
	-- }, function(res)
	-- 	vim.print(vim.json.decode(res.stdout))
	-- end)
end, { range = true, nargs = '?' })

-- local t = { [140] = 12 }
-- vim.print(t)
-- t[140] = nil
-- vim.print(t)
