local api = vim.api
local Session = require('brandon.session')

local move = {}

local function make_move(dir)
	return function()
		local winid = api.nvim_get_current_win()
		local bufid = api.nvim_win_get_buf(winid)

		local cursor = api.nvim_win_get_cursor(winid)
		local pos = vim.pos.cursor(bufid, cursor)

		local session_line = Session.iter():fold(-1, function(acc, session)
			---@cast session Session

			if session.source.bufid ~= bufid then
				return acc
			end

			local start_line, end_line = session:change_range()
			start_line = start_line + 1

			if dir == 1 and start_line > pos.row then
				return math.min(acc == -1 and math.huge or acc, start_line)
			elseif dir == -1 and end_line < pos.row then
				return math.max(acc == -1 and -math.huge or acc, end_line)
			else
				return acc
			end
		end)

		if session_line == -1 then
			vim.notify("No more Brandon sessions to move to", vim.log.levels.WARN)
			return
		end

		api.nvim_win_set_cursor(winid, { session_line, 0 })
	end
end

move.to_next_session = make_move(1)
move.to_prev_session = make_move(-1)

return move
