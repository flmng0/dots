return {
    { 'numToStr/Comment.nvim', config = true },
    { 'kylechui/nvim-surround', version = '*', config = true },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        dependencies = { 'nvim-treesitter' }
    },
}
