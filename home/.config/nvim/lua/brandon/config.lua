local config = {
	prefix_line_count = 32,
	suffix_line_count = 32,
	endpoint = 'http://localhost:2276/v1/chat/completions',
	model = vim.env.LLAMA_INST_MODEL,
	preview = {
		header_hl = "DiffChange",
		snippet_hl = "DiffText"
	},
	keymap = {
		cancel = '<C-c>',
		view_changes = '<C-g>',
		accept_changes = '<localleader>a',
		deny_changes = '<localleader>q',
		continue = '<localleader>c',
	}
}

local M = {}

setmetatable(M, { __index = config })

function M.get()
	return config
end

function M.update(new_config)
	config = vim.tbl_deep_extend('force', config, new_config)
end

return M
