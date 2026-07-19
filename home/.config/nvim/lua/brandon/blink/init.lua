---@module 'blink.cmp'
---@class blink.cmp.Source
local source = {}

---@alias brandon.blink.ResolveDescription fun(cb: fun(content: string))

---@class brandon.blink.ContextItem
---@field label string
---@field context brandon.Context
---@field description? brandon.blink.ResolveDescription

---@alias brandon.blink.GetCompletions fun(ctx: blink.cmp.Source, callback: fun(items: brandon.blink.ContextItem[])): (fun(): nil)

---@type table<string, brandon.blink.GetCompletions>
local providers = {
	['@'] = require('brandon.blink.file'),
	['#'] = require('brandon.blink.buffer_symbol'),
	['*'] = require('brandon.blink.workspace_symbol')
}

function source.new(opts)
	local self = setmetatable({}, { __index = source })
	self.opts = opts
	return self
end

function source:enabled()
	return vim.bo.filetype == 'brandon'
end

function source:get_trigger_characters()
	return vim.tbl_keys(providers)
end

---@param ctx_item brandon.blink.ContextItem
local function context_item_to_completion_item(ctx_item)
	---@type lsp.CompletionItem
	return {
		label = ctx_item.label,
		insertText = ctx_item.label,
		insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
		data = {
			description = ctx_item.description,
			context = ctx_item.context
		}
	}
end
---@param mapper fun(result: any): lsp.CompletionItem
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

function tmp()
	lsp_req_callback(nil, nil)
	complete_buffer_symbols(nil, nil)
	complete_workspace_symbols(nil, nil)
end

function source:get_completions(ctx, callback)
	local input = require('brandon.input').get_input_by_buf(ctx.bufnr)
	local provider_completions = providers[ctx.trigger.character]

	if input == nil or ctx.trigger.kind ~= 'trigger_character' or providers[ctx.trigger.character] == nil then
		callback({ items = {}, is_incomplete_backward = false, is_incomplete_forward = false })
		return function() end
	end

	local cancel = provider_completions(ctx, function(ctx_items)
		local items = vim.iter(ctx_items):map(context_item_to_completion_item)

		callback({
			items = items:totable(),
			is_incomplete_backward = false,
			is_incomplete_forward = false,
		})
	end)

	return function()
		if cancel ~= nil then
			cancel()
		end
	end
end

function source:resolve(item, callback)
	item = vim.deepcopy(item)

	local description = item.data.description
	if description ~= nil then
		---@cast description brandon.blink.ResolveDescription
		description(function(content)
			item.documentation = {
				kind = vim.lsp.protocol.MarkupKind.Markdown,
				value = content
			}

			callback(item)
		end)
		return
	end

	callback(item)
end

function source:execute(ctx, item, callback, default_implementation)
	default_implementation()

	-- local input = require('brandon.input').get_input_by_buf(ctx.bufnr)
	-- local context = item
	-- table.insert(input.context)

	callback()
end

return source
