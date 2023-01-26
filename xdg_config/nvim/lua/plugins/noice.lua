return {
    'folke/noice.nvim',
    -- Until it improves in the future, I think I might disable this.
    enabled = false,
    dependencies = {
        'MunifTanjim/nui.nvim',
        'rcarriga/nvim-notify',
        'smjonas/inc-rename.nvim',
    },

    config = function()
        require('noice').setup {
            lsp = {
                override = {
                    ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                    ['vim.lsp.util.stylize_markdown'] = true,
                    ['cmp.entry.get_documentation'] = true,
                },
            },
            routes = {
                -- TODO: Figure out a good solution to hiding the default
                --      messages, like for "Undo", "Redo", "Write", "Paste", etc.
                {
                    filter = {
                        any = {
                            { find = '%d*L, %d*B' },
                            { find = 'before #%d+' },
                            { find = '%d* fewer' },
                            { find = '%d* more' },
                            { find = '%d* lines' },
                        },
                        event = 'msg_show',
                        kind = '',
                    },
                    opts = { skip = true, },
                },
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = true,
                -- TODO: Try this one
                lsp_doc_border = false,
            },
        }
    end
}

