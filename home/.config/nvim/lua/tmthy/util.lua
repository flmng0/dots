local M = {}

local unpack = table.unpack or unpack

-- mapping utilities
-- these are currently unused, thanks to which-key.nvim

function M.map(mapping)
	local opts, mode, lhs, rhs = M.named_unpack(mapping)

	vim.keymap.set(mode, lhs, rhs, opts)
end

function M.map_all(mappings)
	for _, mapping in ipairs(mappings) do
		M.map(mapping)
	end
end

-- unpack a list-like table, and return all named keys as the
-- first return value
function M.named_unpack(t)
	local named = {}
	local unnamed = {}
	local last = 0
	for i, v in pairs(t) do
		if i == (last + 1) then
			unnamed[i] = v
			last = i
		else
			named[i] = v
		end
	end

	return named, unpack(unnamed)
end

-- wrapper for keybindings that need to be lazily required
function M.lazy_wrapper(module)
	return function(callback, ...)
		local params = { ... }
		return function()
			require(module)[callback](unpack(params))
		end
	end
end

-- Simple ensure_installed for tools based on:
-- https://github.com/williamboman/mason.nvim/issues/1309#issuecomment-1555018732
function M.mason_ensure_installed(list)
	local registry = require('mason-registry')

	for _, name in ipairs(list) do
		if not registry.is_installed(name) then
			vim.notify('[mason.nvim] installing ' .. name .. '...')
			local pkg = registry.get_package(name)
			pkg:install()
		end
	end
end

return M
