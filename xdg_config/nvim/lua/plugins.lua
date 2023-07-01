-- See: https://github.com/folke/lazy.nvim
return {
    {
        'numToStr/prettierrc.nvim',
    },
    {
        'numToStr/Comment.nvim',
        opts = {},
    },
    {
        'kylechui/nvim-surround',
        version = '*',
        opts = {},
    },
    {
        'nvim-tree/nvim-web-devicons',
        opts = { default = true },
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        dependencies = { 'nvim-treesitter' },
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        dependencies = { 'nvim-treesitter' },
        event = 'BufReadPost',
        opts = {},
    },
    {
        'rmagatti/auto-session',
        lazy = false,
        opts = {
            pre_save_cmds = {
                function()
                    require('nvim-tree.api').tree.close()
                    require('trouble').close()
                end,
            },
        },
    },
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        opts = {},
    },
    {
        'sindrets/diffview.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },
}
