return {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',

        'hrsh7th/cmp-vsnip',
        'hrsh7th/vim-vsnip',

        'nvim-tree/nvim-web-devicons',
        'onsails/lspkind.nvim',
    },

    config = function()
        local cmp = require('cmp')

        local lspkind = require('lspkind')
        local devicons = require('nvim-web-devicons')

        local lspkind_format = lspkind.cmp_format {
            mode = 'symbol',
        }

        cmp.setup {
            snippet = {
                expand = function(args)
                    vim.fn['vsnip#anonymous'](args.body)
                end,
            },
            formatting = {
                format = function(entry, vim_item)
                    if vim.tbl_contains({ 'path' }, entry.source.name) then
                        local icon, hl_group = devicons.get_icon(entry:get_completion_item().label)
                        if icon then
                            vim_item.kind = icon
                            vim_item.kind_hl_group = hl_group
                            return vim_item
                        end
                    end
                    return lspkind_format(entry, vim_item)
                end,
            },
            preselect = cmp.PreselectMode.Item,
            completion = {
                completeopt = 'menu,menuone,noinsert',
            },
            window = {
                documentation = {
                    border = 'rounded',
                },
            },
            mapping = cmp.mapping.preset.insert {
                ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                ['<C-d>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete {},
                ['<C-e>'] = cmp.mapping.abort(),
                ['<C-j>'] = cmp.mapping.select_next_item(),
                ['<C-k>'] = cmp.mapping.select_prev_item(),
                ['<CR>'] = cmp.mapping.confirm { select = true },
            },
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'vsnip' },
            }, {
                { name = 'buffer' },
            }),
        }
    end,
}
