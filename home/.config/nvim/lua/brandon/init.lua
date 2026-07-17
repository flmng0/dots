local config = require('brandon.config')
local Session = require('brandon.session')
local input = require('brandon.input')
local api = vim.api

local M = {}

function M.setup(opts)
	config.update(opts)

	api.nvim_create_user_command('Brandon', function(args)
		local source = {
			bufid = api.nvim_get_current_buf(),
			start_line = args.line1 - 1
		}
		if args.count ~= -1 then
			source.end_line = args.line2 - 1
		end

		if #args.args > 0 then
			Session:start(source, args.args)
		else
			input('Instruction:', function(instruction)
				if instruction == nil or #instruction == 0 then
					return
				end
				Session:start(source, instruction)
			end)
		end
	end, { range = true, nargs = '?' })
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
