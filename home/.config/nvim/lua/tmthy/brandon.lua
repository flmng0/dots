local config = {
	prefix_line_count = 32,
	suffix_line_count = 32,
	endpoint = 'http://localhost:2276/v1/chat/completions',
	model = vim.env.LLAMA_INST_MODEL,
	preview = {
		header_hl = "DiffChange",
		snippet_hl = "DiffText"
	},
	keymap = {
		cancel = '<C-c>',
		view_changes = '<C-g>',
		accept_changes = '<localleader>a',
		deny_changes = '<localleader>q',
		continue = '<localleader>c',
	}
}

---@type { integer: Session }
local sessions = {}
local session_id = 0

local api = vim.api

---@class SessionSource
---@field bufid integer
---@field start_line integer
---@field end_line integer

---@class SessionScratches
---@field source integer
---@field changed integer

---@alias UpdateCallback fun(state: SessionState)

---@alias SessionMessageRole "system" | "user" | "assistant"

---@class SessionMessage
---@field role SessionMessageRole
---@field content string

---@alias SessionStage
---| 'pending' Not yet started
---| 'thinking' Still in reasoning phase
---| 'generating' Actively generating code
---| 'finished' Finished

---@class SessionState
---@field done boolean Generation complete?
---@field stage SessionStage Stage of generation
---@field reasoning string Reasoning generated so far
---@field text string Text generated so far
local SessionState = {}

function SessionState:init()
	local res = {
		done = false,
		stage = "pending",
		text = '',
		reasoning = '',
	}
	setmetatable(res, { __index = self })
	return res
end

function SessionState:reset()
	self.done = false
	self.stage = 'pending'
	self.text = ''
	self.reasoning = ''
end

function SessionState:lines()
	return vim.split(self.text, '\n')
end

local function parse_event(event)
	if not vim.startswith(event, 'data: ') then
		return
	end

	local body = string.sub(event, #'data: ' + 1)
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

	return {
		reasoning = reasoning,
		content = content,
	}
end

function SessionState:handle_data(text)
	local updated = false

	for event in vim.gsplit(text, '\n\n') do
		local delta = parse_event(event)

		if delta == nil then
			goto continue
		end

		if delta.reasoning ~= nil then
			if self.stage ~= 'generating' then
				self.stage = 'thinking'
			end
			self.reasoning = self.reasoning .. delta.reasoning
		end
		if delta.content ~= nil then
			self.stage = 'generating'
			self.text = self.text .. delta.content
		end

		updated = true

		::continue::
	end

	return updated
end

function SessionState:finish()
	self.done = true
	self.stage = "finished"
end

---@param role SessionMessageRole
---@param content string
local function message(role, content)
	---@type SessionMessage
	return { role = role, content = content }
end


---Make system prompt message
---@param source SessionSource
local function system_message(source)
	local prefix_lines = api.nvim_buf_get_lines(
		source.bufid,
		source.start_line - 1 - config.prefix_line_count,
		source.start_line - 1,
		false
	)
	local snippet_lines = api.nvim_buf_get_lines(
		source.bufid,
		source.start_line,
		source.end_line + 1,
		false
	)
	local suffix_lines = api.nvim_buf_get_lines(
		source.bufid,
		source.end_line + 1,
		source.end_line + 1 + config.prefix_line_count,
		false
	)

	local system_lines = {
		[[You are a coding assistant. Apply INSTRUCTION to SNIPPET. Do not add extra code. Respond with code modifications as raw text, NOT IN A CODE BLOCK. Consider the local context before (PREFIX) and after (SUFFIX) the SNIPPET.]],
		"<PREFIX>", prefix_lines, "</PREFIX>",
		"<SUFFIX>", suffix_lines, "</SUFFIX>",
		"<SNIPPET>", snippet_lines, "</SNIPPET>",
	}

	return message('system', vim.iter(system_lines):flatten():join('\n'))
end

---Make user instruction message
---@param instruction string
local function user_message(instruction)
	local user_lines = { "<INSTRUCTION>", instruction, "</INSTRUCTION>" }

	return message('user', vim.iter(user_lines):join('\n'))
end

local function request(messages)
	return {
		messages = messages,
		model = config.model,
		min_p = 0.1,
		temperature = 0.95,
		samplers = { 'min_p', 'temperature' },
		stream = true,
		cache_prompt = true,
	}
end


---@param session Session
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

		session.extmark = api.nvim_buf_set_extmark(source.bufid, ns, source.start_line, 0, {
			id = session.extmark,
			invalidate = true,
			undo_restore = false,
			hl_group = config.preview.snippet_hl,
			hl_eol = config.preview.snippet_hl ~= nil,
			end_row = source.end_line + 1,
			virt_lines = virt_lines,
			virt_lines_above = true,
		})
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

---@param session Session
local function init_finalizer(session)
	local ns = session.namespace
	local source = session.source

	local has_setup = false

	---@type integer | nil
	local tabid = nil

	local function sync_win(winid)
		vim.wo[winid].scrollbind = true
		vim.wo[winid].diff = true
		vim.wo[winid].cursorbind = true
		vim.wo[winid].cursorline = true
	end

	local function change_range()
		local mark = api.nvim_buf_get_extmark_by_id(source.bufid, ns, session.extmark, {
			details = true,
			hl_name = false,
		})

		local start_line = mark[1]
		local end_line = mark[3].end_row

		return start_line, end_line
	end

	---@param bufid buffer
	---@param lines {string} list of lines to set in the buffer
	local function setup_buffer(bufid, lines)
		vim.bo[bufid].modifiable = true
		vim.bo[bufid].filetype = vim.bo[source.bufid].filetype

		api.nvim_buf_set_lines(bufid, 0, -1, false, lines)

		vim.keymap.set('n', config.keymap.deny_changes, function()
			session:cleanup()
		end, { buf = bufid })

		vim.keymap.set('n', config.keymap.accept_changes, function()
			local start_line, end_line = change_range()
			api.nvim_buf_set_lines(source.bufid, start_line, end_line, true, session.state:lines())
			session:cleanup()
		end, { buf = bufid })

		vim.keymap.set('n', config.keymap.continue, function()
			local instruction = vim.fn.input("Next Instruction: ")

			if instruction == nil or #instruction == 0 then
				return
			end

			api.nvim_win_close(0, true)
			session:prompt(instruction)
		end, { buf = bufid })
	end

	local function open_changes()
		if tabid ~= nil then
			return
		end

		if session.scratch == nil then
			session.scratch = {
				source = api.nvim_create_buf(false, true),
				changed = api.nvim_create_buf(false, true)
			}
		end

		---@type SessionScratches
		local scratch = session.scratch

		local source_lines = api.nvim_buf_get_lines(source.bufid, 0, -1, true)
		setup_buffer(scratch.source, source_lines)
		setup_buffer(scratch.changed, source_lines)

		local start_line, end_line = change_range()
		api.nvim_buf_set_lines(scratch.changed, start_line, end_line, true, session.state:lines())

		vim.bo[scratch.source].modifiable = false
		vim.bo[scratch.changed].modifiable = false

		tabid = api.nvim_open_tabpage(scratch.source, true, {})

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
			group = session.augroup,
			callback = function()
				api.nvim_win_close(source_winid, true)
				api.nvim_win_close(changed_winid, true)
				tabid = nil
			end
		})
	end

	local function inside_range()
		local start_line, end_line = change_range()

		local range = vim.range.extmark(0, start_line, 0, end_line, 0)
		local cursor = api.nvim_win_get_cursor(0)
		local pos = vim.pos.cursor(0, cursor)

		return vim.range.has(range, pos)
	end

	session:on_update(function(state)
		if not state.done or has_setup then
			return
		end

		vim.keymap.set('n', config.keymap.cancel, function()
			if not inside_range() then
				vim.print("Not in a changed block")
				return
			end

			session:cleanup()
		end)

		vim.keymap.set('n', config.keymap.view_changes, function()
			if not inside_range() then
				vim.print("Not in a changed block")
				return
			end

			if not state.done then
				vim.print("Be patient! Generation is not finished yet.")
				return
			end

			open_changes()
		end, { buf = source.bufid })

		has_setup = true
	end)
end

---@class Session
---@field id integer
---@field system vim.SystemObj | nil vim.system object
---@field scratch SessionScratches | nil Scratch buffer IDs
---@field source SessionSource Source code information (range)
---@field state SessionState State of generation
---@field callbacks UpdateCallback[] Callbacks to invoke on update
---@field namespace integer Namespace ID
---@field extmark integer | nil Extmark ID
---@field augroup integer Autocommand group
---@field messages SessionMessage[] Messages so far
local Session = {}


---Start a new session, given
---@param source SessionSource Range of source code to affect
---@param instruction string Initial instruction
---@return Session
function Session:start(source, instruction)
	local this_id = session_id
	session_id = session_id + 1

	---@type Session
	local session = {
		id = this_id,
		state = SessionState:init(),
		messages = {
			system_message(source),
		},
		system = nil,
		namespace = api.nvim_create_namespace(''),
		augroup = api.nvim_create_augroup('brandon.session.' .. this_id, { clear = true }),
		source = source,
		scratch = nil,
		extmark = nil,
		callbacks = {},
	}
	table.insert(sessions, this_id, session)
	setmetatable(session, { __index = self })

	init_preview(session)
	init_finalizer(session)

	session:prompt(instruction)

	return session
end

function Session:prompt(instruction)
	self.state:reset()
	table.insert(self.messages, user_message(instruction))

	local curl_cmd = {
		'curl',
		'--silent',
		'--no-buffer',
		'--request', 'POST',
		'--url', config.endpoint,
		'--header', 'Content-Type: application/json',
		'--data', '@-'
	}

	self.system = vim.system(curl_cmd, {
		stdin = vim.json.encode(request(self.messages)),
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

		table.insert(self.messages, message('assistant', self.state.text))
	end)
end

---@param cb UpdateCallback
function Session:on_update(cb)
	table.insert(self.callbacks, cb)
end

function Session:dispatch_update()
	local callbacks = self.callbacks

	if #callbacks == 0 then
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
	table.remove(sessions, self.id)

	api.nvim_del_augroup_by_id(self.augroup)
	api.nvim_buf_clear_namespace(self.source.bufid, self.namespace, 0, -1)

	if self.scratch ~= nil then
		api.nvim_buf_delete(self.scratch.changed, { force = true })
		api.nvim_buf_delete(self.scratch.source, { force = true })
	end
end

function Session:cancel()
	self.system:kill('sigint')
	self:cleanup()
end

local M = {}

function M.setup(opts)
	config = vim.tbl_deep_extend('force', config, opts or {})
end

function M.instruct_range(instruction)
	local region = vim.fn.getregionpos(vim.fn.getpos('v'), vim.fn.getpos('.'), {
		type = 'v',
		exclusive = false,
		eol = false,
	})
	local line1 = region[1][1][2]
	local line2 = region[#region][1][2]

	local bufid = api.nvim_get_current_buf()

	instruction = instruction or vim.fn.input("Instruction: ")

	local session = Session:start({
		bufid = bufid,
		start_line = line1 - 1,
		end_line = line2 - 1
	}, instruction)

	api.nvim_input('<Esc>')

	return session
end

function M.clean_buf(bufid)
	if bufid == nil then
		bufid = api.nvim_get_current_buf()
	end

	local to_clean = vim.iter(sessions):filter(function(s)
		vim.print(s.source.bufid)
		return s.source.bufid == bufid
	end)

	for session in to_clean do
		session:cleanup()
	end
end

function M.get_session_by_id(id)
	return sessions[id]
end

function M.clean_all()
	for session in vim.iter(sessions) do
		session:cleanup()
	end
end

return M
