local M = {}

local default_map_opts = { noremap = true, silent = true }

local function map_(modes, keys, func, opts)
    local real_opts = vim.tbl_extend('force', default_map_opts, opts or {})
    vim.keymap.set(modes, keys, func, real_opts)
end

function M.map(modes, keys, func, desc_or_opts)
    local opts = desc_or_opts
    if type(desc_or_opts) == 'string' then
        opts = { desc = desc_or_opts }
    end
    map_(modes, keys, func, opts)
end

for _, mode in ipairs({ 'i', 'v', 'n' }) do
    M[mode .. 'map'] = function(keys, func, desc)
        map_(mode, keys, func, { desc = desc })
    end
end

-- Simple wrapper to convert a string `cmd_string` into:
--  <cmd>{cmd_string}<CR>
function M.cmd(cmd_string)
    return '<cmd>'..cmd_string..'<CR>'
end

function M.has_words_before()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

return M
