local config = require('brandon.config')
local api = vim.api


local M = {}

---@alias brandon.SessionMessageRole "system" | "user" | "assistant"

--TODO: Add proper typing for OpenAI chat content part

---@class brandon.SessionMessage
---@field role brandon.SessionMessageRole
---@field content string | any[]


---@param role brandon.SessionMessageRole
---@param content string | any[]
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
	Do not add extra code, **only respond with code to be placed inside CURSOR**.
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
		is_insert and { "<CURSOR>", "</CURSOR>" } or { "<SNIPPET>", snippet_lines, "</SNIPPET>" },
		"<SUFFIX>", suffix_lines, "</SUFFIX>",
	}

	local prompt = vim.iter(system_lines):flatten(2):join('\n')

	return M.message('system', prompt)
end

local context_to_content = {}

---@param ctx brandon.FileContext
function context_to_content.file(ctx)
	local uv = vim.uv

	---@diagnostic disable: redefined-local
	local fd, err = uv.fs_open(ctx.file_path, 'r', tonumber('644', 8))
	assert(not err, err)

	---@cast fd integer
	local stat, err = uv.fs_fstat(fd)
	assert(not err, err)

	---@cast stat uv.fs_stat.result
	local content, err = uv.fs_read(fd, stat.size)
	assert(not err, err)

	local success, err = uv.fs_close(fd)
	assert(success, err)

	return {
		type = 'text',
		text = '--- file: ' .. ctx.name .. ' ---\n' .. content
	}
end

---Make user instruction message
---@param instruction string
---@param context brandon.Context[]
function M.user_message(instruction, context)
	local instruction_lines = { "<INSTRUCTION>", instruction, "</INSTRUCTION>" }

	local parts = {
		{ type = 'text', text = vim.iter(instruction_lines):join('\n') }
	}

	for _, ctx in ipairs(context) do
		local success, content = pcall(context_to_content[ctx.type], ctx)
		if success then
			table.insert(parts, content)
		else
			vim.notify('Failed to digest context: ' .. content, vim.log.levels.ERROR)
		end
	end

	return M.message('user', parts)
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
