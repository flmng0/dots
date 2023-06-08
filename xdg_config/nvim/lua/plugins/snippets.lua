return {
    -- Snippet manager configuration
    {
        'hrsh7th/vim-vsnip',
        dependencies = { 'hrsh7th/vim-vsnip-integ' },

        init = function()
            local map = require('tmthy.utils').map

            map({ 'i' }, '<C-Tab>', function()
                if vim.fn['vsnip#expandable']() == 1 then
                    return [[<Plug>(vsnip-expand)]]
                end
                return '<C-Tab>'
            end, {
                expr = true,
                remap = true,
                desc = 'Expand snippet if valid',
            })

            map({ 's', 'i' }, '<Tab>', function()
                if vim.fn['vsnip#jumpable'](1) == 1 then
                    return [[<Plug>(vsnip-jump-next)]]
                end
                return '<Tab>'
            end, {
                expr = true,
                remap = true,
                desc = 'Jump to next snippet point',
            })

            map({ 's', 'i' }, '<S-Tab>', function()
                if vim.fn['vsnip#jumpable'](-1) == 1 then
                    return [[<Plug>(vsnip-jump-prev)]]
                end
                return '<S-Tab>'
            end, {
                expr = true,
                remap = true,
                desc = 'Jump to next snippet point',
            })
        end,
    },

    -- Snippet pluggins
    { 'Nash0x7E2/awesome-flutter-snippets' },
}
