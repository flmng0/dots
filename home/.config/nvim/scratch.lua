local api = vim.api

api.nvim_create_autocmd("BufWritePost", {
	group = api.nvim_create_augroup("tmthy.scratch", {}),
	callback = function(ev)
		vim.keymap.set('n', '<C-s>', function()
			do_thing()
		end, { buf = ev.buf })

		local path = vim.fn.stdpath("config") .. "/scratch.lua"
		vim.cmd ("luafile " .. path)
	end
})

-- local bufid = api.nvim_create_buf(false, true)
-- api.nvim_buf_set_name(bufid, "Testing buf 2")
-- vim.print(bufid)
-- api.nvim_buf_set_lines(bufid, 0, 0, false, {"a", "b", "c"})

local even_line = ""
local odd_line = ""

for i = 1, vim.o.columns do
	local even = i % 2 == 0
	even_line = even_line .. (even and "╱" or " ")
	odd_line = odd_line .. (even and " " or "╱")
end

function do_thing()
	local bufid = 376
	local buf2id = 154

	require('tmthy.diff_buf')(bufid, buf2id)
end


function make_split_tab()
	local bufid = api.nvim_create_buf(false, true)
	api.nvim_buf_set_name(bufid, "Review Changes from AI")

	local curr_text = api.nvim_buf_get_lines(0, 0, -1, true)
	api.nvim_buf_set_lines(bufid, 0, 0, false, curr_text)

	vim.bo[bufid].filetype = vim.bo.filetype

	local tabid = api.nvim_open_tabpage(bufid, true, {})

	local winid = api.nvim_tabpage_get_win(tabid)
	local win2id = api.nvim_open_win(bufid, false, {
		split = 'right',
		style = 'minimal'
	})

	vim.wo[winid].scrollbind = true
	vim.wo[win2id].scrollbind = true

	vim.keymap.set('n', 'q', function()
		api.nvim_win_close(winid, true)
		api.nvim_win_close(win2id, true)

		api.nvim_buf_delete(bufid, { force = true })
	end, { buf = bufid })
end

