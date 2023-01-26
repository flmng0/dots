-- See: https://github.com/folke/lazy.nvim
return {
    {
        'numToStr/Comment.nvim',
        config = true,
    },
    {
        'kylechui/nvim-surround',
        version = '*',
        config = true,
    },
    {
        'nvim-tree/nvim-web-devicons',
        config = { default = true },
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        dependencies = { 'nvim-treesitter' },
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        dependencies = { 'nvim-treesitter' },
        event = 'BufReadPost',
        config = true,
    },
    {
        'JASONews/glow-hover',
        event = 'VeryLazy',
        config = {
            max_width = 50,
            padding = 3,
            glow_path = vim.fn.expand("$GOPATH/bin/glow"),
        },
    },
    {
        'karb94/neoscroll.nvim',
        event = 'VeryLazy',
        config = {
            mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>' },
        },
    },
    {
        'rmagatti/auto-session',
        lazy = false,
        config = true,
    },
}
