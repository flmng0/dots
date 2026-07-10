local api = vim.api

api.nvim_create_autocmd("BufWritePost", {
	group = api.nvim_create_augroup("tmthy.scratch", {}),
	callback = function(ev)
		vim.keymap.set('v', '<C-s>', "<Esc>:'<,'>DoThing Comment this code<CR>", { buf = ev.buf })

		local path = vim.fn.stdpath("config") .. "/scratch.lua"
		vim.cmd ("luafile " .. path)
	end
})

api.nvim_create_user_command("DoThing", function(opts) do_thing(opts) end, { range = true, nargs = '?' })

local bufid = 223

function call_llama(instruction, opts)
	local system_lines = {
		[[You are a coding assistant. You may ONLY reply with the result of applying INSTRUCTION to SNIPPET. Do not add extra code. Respond with the code modifications only. Consider the local context before (PREFIX) and after (SUFFIX) the SNIPPET.]],
		"<PREFIX>", opts.prefix_lines, "</PREFIX>",
		"<SNIPPET>", opts.snippet_lines, "</SNIPPET>",
		"<SUFFIX>", opts.suffix_lines, "</SUFFIX>",
	}

	local user_lines = {
		"<INSTRUCTION>", instruction, "</INSTRUCTION>"
	}

	local system_content = vim.iter(system_lines):flatten():join('\n')
	local user_content = vim.iter(user_lines):join('\n')

	local system_message = { role = 'system', content = system_content }
	local user_message = { role = 'user', content = user_content }

	local request = {
		messages = { system_message, user_message },
		model = vim.env.LLAMA_INST_MODEL, 
		min_p = 0.1,
		temperature = 0.1,
		samplers = {'min_p', 'temperature'},
		stream = true,
		cache_prompt = true,
	}

	local cmd = {
		'curl',
		'--silent', 
		'--no-buffer', 
		'--request', 'POST',
		'--url', 'http://localhost:2276/v1/chat/completions',
		'--header', 'Content-Type: application/json',
		'--data', '@-'
	}

	local set_lines_scheduled = vim.schedule_wrap(api.nvim_buf_set_lines)
	local set_text_scheduled = vim.schedule_wrap(api.nvim_buf_set_text)
	local bufid = 223

	if bufid == nil then
		bufid = api.nvim_create_buf(false, true)
		-- TODO: Name buffer
	end

	local so_far = ''

	api.nvim_buf_set_lines(bufid, 0, -1, false, {})

	local function parse_event(line)
		if not vim.startswith(line, 'data: ') then
			return
		end

		local body = string.sub(line, #'data: ' + 1)
		local okay, data = pcall(vim.json.decode, body, { luanil = { object = true, array = true } })
		if not okay then
			return
		end

		local choices = data['choices']
		if choices == nil or #choices == 0 then
			return
		end

		local delta = choices[1]['delta']
		if delta == nil or vim.tbl_isempty(delta) then
			return
		end

		local reasoning = delta['reasoning_content']
		local content = delta['content']

		if reasoning or content == nil then
			return
		end
		
		return content
	end

	local linenum = 0

	vim.system(cmd, {
		stdin = vim.json.encode(request),
		text = true,
		stdout = function (err, text)
			if text == nil then
				return
			end

			local continue = false

			for event in vim.gsplit(text, '\n\n') do
				local delta = parse_event(event)
	
				if delta ~= nil then
					so_far = so_far .. delta
					continue = true
				end
			end

			if not continue then
				return
			end

			local last = 1
			local newline = string.find(so_far, '\n')
			local lines = {}

			while newline ~= nil do
				local line = string.sub(so_far, last, newline - 1)
				last = newline + 1
				table.insert(lines, line)
 
				newline = string.find(so_far, '\n', newline + 1)
			end

			if #lines > 0 then
				set_lines_scheduled(bufid, linenum, linenum, false, lines)
				linenum = linenum + #lines
			end

			so_far = string.sub(so_far, last)
			set_lines_scheduled(bufid, linenum, linenum + 1, false, { so_far })
		end
	})
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

	if #opts.args > 0 then
		call_llama(opts.args, llama_opts)
	else
		vim.ui.input({ prompt = "Instruction: ", scope = "cursor" }, function (instruction)
			if instruction ~= nil and #instruction > 0 then
				call_llama(instruction, llama_opts)
			end
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

