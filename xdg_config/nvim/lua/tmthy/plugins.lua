return {
    {
        'navarasu/onedark.nvim',
        init = function()
            require('onedark').load()
        end
    },
    { 'numToStr/Comment.nvim', config = true },
    { 'kylechui/nvim-surround', version = '*', config = true },

    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        dependencies = { 'nvim-treesitter' }
    }
}
