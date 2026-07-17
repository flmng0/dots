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
	if opts.count == -1 then
		return
	end
	local buf = api.nvim_get_current_buf()
	local m_start = api.nvim_buf_get_mark(buf, '<')
	local m_end = api.nvim_buf_get_mark(buf, '>')

	local range = vim.range.cursor(buf, m_start, m_end)
	range:to_extmark()


	local ns = api.nvim_create_namespace('scratch')
	api.nvim_buf_clear_namespace(buf, ns, 0, -1)

	api.nvim_buf_set_extmark(buf, ns, range.start_row, range.start_col, {
		end_line = range.end_row,
		end_col = range.end_col + 1,
		conceal = '',
		virt_text_hide = true,
		virt_text_pos = 'inline',
		virt_text = { { opts.args, "IncSearch" } }
	})
end, { range = true, nargs = '?' })
