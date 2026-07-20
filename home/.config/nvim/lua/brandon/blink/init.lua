---@module 'blink.cmp'
---@class blink.cmp.Source
local source = {}

---@alias brandon.blink.ResolveDescription fun(cb: fun(content: string))

---@class brandon.blink.ContextItem
---@field label string
---@field context brandon.Context
---@field description? brandon.blink.ResolveDescription

---@class brandon.blink.Provider
---@field make_context_part? fun(ctx: blink.cmp.Context, item: brandon.blink.ContextItem): any
---@field get_completions? fun(ctx: blink.cmp.Context, callback: fun(items: brandon.blink.ContextItem[])): (fun(): nil)

---@type table<string, brandon.blink.Provider>
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

function source:get_completions(ctx, callback)
	local input = require('brandon.input').get_input_by_buf(ctx.bufnr)
	local provider = providers[ctx.trigger.character] or {}

	if input == nil or ctx.trigger.kind ~= 'trigger_character' or provider.get_completions == nil then
		callback({ items = {}, is_incomplete_backward = false, is_incomplete_forward = false })
		return function() end
	end

	local cancel = provider.get_completions(ctx, function(ctx_items)
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

	local context = item.data.context
	local input = require('brandon.input').get_input_by_buf(ctx.bufnr)
	if input ~= nil and context ~= nil then
		table.insert(input.context, context)
	end

	callback()
end

return source
