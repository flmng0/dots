return {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',

        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',

        'nvim-tree/nvim-web-devicons',
        'onsails/lspkind.nvim',
    },

    config = function()
        local cmp = require('cmp')
        local luasnip = require('luasnip')
        local lspkind = require('lspkind')
        local devicons = require('nvim-web-devicons')
        local has_words_before = require('tmthy.utils').has_words_before

        local lspkind_format = lspkind.cmp_format {
            mode = 'symbol',
        }

        local insert_mappings = cmp.mapping.preset.insert {
            ['<C-u>'] = cmp.mapping.scroll_docs(-4),
            ['<C-d>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete {},
            ['<C-e>'] = cmp.mapping.abort(),
            ['<C-j>'] = cmp.mapping.select_next_item(),
            ['<C-k>'] = cmp.mapping.select_prev_item(),
        }

        local mappings = {
            -- If completion menu is visible, and there is an entry,
            -- then complete it.
            --
            -- Else, if we're in a snippet, then jump to the next anchor.
            --
            -- Else, if there are words before the current cursor, attempt
            -- to complete them.
            --
            -- Finally, fallback to the default behaviour.
            ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() and cmp.get_selected_entry() then
                    cmp.confirm()
                elseif luasnip.jumpable(1) then
                    luasnip.jump(1)
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end, { 'i', 's' }),

            -- Only use S-Tab to go back to the previous snippet anchor,
            -- if it exists.
            ['<S-Tab>'] = cmp.mapping(function(fallback)
                if luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { 'i', 's' }),
        }

        for key, value in pairs(insert_mappings) do
            mappings[key] = value
        end

        cmp.setup {
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
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
            mapping = mappings,
            sources = cmp.config.sources({
                { name = 'nvim_lsp', option = { ['unocss'] = { keyword_pattern = [[\k*-]] } } },
                { name = 'luasnip' },
            }, {
                { name = 'buffer' },
            }),
        }
    end,
}
