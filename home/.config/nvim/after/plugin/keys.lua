---@module 'which-key'
local wk = require('which-key')
local util = require('tmthy.util')

-- at the top in case I want to use it many places
local augroup = vim.api.nvim_create_augroup('tmthy.keys', { clear = true })

-- Standard mappings
wk.add({
	{ '<Esc>', '<Cmd>nohl<CR>', desc = 'Clear highlight' },
	{ ']b', '<Cmd>bnext<CR>', desc = 'Swap to next buffer' },
	{ '[b', '<Cmd>bprevious<CR>', desc = 'Swap to previous buffer' },
})

-- register groups
wk.add({
	{ '<leader>f', group = 'Finders' },
	{ '<leader>a', group = 'Actions' },
})

-- Telescope non-LSP mappings
local builtin = util.lazy_wrapper('telescope.builtin')

wk.add({
	{ '<leader><space>', builtin('find_files'), desc = 'Fuzzy find files' },
	{ '<leader>fh', builtin('help_tags'), desc = 'Search help' },
	{ '<leader>fk', builtin('keymaps'), desc = 'Search for keymaps' },
})

-- Oil mappings
local oil = util.lazy_wrapper('oil')

wk.add({
	{ '<leader>e', oil('open'), desc = 'Open Oil.nvim in current directory' },
})

-- Conform mappings
local conform = util.lazy_wrapper('conform')

wk.add({
	{ '<leader>af', conform('format'), desc = 'Format current file' },
})

-- LSP-only mappings
--
-- Also registers a fallback function by default for when there is no LSP

---@type { [number]: wk.Spec }
local lsp_mappings = {
	-- [A]ctions
	{ '<leader>aa', vim.lsp.buf.code_action, desc = '[LSP] Code Action', mode = { 'n', 'v' } },
	{ '<leader>ar', vim.lsp.buf.rename, desc = '[LSP] Rename symbol' },
	-- [F]inders
	{ '<leader>fs', builtin('lsp_document_symbols'), desc = '[LSP] Find symbols' },
	{ '<leader>fS', builtin('lsp_workspace_symbols'), desc = '[LSP] Find workspace symbols' },
	{ '<leader>fr', builtin('lsp_references'), desc = '[LSP] Find symbol references' },
	{ '<leader>ft', builtin('lsp_type_definitions'), desc = "[LSP] Goto or find symbol's type definition(s)" },
	{ '<leader>fd', builtin('lsp_definitions'), desc = '[LSP] Goto or find symbol definition(s)' },
	{ '<leader>fD', vim.lsp.buf.declaration, desc = '[LSP] Goto symbol declaration' },
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
