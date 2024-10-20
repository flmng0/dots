-- This is a very "fluffy" file.
--
-- A lot of the fluff is just there to make it easier to keep 
-- all custom key-bindings in the same place.

local util = require('tmthy.util')

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
        local opts, modes, binding, callback = util.named_unpack(spec)

        vim.keymap.set(modes, binding, callback, opts)
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


-- wrapper for keybindings that need to be lazily required
local function lazy_wrapper(module)
    return function(callback, ...)
        local params = {...}
        return function()
            require(module)[callback](table.unpack(params))
        end
    end
end


local M = {}

local augroup = vim.api.nvim_create_augroup('tmthy.keys', { clear = true })

-- Telescope section

local builtin = lazy_wrapper('telescope.builtin')

local function lsp_builtin(picker)
    local cb = builtin(picker)
    return function()
        local lsp_clients = vim.lsp.get_clients()
        if #lsp_clients == 0 then
            vim.notify("No active LSP client. Cannot open picker: " .. picker)
        else
            cb()
        end
    end
end

M.telescope = KeyGroup:new({
    { 'n', '<leader><space>', builtin('find_files'), desc = 'Fuzzy find files' },
    { 'n', '<leader>fh', builtin('help_tags'), desc = 'Search help' },
    { 'n', '<leader>fk', builtin('keymaps'), desc = 'Search for keymaps' },
})
M.telescope:map()

-- Oil section

local oil = lazy_wrapper('oil')

M.oil = KeyGroup:new({
    { 'n', '<leader>e', oil('open'), desc = 'Open Oil.nvim in current directory' },
})
M.oil:map()

-- LSP-only mappings
local function lsp_attached(event)
    -- uses an iterator to make it easy to add the buffer option
    local it = vim.iter({
        -- Misc
        { 'n', '<leader>A', vim.lsp.buf.code_action, '[LSP] Code Action' },
        -- Symbol-mappings
        { 'n', '<leader>sr', vim.lsp.buf.rename, '[LSP] Rename symbol' },
        { 'n', '<leader>sR', require('telescope.builtin').lsp_references, '[LSP] Find symbol references' },
        { 'n', '<leader>st', require('telescope.builtin').lsp_type_definitions, '[LSP] Goto or find symbol\'s type definition(s)' },
        { 'n', '<leader>sd', require('telescope.builtin').lsp_definitions, '[LSP] Goto or find symbol definition(s)' },
        { 'n', '<leader>sD', vim.lsp.buf.declaration, '[LSP] Goto symbol declaration' },
    })
    
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
