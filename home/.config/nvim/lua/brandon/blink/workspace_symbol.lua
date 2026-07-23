---@type brandon.blink.Provider
local provider = {}

---@param symbol lsp.WorkspaceSymbol
---@param bufnr integer
---@param encoding lsp.PositionEncodingKind
local function symbol_to_completion_item(symbol, bufnr, encoding)
	local label = symbol.name

	---@type brandon.blink.ContextItem
	return {
		label = label,
		context = {
			type = 'symbol',
			name = label,
			file_path = symbol.location.uri,
			range = vim.range.lsp(bufnr, symbol.location.range, encoding),
		}
	}
end

function provider.get_completions(ctx, callback)
	local clients = vim.lsp.get_clients({
		bufnr = ctx.bufnr,
		method = 'workspace/symbol',
	})

	if #clients == 0 then
		vim.notify('WARN: No LSP clients support \'workspace/symbol\'', vim.log.levels.WARN)
		callback({})
		return
	end

	local cancels = {}

	for client_id, client in pairs(clients) do
		local success, request_id = client:request('workspace/symbol', { query = '' }, function(err, symbols, _, _)
			if err ~= nil then
				callback({})
				return
			end

			---@cast client vim.lsp.Client
			local items = vim.iter(symbols):map(function(sym)
				return symbol_to_completion_item(sym, ctx.bufnr, client.offset_encoding)
			end):totable()

			callback(items)
		end)

		if success then
			---@cast request_id number
			cancels[client_id] = function()
				client:cancel_request(request_id)
			end
		end
	end

	return function()
		for _, cancel in pairs(cancels) do
			cancel()
		end
	end
end

return provider
