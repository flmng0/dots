-- See: https://github.com/folke/lazy.nvim
return {
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
        'JASONews/glow-hover',
        cond = os.execute('command -v ' .. vim.fn.expand('$GOPATH/bin/glow')) == 0,
        event = 'VeryLazy',
        opts = {
            max_width = 50,
            padding = 3,
            glow_path = vim.fn.expand("$GOPATH/bin/glow"),
        },
    },
    {
        'rmagatti/auto-session',
        lazy = false,
        opts = {},
    },
    {
        'windwp/nvim-autopairs',
        opts = {},
    },
}
