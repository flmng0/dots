local M = {}

M.format = function(buf)
    local ft = vim.bo[buf].filetype
    local nls_available = require('null-ls.sources').get_available(ft, 'NULL_LS_FORMATTING')
    local have_nls = #nls_available > 0

    vim.lsp.buf.format {
        bufnr = buf,
        filter = function(client)
            if have_nls then
                return client.name == 'null-ls'
            end
            return client.name ~= 'null-ls'
        end,
    }
end

M.on_attach = function(client, buf)
    if not client.supports_method('textDocument/formatting') then
        return
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
