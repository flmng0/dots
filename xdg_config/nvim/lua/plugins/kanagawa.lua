return {
    'rebelot/kanagawa.nvim',
    lazy = false,
    priority = 1000,

    config = function()
        require('kanagawa').setup {
            terminalColors = false,
        }

        require('kanagawa').load()
    end,
}
