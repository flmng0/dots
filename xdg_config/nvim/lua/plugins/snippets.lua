return {
    -- Snippet manager configuration
    {
        'hrsh7th/vim-vsnip',
        dependencies = { 'hrsh7th/vim-vsnip-integ' },

        init = function()
            local map = require('tmthy.utils').map

            map({ 'i' }, '<C-j>', function()
                if vim.fn['vsnip#expandable']() == 1 then
                    return [[<Plug>(vsnip-expand)]]
                end
                return '<C-j>'
            end, {
                expr = true,
                remap = true,
                desc = 'Expand snippet if valid',
            })
        end,
    },

    -- Snippet pluggins
    { 'Nash0x7E2/awesome-flutter-snippets' },
}
