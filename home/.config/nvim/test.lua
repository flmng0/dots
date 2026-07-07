local api = vim.api

local replacement = [[test
test
this could be anything
there should probably be more lines
with

varying spacing
and indentation
{}]]

api.nvim_create_user_command("DoThing", function(opts)
  local bufid = api.nvim_create_buf(false, true)

  local curr_text = api.nvim_buf_get_lines(0, 0, -1, true)
  api.nvim_buf_set_lines(bufid, 0, 0, false, curr_text)

  local curr_ft = api.nvim_get_option_value("filetype", { buf = 0 })
  vim.bo[bufid].filetype = vim.bo.filetype

  local width = api.nvim_win_get_width(0)

  local winid = api.nvim_open_win(bufid, false, { 
	  relative = 'cursor', 
	  anchor = 'NW',
	  col = 0,
	  row = 1,
	  width = width,
	  height = 20 ,
	  style = 'minimal',
	  footer = 'test'
	  -- header = '▔'
  })

  api.nvim_create_autocmd('BufLeave', {
    callback = function()
      api.nvim_buf_delete(bufid, {})

    end,
    buf = bufid
  })
end, {range = true})

api.nvim_create_user_command("ClearThing", function() 
  local ns = api.nvim_create_namespace("tim-test")
  api.nvim_buf_clear_namespace(0, ns, 0, -1)
end, {})
-- api.nvim_create_user_command('DoThing', do_thing, { range = true })

function do_thing(opts)
	local line1 = opts.line1
	local line2 = opts.line2

	local row_start = line1 - 1
	local row_end = line2
	local row_span = row_end - row_start

	local ns = api.nvim_create_namespace("tim-test")

	api.nvim_buf_clear_namespace(0, ns, 0, -1)

	local indent = vim.fn.indent(line1)
  -- TODO: Handle expand tab
	local indented = vim.text.indent(indent, replacement)

	local source_lines = api.nvim_buf_get_lines(0, row_start, row_end, false)
	local replacement_lines = vim.split(indented, "\n")

	local count = #replacement_lines

	local it = vim.iter(ipairs(replacement_lines))

	for i, repline in it do
	  local line = source_lines[i]

	  if #repline < #line then
		local unindented_line, indent = vim.text.indent(0, line)

		local indented_line = vim.text.indent(indent, unindented_line, {expandtab = vim.bo.expandtab and vim.bo.tabstop or nil})
		local conceal_text = string.rep(" ", #indented_line)

		api.nvim_buf_set_extmark(0, ns, row_start + i - 1, 0, {
		  end_col = -1, strict = false,
		  virt_text = {
			{conceal_text, "Normal"}
		  },
		  virt_text_pos = "overlay",
		  hl_mode = "blend"
		})
	  end

	  api.nvim_buf_set_extmark(0, ns, row_start + i - 1, 0, {
		virt_text = {
		  {repline, "DiffText"},
		},
		virt_text_pos = "overlay"
	  })

	  if i > row_span - 1 then
		break
	  end
	end

	if it:peek() then
		local last_index, _ = it:peek()
		local virt_lines = it:map(function(i, repline)
			return { { repline, "DiffAdd" } }
		end):totable()

		api.nvim_buf_set_extmark(0, ns, row_start + last_index - 2, 0, {
			virt_lines = virt_lines,
		})
	end

end
