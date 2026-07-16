local config = require('brandon.config')
local Session = require('brandon.session')
local util = require('brandon.util')
local api = vim.api

local M = {}

function M.setup(opts)
	config.update(opts)
end

---@param instruction string | nil
---@param source brandon.SessionSource
local function do_instruct(instruction, source)
	if instruction ~= nil and #instruction > 0 then
		Session:start(source, instruction)
	else
		util.input('Instruction:', function(inst)
			if inst == nil or #inst == 0 then
				return
			end

			Session:start(source, inst)
		end)
	end
end

function M.instruct_insert(instruction)
	local bufid = api.nvim_get_current_buf()
	local cursor = api.nvim_win_get_cursor(0)

	local line = cursor[1]
	local source = {
		bufid = bufid,
		start_line = line - 1,
	}

	do_instruct(instruction, source)
end

function M.instruct_range(instruction)
	local bufid = api.nvim_get_current_buf()
	local region = vim.fn.getregionpos(vim.fn.getpos('v'), vim.fn.getpos('.'), {
		type = 'v',
		exclusive = false,
		eol = false,
	})
	local line1 = region[1][1][2]
	local line2 = region[#region][1][2]

	local source = {
		bufid = bufid,
		start_line = line1 - 1,
		end_line = line2 - 1
	}

	do_instruct(instruction, source)
end

function M.clean_buf(bufid)
	if bufid == nil then
		bufid = api.nvim_get_current_buf()
	end

	local to_clean = Session.iter():filter(function(s)
		vim.print(s.source.bufid)
		return s.source.bufid == bufid
	end)

	for session in to_clean do
		session:cleanup()
	end
end

function M.get_session_by_id(id)
	return Session.get_by_id(id)
end

function M.clean_all()
	for session in Session.iter() do
		session:cleanup()
	end
end

return M
