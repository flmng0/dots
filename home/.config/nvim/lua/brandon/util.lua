local config = require('brandon.config')
local api = vim.api


local M = {}

---@alias brandon.SessionMessageRole "system" | "user" | "assistant"

---@class brandon.SessionMessage
---@field role brandon.SessionMessageRole
---@field content string


---@param role brandon.SessionMessageRole
---@param content string
---@return brandon.SessionMessage
function M.message(role, content)
	return { role = role, content = content }
end

local function normalize(prompt)
	local lines = vim.split(prompt, '\n', { plain = true, trimempty = true })

	return vim.iter(lines):map(function(line)
		return vim.trim(line)
	end):join(' ')
end

local range_prompt = normalize([[
	You are a coding assistant. Apply INSTRUCTION to SNIPPET.
	Do not add extra code, **only respond with the modifications to the code within SNIPPET**.
	Respond with code modifications as raw text, NOT IN A CODE BLOCK.
	Consider the local context before (PREFIX) and after (SUFFIX) the SNIPPET.
]])

local insert_prompt = normalize([[
	You are a coding assistant. Generate new code which satisfies INSTRUCTION.
	Do not add extra code.
	Respond with code modifications as raw text, NOT IN A CODE BLOCK.
	Consider the local context provided in the PREFIX and SUFFIX.
]])

---Make system prompt message
---@param source brandon.SessionSource
function M.system_message(source)
	local is_insert = source.end_line == nil

	local end_line = is_insert and source.start_line or source.end_line

	local prefix_lines = api.nvim_buf_get_lines(
		source.bufid,
		source.start_line - 1 - config.prefix_line_count,
		source.start_line - 1,
		false
	)

	local snippet_lines = is_insert and nil or api.nvim_buf_get_lines(
		source.bufid,
		source.start_line,
		end_line + 1,
		false
	)

	local suffix_lines = api.nvim_buf_get_lines(
		source.bufid,
		end_line + 1,
		end_line + 1 + config.prefix_line_count,
		false
	)

	local system_lines = {
		is_insert and insert_prompt or range_prompt,
		"<PREFIX>", prefix_lines, "</PREFIX>",
		"<SUFFIX>", suffix_lines, "</SUFFIX>",
		is_insert and {} or { "<SNIPPET>", snippet_lines, "</SNIPPET>" },
	}

	local prompt = vim.iter(system_lines):flatten(2):join('\n')

	return M.message('system', prompt)
end

---Make user instruction message
---@param instruction string
function M.user_message(instruction)
	local user_lines = { "<INSTRUCTION>", instruction, "</INSTRUCTION>" }

	return M.message('user', vim.iter(user_lines):join('\n'))
end

function M.request(messages)
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

---@param prompt string
---@param cb fun(input: string | nil)
function M.input(prompt, cb)
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

	api.nvim_open_win(bufid, true, {
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


	local function cleanup()
		api.nvim_del_augroup_by_name('brandon.util.input')
		api.nvim_buf_delete(bufid, { force = true })

		if api.nvim_get_mode().mode == 'i' then
			api.nvim_input('<Esc>')
		end
	end

	local function cancel()
		cleanup()
		cb(nil)
	end

	api.nvim_create_autocmd('WinClosed', {
		buf = bufid,
		group = augroup,
		callback = cancel,
	})
	vim.keymap.set({ 'n', 'i' }, '<C-c>', cancel, { buf = bufid })
	vim.keymap.set({ 'n' }, '<Esc>', cancel, { buf = bufid })

	vim.keymap.set({ 'n', 'i' }, '<C-d>', function()
		local lines = api.nvim_buf_get_lines(bufid, 0, -1, false)
		local text = vim.iter(lines):join('\n')
		cleanup()
		cb(text)
	end, { buf = bufid })
end

---@param buf integer Buffer ID
---@param ns_id integer Namespace ID
---@param id integer Extmark ID
---@param opts vim.api.keyset.set_extmark Updates
---@return boolean exists Whether the extmark still extists
function M.update_extmark(buf, ns_id, id, opts)
	local mark = api.nvim_buf_get_extmark_by_id(buf, ns_id, id, { details = true })
	if #mark == 0 then
		return false
	end

	local row, col, details = unpack(mark)

	details.ns_id = nil
	details.invalid = nil

	local new_details = vim.tbl_deep_extend('force', {}, details, opts, { id = id })
	api.nvim_buf_set_extmark(buf, ns_id, row, col, new_details)
	return true
end

return M
