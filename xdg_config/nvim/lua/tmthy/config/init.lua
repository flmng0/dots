-- This module is like an 'after' directory, but doing it this
-- way stops errors from happening on first startup.

local configs = {
    'bufferline',
    'lsp',
    'lualine',
    'nvim-cmp',
    'nvim-tree',
    'smart-splits',
    'telescope',
    'treesitter',
}

for _, config in ipairs(configs) do
    require('tmthy.config.'..config)
end
