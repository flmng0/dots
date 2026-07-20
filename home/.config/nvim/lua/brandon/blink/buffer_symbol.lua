---@type brandon.blink.Provider
local provider = {}

-- ---@param bufnr integer Buffer ID for the source buf (not prompt buf)
-- ---@param callback fun(response?: blink.cmp.CompletionResponse)
-- local function complete_buffer_symbols(bufnr, callback)
-- 	local cb = lsp_req_callback(symbol_result_to_completion_item, callback)
-- 	return vim.lsp.buf_request_all(bufnr, 'textDocument/documentSymbol', {
-- 		textDocument = vim.lsp.util.make_text_document_params(bufnr)
-- 	}, cb)
-- end

function provider.get_completions(ctx, callback)
	return function()
	end
end

return provider
