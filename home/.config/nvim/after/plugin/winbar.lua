local align = 'center'

local function highlight_group(name, current)
	return ('%%#%s%s#'):format(name, current and '' or 'NC')
end

function _G.TmthyWinbar()
	local filename = vim.fn.expand('%:t')

	local modified_icon = vim.bo.modified and ' ⏺' or ''
	-- Because unicode
	local modified_len = 0
	if modified_icon ~= '' then
		modified_len = 2
	end

	local prefix = ''
	local suffix = ''

	local component_width = #filename + modified_len + 4

	local width = vim.api.nvim_win_get_width(0)

	local paddingn

	if align == 'right' then
		paddingn = width - component_width
	elseif align == 'center' then
		paddingn = (width - component_width) / 2
	end
	local padding = string.rep(' ', paddingn)

	local current = tostring(vim.api.nvim_get_current_win()) == vim.g.actual_curwin

	return table.concat({
		padding,
		highlight_group('WinBarEnd', current),
		prefix,
		highlight_group('WinBarMain', current),
		' ',
		filename .. modified_icon,
		' ',
		highlight_group('WinBarEnd', current),
		suffix,
		highlight_group('WinBar', current),
	})
end

local augroup = vim.api.nvim_create_augroup('tmthy.winbar', { clear = true })

vim.api.nvim_create_autocmd('BufWinEnter', {
	group = augroup,
	desc = 'Setup winbar',
	callback = function(args)
		local is_floating = vim.api.nvim_win_get_config(0).zindex
		local is_normal_buf = vim.bo[args.buf].buftype == ''
		local has_file_name = vim.api.nvim_buf_get_name(args.buf) ~= ''
		local is_diff = vim.wo[0].diff

		local enabled = not is_floating and is_normal_buf and has_file_name and not is_diff

		if enabled then
			vim.wo[0].winbar = '%{%v:lua.TmthyWinbar()%}'
		end
	end,
})
