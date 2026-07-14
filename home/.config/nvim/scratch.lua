local api = vim.api

api.nvim_create_autocmd("BufWritePost", {
	group = api.nvim_create_augroup("tmthy.scratch", {}),
	callback = function(ev)
		vim.keymap.set('v', '<C-s>', "<Esc>:'<,'>DoThing Comment what this code does<CR>", { buf = ev.buf })

		local path = vim.fn.stdpath("config") .. "/scratch.lua"
		vim.cmd("luafile " .. path)
	end
})

api.nvim_create_user_command("DoThing", function(opts) do_thing(opts) end, { range = true, nargs = '?' })

function do_thing(opts)
	local brandon = loadfile('lua/tmthy/brandon.lua')
	if brandon == nil then
		vim.print("Oh no")
		return
	end
	if #opts.args > 0 then
		brandon().instruct(opts.args)
	end
end
