local M = {}

---@param client lsp.Client
M.supports_formatting = function(client)
    if
        client.config
        and client.config.capabilities
        and client.config.capabilities.documentFormattingProvider == false
    then
        return false
    end

    return client.supports_method('textDocument/formatting')
        or client.supports_method('textDocument/rangeFormatting')
end

M.get_formatters = function(bufnr)
    local ft = vim.bo[bufnr].filetype

    local null_ls = require('null-ls.sources').get_available(ft, 'NULL_LS_FORMATTING')

    local formatters = {}

    ---@type lsp.Client[]
    local clients = vim.lsp.get_active_clients { bufnr = bufnr }
    for _, client in ipairs(clients) do
        if M.supports_formatting(client) then
            if (#null_ls > 0 and client.name == 'null-ls') or #null_ls == 0 then
                table.insert(formatters, client)
            end
        end
    end

    return formatters
end

M.format = function()
    local buf = vim.api.nvim_get_current_buf()

    local formatters = M.get_formatters(buf)
    local client_ids = vim.tbl_map(function(client)
        return client.id
    end, formatters)

    if #client_ids == 0 then
        return
    end

    vim.lsp.buf.format {
        bufnr = buf,
        filter = function(client)
            return vim.tbl_contains(client_ids, client.id)
        end,
    }
end

M.setup = function()
    vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('LspFormat', {}),
        callback = function()
            M.format()
        end,
    })
end

return M
