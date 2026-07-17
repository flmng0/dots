---@class brandon.SessionState
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
	if vim.startswith(self.text, '```') then
		local lines = vim.split(self.text, '\n', { plain = true })
		table.remove(lines, 1)
		table.remove(lines, #lines)
		self.text = vim.iter(lines):join('\n')
	end
	self.done = true
	self.stage = "finished"
end

return SessionState
