local input = require('brandon.input')
local config = require('brandon.config')
local SessionState = require('brandon.session_state')
local util = require('brandon.util')
local api = vim.api

---@type { integer: brandon.Session }
local sessions = {}
local session_id = 0

---@param session brandon.Session
local function init_preview(session)
	local ns = session.namespace
	local source = session.source

	local function sep(char)
		return {
			{ string.rep(char, vim.o.columns), config.preview.header_hl }
		}
	end

	local pad = string.rep(" ", vim.o.columns)
	local sep_top = sep("▔")
	local sep_bot = sep("▁")

	---@param lines string[]
	local function update_virtual_lines(lines)
		local virt_lines = vim.iter(lines):map(function(line)
			return {
				{ line .. pad, config.preview.header_hl }
			}
		end):totable()

		table.insert(virt_lines, 1, sep_top)
		table.insert(virt_lines, sep_bot)

		local exists = util.update_extmark(source.bufid, ns, session.extmark, {
			virt_lines = virt_lines,
			virt_lines_above = true,
		})

		if not exists then
			session:cleanup()
		end
	end

	update_virtual_lines({ "\tWaiting for output..." })

	session:on_update(function(state)
		if state.done then
			update_virtual_lines({ "\tDone!" })
		elseif state.stage == 'thinking' then
			local latest = vim.iter(vim.gsplit(state.reasoning, '\n')):last()
			update_virtual_lines({ "\tThinking... " .. latest })
		elseif state.stage == 'generating' then
			local preview_lines = {}
			local lines = state:lines()

			for i = math.min(#lines, 5), 1, -1 do
				local line = lines[#lines - i + 1]
				preview_lines[#preview_lines + 1] = line
			end

			update_virtual_lines(preview_lines)
		end
	end)
end

---@class brandon.Session
local Session = {}

function Session.get_by_id(id)
	return sessions[id]
end

---@return Iter
function Session.iter()
	return vim.iter(vim.tbl_values(sessions))
end

local function setup_keymap(bufid)
	local function find_cursor_session()
		for session in Session.iter() do
			if session:cursor_inside() then
				return session
			end
		end
	end
	vim.keymap.set('n', config.keymap.view_changes, function()
		local session = find_cursor_session()
		if session == nil then
			vim.print("Not inside a Brandon session.")
			return
		end

		if not session.state.done then
			vim.print("Be patient! Generation is not finished yet.")
			return
		end

		session:open_changes()
	end, { buf = bufid })

	vim.keymap.set('n', config.keymap.cancel, function()
		local session = find_cursor_session()
		if session == nil then
			vim.print("Not inside a Brandon session.")
			return
		end

		session:cleanup()
	end, { buf = bufid })
end

local function maybe_cleanup_keymap(bufid)
	local reamining = Session.iter():find(function(session)
		return session.source.bufid == bufid
	end)

	if reamining == nil then
		vim.keymap.del('n', config.keymap.view_changes, { buf = bufid })
		vim.keymap.del('n', config.keymap.cancel, { buf = bufid })
	end
end

---Start a new session, given
---@param source brandon.SessionSource Range of source code to affect
---@param instruction string Initial instruction
---@param context brandon.Context[] Additional context for the prompt
---@return brandon.Session
function Session:start(source, instruction, context)
	local this_id = session_id
	session_id = session_id + 1

	local ns = api.nvim_create_namespace('')
	local is_insert = source.end_line == nil

	local extmark = api.nvim_buf_set_extmark(source.bufid, ns, source.start_line, 0, {
		end_row = is_insert and source.start_line or source.end_line + 1,
		invalidate = false,
		undo_restore = false,
		hl_group = config.preview.snippet_hl,
		hl_eol = config.preview.snippet_hl ~= nil,
		virt_text = is_insert and { { '... working' } } or nil
	})

	---@type brandon.Session
	local session = {
		id = this_id,
		state = SessionState:init(),
		cancelled = false,
		messages = {
			util.system_message(source),
		},
		system = nil,
		namespace = ns,
		augroup = api.nvim_create_augroup('brandon.session.' .. this_id, { clear = true }),
		extmark = extmark,
		source = source,
		scratch = nil,
		callbacks = {},
	}
	table.insert(sessions, this_id, session)
	setmetatable(session, { __index = self })

	init_preview(session)
	setup_keymap(source.bufid)

	session:prompt(instruction, context)

	return session
end

function Session:open_changes()
	local source = self.source

	local function sync_win(winid)
		vim.wo[winid].scrollbind = true
		vim.wo[winid].diff = true
		vim.wo[winid].cursorbind = true
		vim.wo[winid].cursorline = true
	end

	local function setup_buffer(bufid, lines)
		vim.bo[bufid].modifiable = true
		vim.bo[bufid].filetype = vim.bo[source.bufid].filetype

		api.nvim_buf_set_lines(bufid, 0, -1, false, lines)

		vim.keymap.set('n', config.keymap.deny_changes, function()
			self:cleanup()
		end, { buf = bufid })

		vim.keymap.set('n', config.keymap.accept_changes, function()
			local start_line, end_line = self:change_range()
			api.nvim_buf_set_lines(source.bufid, start_line, end_line, true, self.state:lines())
			self:cleanup()
		end, { buf = bufid })

		vim.keymap.set('n', config.keymap.continue, function()
			input('Next Instruction:', function(instruction, context)
				if instruction == nil or #instruction == 0 then
					return
				end

				api.nvim_win_close(0, true)
				self:prompt(instruction, context)
			end)
		end, { buf = bufid })
	end

	if self.scratch == nil then
		self.scratch = {
			source = api.nvim_create_buf(false, true),
			changed = api.nvim_create_buf(false, true)
		}
	end

	---@type brandon.SessionScratches
	local scratch = self.scratch

	local source_lines = api.nvim_buf_get_lines(source.bufid, 0, -1, true)
	setup_buffer(scratch.source, source_lines)
	setup_buffer(scratch.changed, source_lines)

	local start_line, end_line = self:change_range()
	api.nvim_buf_set_lines(scratch.changed, start_line, end_line, true, self.state:lines())

	vim.bo[scratch.source].modifiable = false
	vim.bo[scratch.changed].modifiable = false

	local tabid = api.nvim_open_tabpage(scratch.source, true, {})

	local source_winid = api.nvim_tabpage_get_win(tabid)
	local changed_winid = api.nvim_open_win(scratch.changed, false, {
		win = source_winid,
		split = 'right',
		style = 'minimal'
	})

	vim.wo[source_winid].number = true
	vim.wo[source_winid].relativenumber = false

	sync_win(source_winid)
	sync_win(changed_winid)

	api.nvim_win_set_cursor(source_winid, { source.start_line, 0 })

	api.nvim_create_autocmd('WinClosed', {
		pattern = { tostring(source_winid), tostring(changed_winid) },
		group = self.augroup,
		callback = function()
			api.nvim_win_close(source_winid, true)
			api.nvim_win_close(changed_winid, true)
		end
	})
end

function Session:change_range()
	if self.extmark == nil then
		return self.source.start_line, self.source.end_line + 1
	end

	local mark = api.nvim_buf_get_extmark_by_id(self.source.bufid, self.namespace, self.extmark, {
		details = true,
		hl_name = false,
	})

	local start_line = mark[1]
	local end_line = mark[3].end_row

	return start_line, end_line
end

function Session:cursor_inside()
	local start_line, end_line = self:change_range()

	local range = vim.range.extmark(0, start_line, 0, end_line, 0)
	local cursor = api.nvim_win_get_cursor(0)
	local pos = vim.pos.cursor(0, cursor)

	return vim.range.has(range, pos)
end

function Session:prompt(instruction, context)
	self.state:reset()
	table.insert(self.messages, util.user_message(instruction, context))

	vim.print(self.messages)

	local curl_cmd = {
		'curl',
		'--silent',
		'--no-buffer',
		'--request', 'POST',
		'--url', config.endpoint,
		'--header', 'Content-Type: application/json',
		'--data', '@-'
	}

	local request = util.request(self.messages)

	self.system = vim.system(curl_cmd, {
		stdin = vim.json.encode(request),
		text = true,
		---@diagnostic disable-next-line: unused-local
		stdout = function(_err, text)
			if text == nil then
				return
			end

			if self.state:handle_data(text) then
				self:dispatch_update()
			end
		end
	}, function()
		self.state:finish()
		self:dispatch_update()

		table.insert(self.messages, util.message('assistant', self.state.text))
	end)
end

---@param cb brandon.UpdateCallback
function Session:on_update(cb)
	table.insert(self.callbacks, cb)
end

function Session:dispatch_update()
	local callbacks = self.callbacks

	if #callbacks == 0 or self.cancelled then
		return
	end

	local state = self.state

	vim.schedule(function()
		for _, cb in ipairs(callbacks) do
			cb(state)
		end
	end)
end

function Session:get_state()
	return self.state
end

function Session:cleanup()
	self.cancelled = true

	if not self.system:is_closing() then
		self.system:kill('sigint')
		self.system:wait(500)
	end

	api.nvim_del_augroup_by_id(self.augroup)
	api.nvim_buf_clear_namespace(self.source.bufid, self.namespace, 0, -1)

	if self.scratch ~= nil then
		api.nvim_buf_delete(self.scratch.changed, { force = true })
		api.nvim_buf_delete(self.scratch.source, { force = true })
	end

	sessions[self.id] = nil
	maybe_cleanup_keymap(self.source.bufid)
end

return Session
