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
	-- Load the 'brandon' module.
	local brandon = loadfile('lua/tmthy/brandon.lua')
	-- Check if the file loaded successfully.
	if brandon == nil then
		vim.print("Oh no")
		return
	end
	-- If there are arguments provided in opts.args, call the instruct function.
	if #opts.args > 0 then
		-- Pass the arguments and the start/end lines (adjusted to 0-based index).
		brandon().instruct(opts.args, opts.line1 - 1, opts.line2 - 1)
	end
end

function make_split_tab(src_bufid, changes)
	local bufid = api.nvim_create_buf(false, true)
	api.nvim_buf_set_name(bufid, "AI: Original Text")

	local buf2id = api.nvim_create_buf(false, true)
	api.nvim_buf_set_name(buf2id, "AI: Changes")

	local curr_text = api.nvim_buf_get_lines(src_bufid, 0, -1, true)
	api.nvim_buf_set_lines(bufid, 0, 0, false, curr_text)
	api.nvim_buf_set_lines(buf2id, 0, 0, false, curr_text)

	api.nvim_buf_set_lines(buf2id, changes.start_row, changes.end_row + 1, false, changes.lines)

	vim.bo[bufid].filetype = vim.bo[src_bufid].filetype
	vim.bo[buf2id].filetype = vim.bo[src_bufid].filetype

	local tabid = api.nvim_open_tabpage(bufid, false, {})

	local winid = api.nvim_tabpage_get_win(tabid)
	local win2id = api.nvim_open_win(buf2id, false, {
		win = winid,
		split = 'right',
		style = 'minimal'
	})

	vim.wo[winid].number = true
	vim.wo[winid].relativenumber = false

	local function sync_win(id)
		vim.wo[id].scrollbind = true
		vim.wo[id].diff = true
		vim.wo[id].cursorbind = true
		vim.wo[id].cursorline = true
	end
	sync_win(winid)
	sync_win(win2id)

	api.nvim_win_set_cursor(winid, { changes.start_row, 0 })

	local function cleanup()
		api.nvim_win_close(winid, true)
		api.nvim_win_close(win2id, true)

		api.nvim_buf_delete(bufid, { force = true })
		api.nvim_buf_delete(buf2id, { force = true })
	end

	vim.keymap.set('n', 'q', cleanup, { buf = bufid })
	vim.keymap.set('n', 'q', cleanup, { buf = buf2id })

	return { tabid }
end
