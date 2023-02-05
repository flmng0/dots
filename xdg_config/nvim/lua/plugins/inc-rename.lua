return {
    'smjonas/inc-rename.nvim',
    dependencies = {
        'stevearc/dressing.nvim',
    },

    opts = {
        input_buffer_type = 'dressing'
    },

    cmd = 'IncRename',
    keys = {
        {
            '<leader>r',
            ':IncRename ',
            desc = 'Rename Symbol',
            silent = true,
        },
    },
}
