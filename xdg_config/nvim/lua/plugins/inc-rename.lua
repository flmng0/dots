return {
    'smjonas/inc-rename.nvim',
    dependencies = {
        'stevearc/dressing.nvim',
    },

    config = {
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
