-- This is a very "fluffy" file.
--
-- A lot of the fluff is just there to make it easier to keep
-- all custom key-bindings in the same place.

local util = require('tmthy.util')

local function map_single(spec)
	local opts, modes, binding, callback = util.named_unpack(spec)

	vim.keymap.set(modes, binding, callback, opts)
end

local KeyGroup = {}
KeyGroup.__index = KeyGroup

function KeyGroup:new(keys)
	local t = {}
	setmetatable(t, self)
	t.keys = keys
	return t
end

function KeyGroup:map()
	for _, spec in ipairs(self.keys) do
		map_single(spec)
	end
end

function KeyGroup:lazy_keys()
	local out = {}
	for _, spec in ipairs(self.keys) do
		table.insert(out, spec[2])
	end
	return out
end

function KeyGroup:lazy_config()
	return function()
		self:map()
	end
end

local M = {}

M.KeyGroup = KeyGroup

local augroup = vim.api.nvim_create_augroup('tmthy.keys', { clear = true })

-- Telescope section

local builtin = util.lazy_wrapper('telescope.builtin')

M.telescope = KeyGroup:new({
	{ 'n', '<leader><space>', builtin('find_files'), desc = 'Fuzzy find files' },
	{ 'n', '<leader>fh',      builtin('help_tags'),  desc = 'Search help' },
	{ 'n', '<leader>fk',      builtin('keymaps'),    desc = 'Search for keymaps' },
})
M.telescope:map()

-- Oil section

local oil = util.lazy_wrapper('oil')

M.oil = KeyGroup:new({
	{ 'n', '<leader>e', oil('open'), desc = 'Open Oil.nvim in current directory' },
})
M.oil:map()

-- Conform section

local conform = util.lazy_wrapper('conform')

M.conform = KeyGroup:new({
	{ 'n', '<leader>af', conform('format'), desc = 'Format current file' },
})
M.conform:map()

-- LSP-only mappings
--
-- Also registers a fallback function by default for when there is no LSP

local lsp_mappings = {
	-- [A]ctions
	{ { 'n', 'v' }, '<leader>aa', vim.lsp.buf.code_action,          desc = '[LSP] Code Action' },
	{ 'n',          '<leader>ar', vim.lsp.buf.rename,               desc = '[LSP] Rename symbol' },
	-- [F]inders
	{ 'n',          '<leader>fs', builtin("lsp_document_symbols"),  desc = '[LSP] Find symbols' },
	{ 'n',          '<leader>fS', builtin("lsp_workspace_symbols"), desc = '[LSP] Find workspace symbols' },
	{ 'n',          '<leader>fr', builtin("lsp_references"),        desc = '[LSP] Find symbol references' },
	{ 'n',          '<leader>ft', builtin("lsp_type_definitions"),  desc = '[LSP] Goto or find symbol\'s type definition(s)' },
	{ 'n',          '<leader>fd', builtin("lsp_definitions"),       desc = '[LSP] Goto or find symbol definition(s)' },
	{ 'n',          '<leader>fD', vim.lsp.buf.declaration,          desc = '[LSP] Goto symbol declaration' },
}

local function lsp_fallback()
	vim.notify("[No LSP] Cannot use key-binding, there is no active LSP for this buffer")
end

for _, spec in ipairs(lsp_mappings) do
	local spec_copy = vim.tbl_extend('force', {}, spec)
	spec_copy[3] = lsp_fallback
	map_single(spec_copy)
end

local function lsp_attached(event)
	-- uses an iterator to make it easy to add the buffer option
	local it = vim.iter(lsp_mappings)

	it:map(function(v)
		local t = v
		t["buffer"] = event.buf
		return t
	end)

	local group = KeyGroup:new(it:totable())
	group:map()
end

vim.api.nvim_create_autocmd('LspAttach', {
	group = augroup,
	callback = lsp_attached,
})

return M
