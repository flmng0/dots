local M = {}

local formatters = {}

local make_formatter = function(ft)
    local nls_sources = require('null-ls.sources')
    local nls_methods = require('null-ls.methods')
    local nls_available = nls_sources.get_available(ft, nls_methods.internal.FORMATTING)
        or nls_sources.get_available(ft, nls_methods.lsp.FORMATTING)
    local have_nls = #nls_available > 0

    local filter = function(client)
        if have_nls then
            return client.name == 'null-ls'
        end

        return client.name ~= 'null-ls'
    end

    return function(buf)
        vim.lsp.buf.format {
            bufnr = buf,
            filter = filter,
        }
    end
end

M.format = function(buf)
    local ft = vim.bo[buf].filetype
    local format = formatters[ft]

    if format == nil then
        format = make_formatter(ft)
        formatters[ft] = format
    end

    format(buf)
end

M.on_attach = function(client, buf)
    if not client.supports_method('textDocument/formatting') then
        return
    end

    local ft = vim.bo[buf].filetype
    if formatters[ft] == nil then
        formatters[ft] = make_formatter(ft)
    end

    vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('LspFormat.' .. buf, {}),
        buffer = buf,
        callback = function()
            M.format(buf)
        end,
    })
end

return M
