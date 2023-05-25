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

        local function t(cmd)
            return vim.api.nvim_replace_termcodes(cmd, true, true, true)
        end

        local function jump_forward()
            vim.api.nvim_feedkeys(t('<Plug>(vsnip-jump-next)'), 'm', true)
        end
        local function jump_backward()
            vim.api.nvim_feedkeys(t('<Plug>(vsnip-jump-prev)'), 'm', true)
        end

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
                keyword_length = 1,
                -- ---@diagnostic disable-next-line: assign-type-mismatch
                -- autocomplete = false,
                completeopt = 'menu,menuone,noinsert,preview',
            },
            window = {
                documentation = {
                    border = 'rounded',
                },
            },
            mapping = {
                ['<Tab>'] = cmp.mapping {
                    c = function()
                        if cmp.visible() then
                            cmp.select_next_item { behaviour = cmp.SelectBehavior.Insert }
                        else
                            cmp.complete()
                        end
                    end,
                    i = function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item { behaviour = cmp.SelectBehavior.Insert }
                        elseif vim.fn['vsnip#jumpable'](1) == 1 then
                            jump_forward()
                        else
                            fallback()
                        end
                    end,
                    s = function(fallback)
                        if vim.fn['vsnip#jumpable'](1) == 1 then
                            jump_forward()
                        else
                            fallback()
                        end
                    end,
                },
                ['<S-Tab>'] = cmp.mapping {
                    c = function()
                        if cmp.visible() then
                            cmp.select_prev_item { behaviour = cmp.SelectBehavior.Insert }
                        else
                            cmp.complete()
                        end
                    end,
                    i = function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item { behaviour = cmp.SelectBehavior.Insert }
                        elseif vim.fn['vsnip#jumpable'](-1) == 1 then
                            jump_backward()
                        else
                            fallback()
                        end
                    end,
                    s = function(fallback)
                        if vim.fn['vsnip#jumpable'](-1) == 1 then
                            jump_backward()
                        else
                            fallback()
                        end
                    end,
                },
                ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'c', 'i' }),
                ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'c', 'i' }),
                ['<C-Space>'] = cmp.mapping(cmp.mapping.complete {}, { 'c', 'i' }),
                ['<C-e>'] = cmp.mapping(cmp.mapping.abort(), { 'c', 'i' }),
                ['<CR>'] = cmp.mapping {
                    c = function(fallback)
                        if cmp.visible() then
                            cmp.confirm { behaviour = cmp.ConfirmBehavior.Replace, select = false }
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
