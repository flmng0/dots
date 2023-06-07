return {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lsp-signature-help',
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
            preselect = cmp.PreselectMode.None,
            completion = {
                keyword_length = 1,
                -- ---@diagnostic disable-next-line: assign-type-mismatch
                -- autocomplete = false,
                completeopt = 'menu,menuone,preview,noinsert,noselect',
            },
            window = {
                documentation = {
                    border = 'rounded',
                },
            },
            mapping = {
                ['<C-Space>'] = cmp.mapping(function(fallback)
                    if not cmp.get_active_entry() then
                        if not cmp.visible() then
                            cmp.complete { reason = cmp.ContextReason.Manual }
                        end
                        cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
                    else
                        fallback()
                    end
                end, { 'c', 'i' }),

                ['<C-j>'] = cmp.mapping(function(fallback)
                    local active = cmp.get_active_entry()

                    if active ~= nil then
                        local entries = cmp.get_entries()
                        local length = #entries

                        if active == entries[length] then
                            cmp.select_prev_item {
                                behavior = cmp.SelectBehavior.Insert,
                                count = length - 1,
                            }
                        else
                            cmp.select_next_item {
                                behavior = cmp.SelectBehavior.Insert,
                            }
                        end
                    else
                        fallback()
                    end
                end, { 'c', 'i' }),

                ['<C-k>'] = cmp.mapping(function(fallback)
                    local active = cmp.get_active_entry()

                    if active ~= nil then
                        local entries = cmp.get_entries()
                        local length = #entries

                        if active == entries[1] then
                            cmp.select_next_item {
                                behavior = cmp.SelectBehavior.Insert,
                                count = length - 1,
                            }
                        else
                            cmp.select_prev_item {
                                behavior = cmp.SelectBehavior.Insert,
                            }
                        end
                    else
                        fallback()
                    end
                end, { 'c', 'i' }),

                ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'c', 'i' }),
                ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'c', 'i' }),
                ['<C-e>'] = cmp.mapping(cmp.mapping.abort(), { 'c', 'i' }),
                ['<CR>'] = cmp.mapping {
                    c = function(fallback)
                        if cmp.visible() then
                            cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
                        else
                            fallback()
                        end
                    end,
                    i = cmp.mapping.confirm {
                        behaviour = cmp.ConfirmBehavior.Replace,
                        select = false,
                    },
                },
            },
            sources = cmp.config.sources({
                { name = 'vsnip' },
                { name = 'nvim_lsp' },
                -- { name = 'nvim_lsp_signature_help' },
            }, {
                { name = 'buffer' },
            }),
        }

        -- Insert parentheses after function
        local cmp_autopairs = require('nvim-autopairs.completion.cmp')

        cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

        cmp.event:on('confirm_done', function()
            cmp.abort()
        end)
    end,
}
