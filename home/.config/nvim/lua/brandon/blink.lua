---@module 'blink.cmp'
---@class blink.cmp.Source
local source = {}

function source.new(opts)
	local self = setmetatable({}, { __index = source })
	self.opts = opts
	return self
end

function source:enabled()
	return vim.bo.filetype == 'brandon'
end

function source:get_trigger_characters()
	return { '@', '#' }
end

---@param result lsp.WorkspaceSymbol
local function symbol_result_to_completion_item(result)
	---@type lsp.CompletionItem
	return {
		label = result.name,
		insertText = result.name,
		insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
		data = result.location,
	}
end

local function lsp_req_callback(mapper, callback)
	return function(results, _, _)
		for _, res in pairs(results) do
			if res.err == nil then
				local items = vim.iter(res.result):map(mapper)
				callback({
					items = items:totable(),
					is_incomplete_backward = false,
					is_incomplete_forward = false,
				})
			end
		end
	end
end

---@param bufnr integer Buffer ID for the source buf (not prompt buf)
---@param callback fun(response?: blink.cmp.CompletionResponse)
local function complete_workspace_symbols(bufnr, callback)
	local cb = lsp_req_callback(symbol_result_to_completion_item, callback)
	return vim.lsp.buf_request_all(bufnr, 'workspace/symbol', { query = '' }, cb)
end

---@param bufnr integer Buffer ID for the source buf (not prompt buf)
---@param callback fun(response?: blink.cmp.CompletionResponse)
local function complete_buffer_symbols(bufnr, callback)
	local cb = lsp_req_callback(symbol_result_to_completion_item, callback)
	return vim.lsp.buf_request_all(bufnr, 'textDocument/documentSymbol', {
		textDocument = vim.lsp.util.make_text_document_params(bufnr)
	}, cb)
end

function source:get_completions(ctx, callback)
	local source_buf = require('brandon.input').get_source_buf(ctx.bufnr)

	if ctx.trigger.kind ~= 'trigger_character' or source_buf == nil then
		callback({ items = {}, is_incomplete_backward = false, is_incomplete_forward = false })
		return function() end
	end

	if ctx.trigger.character == '#' then
		return complete_workspace_symbols(source_buf, callback)
	elseif ctx.trigger.character == '@' then
		return complete_buffer_symbols(source_buf, callback)
	end

	error('Unreachable')
end

return source
