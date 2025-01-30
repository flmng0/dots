local CTRL_V = vim.api.nvim_replace_termcodes('<C-V>', true, true, true)
local CTRL_S = vim.api.nvim_replace_termcodes('<C-S>', true, true, true)

local function hl(name)
	return '%#' .. name .. '#'
end

local dap = require('dap')

local function has_dap_config(bufnr)
	local all_configs = {}
	local providers = dap.providers
	local provider_keys = vim.tbl_keys(providers.configs)
	table.sort(provider_keys)

	for _, provider in ipairs(provider_keys) do
		local config_provider = providers.configs[provider]
		local configs = config_provider(bufnr)

		vim.list_extend(all_configs, configs)
	end

	return #all_configs > 0
end

for _, event in ipairs({
	'initialized',
	'terminated',
	'stopped',
}) do
	dap.listeners.after['event_' .. event]['tmthy.statusline'] = function(_session, _body)
		vim.cmd([[:redrawstatus]])
	end
end

local lazy_dap = require('tmthy.util').lazy_wrapper('dap')
_G.TmthyDapNew = function()
	vim.cmd([[:DapNew]])
end
-- _G.TmthyDapNew = lazy_dap('continue', { new = true })
_G.TmthyDapContinue = lazy_dap('continue')
_G.TmthyDapPause = lazy_dap('pause')
_G.TmthyDapStop = lazy_dap('terminate')

_G.TmthyDapStepInto = lazy_dap('step_into')
_G.TmthyDapStepOver = lazy_dap('step_over')
_G.TmthyDapStepOut = lazy_dap('step_out')
_G.TmthyDapRestart = lazy_dap('restart')

function _G.TmthyStatusLine()
	---@param padding? number
	local function component(inner, hlname, padding)
		local padding_text = string.rep(' ', padding or 0)

		return table.concat({
			hl(hlname),
			padding_text,
			inner,
			padding_text,
		})
	end

	local function mode()
		local mode_map = {
			['n'] = { text = 'Normal', hl = 'StatusLineModeNormal' },
			['v'] = { text = 'Visual', hl = 'StatusLineModeVisual' },
			['V'] = { text = 'V-Line', hl = 'StatusLineModeVisual' },
			[CTRL_V] = { text = 'V-Block', hl = 'StatusLineModeVisual' },
			['s'] = { text = 'Select', hl = 'StatusLineModeSelect' },
			['S'] = { text = 'S-Line', hl = 'StatusLineModeSelect' },
			[CTRL_S] = { text = 'S-Block', hl = 'StatusLineModeSelect' },
			['i'] = { text = 'Insert', hl = 'StatusLineModeInsert' },
			['R'] = { text = 'Replace', hl = 'StatusLineModeReplace' },
			['c'] = { text = 'Command', hl = 'StatusLineModeCommand' },
			['r'] = { text = 'Prompt', hl = 'StatusLineModeOther' },
			['!'] = { text = 'Shell', hl = 'StatusLineModeOther' },
			['t'] = { text = 'Terminal', hl = 'StatusLineModeOther' },
		}
		local default = { text = 'Unknown', hl = 'StatusLineModeOther' }

		local mode_info = mode_map[vim.fn.mode()] or default

		return component(mode_info.text, mode_info.hl, 1)
	end

	local function branch()
		local data = vim.b.minigit_summary --[[@as { head_name?: string } | nil]]
		if data == nil or data.head_name == nil then
			return ''
		end

		local head_name = data.head_name:gsub('^feature/(%a+%-%d+).*', 'f/%1')

		local text = ' ' .. head_name
		return component(text, 'StatusLineGitBranch', 2)
	end

	local function diff()
		local summary = vim.b.minidiff_summary --[[@as { add: number, change: number, delete: number } | nil]]
		if summary == nil then
			return ''
		end

		local status = vim.b.minigit_summary.status
		if status == '??' then
			return component('', 'StatusLineGitUnstaged', 1)
		end

		if not (summary.add or summary.change or summary.delete) then
			return ''
		end

		local nums = {
			{ key = 'add', icon = '', hl = 'StatusLineGitAdd' },
			{ key = 'change', icon = '', hl = 'StatusLineGitChange' },
			{ key = 'delete', icon = '', hl = 'StatusLineGitDelete' },
		}

		local data = {}

		for _, v in ipairs(nums) do
			if summary[v.key] > 0 then
				local comp = component(v.icon .. ' ' .. (tostring(summary[v.key])), v.hl)
				table.insert(data, comp)
			end
		end

		if #data == 0 then
			return ''
		end

		local text = table.concat(data, ' ')

		return component(text, 'StatusLineGitBranch', 1)
	end

	local function dap_controls()
		local session = dap.session()

		if session == nil then
			local bufnr = vim.api.nvim_get_current_buf()
			if has_dap_config(bufnr) then
				return component('%@v:lua.TmthyDapNew@󰐊 Start%X', 'StatusLineGitBranch', 1)
			else
				return ''
			end
		end

		local running = session.stopped_thread_id == nil

		local pause = { symbol = '󰏤', callback = 'TmthyDapPause' }
		local play = { symbol = '󰐊', callback = 'TmthyDapContinue' }

		-- TODO: Add highlight and callback to table
		local dap_map = {
			running and pause or play,

			{ symbol = '󰓛', callback = 'TmthyDapStop' },
			{ symbol = '󰜉', callback = 'TmthyDapRestart' },

			{ symbol = '󰆹', callback = 'TmthyDapStepInto' },
			{ symbol = '󰆸', callback = 'TmthyDapStepOut' },
			{ symbol = '󰆷', callback = 'TmthyDapStepOver' },
		}

		local text = vim.tbl_map(function(opts)
			return '%@v:lua.' .. opts.callback .. '@' .. opts.symbol .. '%X'
		end, dap_map)

		return component(table.concat(text, ' '), 'StatusLineGitBranch', 1)
	end

	local function lsp_status()
		local bufnr = vim.api.nvim_get_current_buf()

		local clients = vim.lsp.get_clients({ bufnr = bufnr })

		if clients == nil or #clients == 0 then
			return ''
		end

		local names = vim.iter(clients)
			:map(function(client)
				return client.name
			end)
			:totable()

		local icon = '󰈸'
		local names_text = table.concat(names, ', ')

		local text = table.concat({
			component(icon, 'StatusLineLspIcon'),
			component(names_text, 'StatusLineLspNames'),
		}, ' ')

		return component(text, 'StatusLineLspNames', 1)
	end

	local function concat_components(components)
		local filtered = vim.iter(ipairs(components))
			:filter(function(_, comp)
				return comp ~= nil and comp ~= ''
			end)
			:map(function(i, comp)
				local is_last = i == #components
				local is_special = #comp == 2 and string.sub(comp, 1, 1) == '%'

				if is_last or is_special then
					return comp
				end

				return comp .. '%#StatusLine# '
			end)
			:totable()

		return table.concat(filtered)
	end

	return concat_components({
		mode(),
		'%<',
		branch(),
		component('%f', 'StatusLine'),
		diff(),
		'%=',
		dap_controls(),
		lsp_status(),
		component('%l:%c', 'StatusLine'),
	})
end

vim.o.statusline = ' %{%v:lua.TmthyStatusLine()%} '
