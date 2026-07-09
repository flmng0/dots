local api = vim.api

function clamp(x, min, max)
	return math.max(min, math.min(x, max))
end


local even_line = ""
local odd_line = ""

for i = 1, vim.o.columns do
	local even = i % 2 == 0
	even_line = even_line .. (even and "╱" or " ")
	odd_line = odd_line .. (even and " " or "╱")
end

function diff_buffers(a_bufid, b_bufid)
	local ns = api.nvim_create_namespace("tmthy.diff")
	api.nvim_buf_clear_namespace(a_bufid, ns, 0, -1)
	api.nvim_buf_clear_namespace(b_bufid, ns, 0, -1)

	local a_lines = api.nvim_buf_get_lines(a_bufid, 0, -1, false)
	local b_lines = api.nvim_buf_get_lines(b_bufid, 0, -1, false)

	local a_text = vim.iter(a_lines):join('\n')
	local b_text = vim.iter(b_lines):join('\n')

	vim.text.diff(a_text, b_text, {
		linematch = true,
		ignore_whitespace = true,
		on_hunk = function(start_a, count_a, start_b, count_b) 
			local line_a = start_a - 1
			local line_b = start_b - 1

			local changes = math.min(count_a, count_b)

			if changes > 0 then
				api.nvim_buf_set_extmark(a_bufid, ns, line_a, 0, {
					end_row = line_a + changes,
					hl_group = {'DiffText'},
					hl_eol = true
				})
				api.nvim_buf_set_extmark(b_bufid, ns, line_b, 0, {
					end_row = line_b + changes,
					hl_group = {'DiffText'},
					hl_eol = true
				})
			end

			local diff = count_b - count_a
			local changes_offset = math.max(0, changes - 1)

			local virt_lines = {}
			for i = 1, math.abs(diff) do
				local even = i % 2 == 0
				local line_text = even and even_line or odd_line
				local line = { { line_text, {"DiffChange", "Comment"} } }
				table.insert(virt_lines, i, line)
			end

			if diff > 0 then
				api.nvim_buf_set_extmark(b_bufid, ns, line_b + changes, 0, {
					end_row = line_b + changes + diff,
					hl_group = 'DiffAdd',
					hl_eol = true,
				})

				local buflines = #a_lines
				local line = clamp(line_a + changes_offset, 0, buflines)

				api.nvim_buf_set_extmark(a_bufid, ns, line, 0, {
					virt_lines = virt_lines
				})
			end

			if diff < 0 then
				api.nvim_buf_set_extmark(a_bufid, ns, line_a + changes, 0, {
					end_row = line_a + changes - diff,
					hl_group = 'DiffDelete',
					hl_eol = true,
				})

				local buflines = #b_lines
				local line = clamp(line_b + changes_offset, 0, buflines)

				api.nvim_buf_set_extmark(b_bufid, ns, line, 0, {
					virt_lines = virt_lines
				})
			end
		end
	})
end

return diff_buffers
