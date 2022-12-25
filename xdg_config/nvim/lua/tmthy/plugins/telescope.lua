local M = {
    'nvim-telescope/telescope.nvim',
    cmd = { 'Telescope' },
    dependencies = {
        'nvim-lua/plenary.nvim'
    },
}

function M.config()
    local actions = require('telescope.actions')

    require('telescope').setup {
        defaults = {
            mappings = {
                i = {
                    ['<Esc>'] = actions.close,
                }
            }
        }
    }
end

function M.init()
    local nmap = require('tmthy.utils').nmap
    local ts = require('telescope.builtin')

    -- "s" for search, e.g. "sf" => "search files"
    nmap('<leader>sf', ts.find_files)
    nmap('<leader>sg', ts.git_files)
    nmap('<leader>sr', ts.oldfiles)
    nmap('<leader>sk', ts.keymaps)

    nmap('<leader>sd', ts.diagnostics)

    nmap('<leader>s\'', ts.registers)
    nmap('<leader>sh', ts.help_tags)

    nmap('<leader>sb', ts.buffers)
end

return M
