return {
    -- Yay rust!
    'simrat39/rust-tools.nvim',

    dependencies = {
        'neovim/nvim-lspconfig',
        'nvim-lua/plenary.nvim',
        'mfussenegger/nvim-dap',
    },

    config = function()
        local rt = require('rust-tools')
        local on_attach = require('plugins.lsp').on_attach

        rt.setup {
            inlay_hints = {
                auto = true,
                only_current_line = false,
                show_parameter_hints = true,
                parameter_hints_prefix = ": ",
                other_hints_prefix = "=> ",
                max_len_align = false,
                -- max_len_align_padding = 1,
                right_align = false,
                -- right_align_padding = 1,
                highlight = "Comment",
            },
            server = {
                on_attach = on_attach,
                cmd = { "rustup", "run", "stable", "rust-analyzer" },
                settings = {
                    ["rust-analyzer"] = {
                        rustfmt = {
                            extraArgs = {
                                "+nightly",
                            }
                        }
                    }
                }
            }
        }
    end
}
