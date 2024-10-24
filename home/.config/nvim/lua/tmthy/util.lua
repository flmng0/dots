local M = {}

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

	return named, table.unpack(unnamed)
end

-- wrapper for keybindings that need to be lazily required
function M.lazy_wrapper(module)
	return function(callback, ...)
		local params = { ... }
		return function()
			require(module)[callback](table.unpack(params))
		end
	end
end

return M
