local api = vim.api

---@param prompt string
---@param cb fun(input: string | nil, context: brandon.Context[])
local function input(prompt, cb)
	local bufid = api.nvim_create_buf(false, true)

	local augroup = api.nvim_create_augroup('brandon.util.input', { clear = true })

	api.nvim_create_autocmd('BufWinEnter', {
		group = augroup,
		command = 'startinsert',
		buf = bufid
	})

	local ed_width = vim.o.columns
	local ed_height = vim.o.lines

	local want_width = 80
	local want_height = 10

	local pad = 2
	local width = math.min(ed_width, want_width) - pad
	local height = math.min(ed_height, want_height) - pad

	local x = math.floor((ed_width - width) / 2)
	local y = math.floor((ed_height - height) / 2)

	local winid = api.nvim_open_win(bufid, true, {
		style = 'minimal',
		border = 'single',
		relative = 'editor',
		title = prompt,
		footer = '<C-d> - accept',
		footer_pos = 'right',
		width = width,
		height = height,
		col = x,
		row = y,
	})
	vim.wo[winid].scrollbind = false
	vim.wo[winid].diff = false
	vim.wo[winid].cursorbind = false
	vim.wo[winid].wrap = true

	---@type brandon.Context[]
	local context = {}

	local function cleanup()
		api.nvim_del_augroup_by_name('brandon.util.input')
		api.nvim_buf_delete(bufid, { force = true })

		if api.nvim_get_mode().mode == 'i' then
			api.nvim_input('<Esc>')
		end
	end

	local function cancel()
		cleanup()
		cb(nil, context)
	end

	local function accept()
		local lines = api.nvim_buf_get_lines(bufid, 0, -1, false)
		local text = vim.iter(lines):join('\n')
		cleanup()
		cb(text, context)
	end

	api.nvim_create_autocmd('WinClosed', {
		buf = bufid,
		group = augroup,
		callback = cancel,
	})

	vim.keymap.set({ 'n', 'i' }, '<C-c>', cancel, { buf = bufid })
	vim.keymap.set({ 'n', 'i' }, '<C-d>', accept, { buf = bufid })
end

return input
