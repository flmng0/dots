return {
    'windwp/nvim-autopairs',
    dependencies = {
        -- For setting up function completions inserting parens
        'hrsh7th/nvim-cmp',
    },

    config = function()
        require('nvim-autopairs').setup {}

        local autopairs_cmp = require('nvim-autopairs.completion.cmp')
        local cmp = require('cmp')

        cmp.event:on(
            'confirm_done',
            autopairs_cmp.on_confirm_done()
        )
    end,
}
