return {
    { 'numToStr/Comment.nvim', config = true },
    { 'kylechui/nvim-surround', version = '*', config = true },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        dependencies = { 'nvim-treesitter' },
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        dependencies = { 'nvim-treesitter' },
        config = true,
    },
    {
        'karb94/neoscroll.nvim',
        config = {
            mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>' },
        },
    },
}
