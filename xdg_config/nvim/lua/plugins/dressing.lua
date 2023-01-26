return {
    'stevearc/dressing.nvim',
    config = {
        input = {
            override = function(conf)
                conf.col = -1
                conf.row = 0
                return conf
            end
        }
    },
}
