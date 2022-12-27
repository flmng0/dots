local M = {
    'nvim-treesitter/nvim-treesitter',
    build = function()
        require('nvim-treesitter.install').update {
            with_sync = true
        }
    end
}

function M.config()
    require('nvim-treesitter.configs').setup {
        ensure_installed = { 'go', 'rust', 'javascript', 'typescript', 'help', 'vim', 'lua', 'svelte' },

        highlight = { enable = true },
        indent = { enable = true },
        textobjects = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ['aa'] = '@parameter.outer',
                    ['ia'] = '@parameter.inner',
                    ['af'] = '@function.outer',
                    ['if'] = '@function.inner',
                    ['ac'] = '@class.outer',
                    ['ic'] = '@class.inner',
                },
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = {
                    [']a'] = '@parameter.inner',
                    [']f'] = '@function.outer',
                    [']]'] = '@class.outer',
                },
                goto_next_end = {
                    [']A'] = '@parameter.inner',
                    [']F'] = '@function.outer',
                    [']['] = '@class.outer',
                },
                goto_previous_start = {
                    ['[a'] = '@parameter.inner',
                    ['[f'] = '@function.outer',
                    ['[['] = '@class.outer',
                },
                goto_previous_end = {
                    ['[A'] = '@parameter.inner',
                    ['[F'] = '@function.outer',
                    ['[]'] = '@class.outer',
                },
            },
        },
    }
end

return M
