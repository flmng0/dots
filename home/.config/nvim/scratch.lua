local api = vim.api

api.nvim_create_autocmd("BufWritePost", {
	group = api.nvim_create_augroup("tmthy.scratch", {}),
	callback = function(ev)
		vim.keymap.set('v', '<C-s>', "<Esc>:'<,'>DoThing<CR>", { buf = ev.buf })

		local path = vim.fn.stdpath("config") .. "/scratch.lua"
		vim.cmd ("luafile " .. path)
	end
})

api.nvim_create_user_command("DoThing", function(opts) do_thing(opts) end, { range = true, nargs = '?' })

function call_llama(instruction, opts)
	
	local lines = {
		[[You are a coding assistant. You may ONLY reply with the result of applying INSTRUCTION to SNIPPET. Do not add extra code. Respond with the code modifications only. Consider the local context before (PREFIX) and after (SUFFIX) the SNIPPET.]],
		"<INSTRUCTION>", instruction, "</INSTRUCTION>",
		"<PREFIX>", opts.prefix_lines, "</PREFIX>",
		"<SNIPPET>", opts.snippet_lines, "</SNIPPET>",
		"<SUFFIX>", opts.suffix_lines, "</SUFFIX>",
	}

	local prompt = vim.iter(lines):flatten():join('\n')
	vim.print(prompt)
end

function do_thing(opts)
	local range_start = opts.line1 - 1
	local range_end = opts.line2 - 1

	local range = range_end - range_start

	local prefix_len = 16
	local suffix_len = 16

	local full_start = range_start - prefix_len
	local full_end = range_end + suffix_len + 1

	local all_lines = api.nvim_buf_get_lines(0, full_start, full_end, false)

	local prefix_end = prefix_len
	local prefix_lines = vim.list_slice(all_lines, 1, prefix_end)

	local snippet_start, snippet_end = prefix_end + 1, prefix_end + 1 + range
	local snippet_lines = vim.list_slice(all_lines, snippet_start, snippet_end)

	local suffix_start = snippet_end + 1
	local suffix_lines = vim.list_slice(all_lines, suffix_start)

	local llama_opts = {
		prefix_lines = prefix_lines,
		snippet_lines = snippet_lines,
		suffix_lines = suffix_lines,
	}

	if opts.args[0] then
		call_llama(opts.args[0], llama_opts)
	else
		vim.ui.input({ prompt = "Instruction: ", scope = "cursor" }, function (instruction)
			call_llama(instruction, llama_opts)
		end)
	end


	-- local prefix = vim.iter(prefix_lines):join('\n')
	-- local snippet = vim.iter(snippet_lines):join('\n')
	-- local suffix = vim.iter(suffix_lines):join('\n')

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

