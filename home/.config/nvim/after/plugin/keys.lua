local wk = require('which-key')
local util = require('tmthy.util')

-- at the top in case I want to use it many places
local augroup = vim.api.nvim_create_augroup('tmthy.keys', { clear = true })

-- Standard mappings
wk.add({
	hidden = true,
	{ '<Esc>', '<Cmd>nohl<CR>', desc = 'Clear highlight' },
	{ ']b', '<Cmd>bnext<CR>', desc = 'Swap to next buffer' },
	{ '[b', '<Cmd>bprevious<CR>', desc = 'Swap to previous buffer' },
	{ 'U', '<C-r>', desc = 'Redo' },
})

-- register groups
wk.add({
	{ '<leader>f', group = 'Finders' },
	{ '<leader>c', group = 'Code Actions' },
	{ '<leader>d', group = 'Debugging' },
})

-- Telescope non-LSP mappings
local builtin = util.lazy_wrapper('telescope.builtin')

wk.add({
	{ '<leader><space>', builtin('find_files'), desc = 'Fuzzy find files' },
	{ '<leader>fh', builtin('help_tags'), desc = 'Search help' },
	{ '<leader>fk', builtin('keymaps'), desc = 'Search for keymaps' },
	{ '<leader>fb', builtin('buffers'), desc = 'Search open buffers' },
	{ '<leader>/', builtin('live_grep'), desc = 'Live grep' },
})

-- Oil mappings
local oil = util.lazy_wrapper('oil')

wk.add({
	{ '-', oil('open'), desc = 'Open Oil.nvim in current directory' },
})

-- Conform mappings
local conform = util.lazy_wrapper('conform')

wk.add({
	{ '<leader>cf', conform('format'), desc = 'Format current file' },
})

-- DAP mappings
local dap = util.lazy_wrapper('dap')

wk.add({
	{ '<leader>dc', dap('continue'), desc = '[DAP] Continue' },
	{ '<leader>dn', dap('step_over'), desc = '[DAP] Step over (next)' },
	{ '<leader>di', dap('step_into'), desc = '[DAP] Step into' },
	{ '<leader>do', dap('step_out'), desc = '[DAP] Step out' },
	{ '<leader>db', dap('toggle_breakpoint'), desc = '[DAP] Toggle breakpoint' },
	{ '<leader>dB', dap('set_breakpoint'), desc = '[DAP] Set breakpoint' },
	{ '<leader>dR', dap('clear_breakpoints'), desc = '[DAP] Clear breakpoints' },
})

-- LSP-only mappings
--
-- Also registers a fallback function by default for when there is no LSP
local lsp_mappings = {
	-- [A]ctions
	{ '<leader>ca', vim.lsp.buf.code_action, desc = '[LSP] List code actions', mode = { 'n', 'v' } },
	{ '<leader>cr', vim.lsp.buf.rename, desc = '[LSP] Rename symbol' },
	-- [G]oto
	{ 'gr', builtin('lsp_references'), desc = "[LSP] Goto or find symbol's references" },
	{ 'gt', builtin('lsp_type_definitions'), desc = "[LSP] Goto or find symbol's type definition(s)" },
	{ 'gd', builtin('lsp_definitions'), desc = "[LSP] Goto or find symbol's definition(s)" },
	{ 'gD', vim.lsp.buf.declaration, desc = '[LSP] Goto symbol declaration' },
	-- [F]inders
	{ '<leader>fs', builtin('lsp_document_symbols'), desc = '[LSP] Find symbols' },
	{ '<leader>fS', builtin('lsp_workspace_symbols'), desc = '[LSP] Find workspace symbols' },
}

-- register fallback mapping
local function lsp_fallback()
	vim.notify('[No LSP] Cannot use key-binding, there is no active LSP for this buffer')
end

for _, mapping in ipairs(lsp_mappings) do
	mapping = vim.tbl_extend('force', {}, mapping)
	mapping[2] = lsp_fallback
	mapping['desc'] = mapping['desc'] .. ' (fallback)'
	wk.add(mapping)
end

-- register real LSP mappings when an LSP is attached
vim.api.nvim_create_autocmd('LspAttach', {
	group = augroup,
	callback = function(event)
		local lsp_mappings_with_buffer = vim.list_extend({}, lsp_mappings)

		for _, mapping in ipairs(lsp_mappings_with_buffer) do
			mapping['buffer'] = event.buf
		end

		wk.add(lsp_mappings_with_buffer)
	end,
})
