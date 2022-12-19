local config = function()
    local actions = require('telescope.actions')

    require('telescope').setup {
        defaults = {
            mappings = {
                i = {
                    ['<Esc>'] = actions.close,
                },
            },
        },
    }
end

return config
