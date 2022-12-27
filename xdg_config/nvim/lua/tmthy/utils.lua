local M = {}

function M.map(modes, keys, func, desc)
    vim.keymap.set(modes, keys, func, { desc = desc })
end

for _, mode in ipairs({ 'i', 'v', 'n' }) do
    M[mode .. 'map'] = function(keys, func, desc)
        vim.keymap.set(mode, keys, func, { desc = desc })
    end
end

function M.has_words_before()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

return M
