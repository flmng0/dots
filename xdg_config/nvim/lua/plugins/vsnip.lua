return {
    'hrsh7th/vim-vsnip',

    init = function()
        local map = require('tmthy.utils').map

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
}
